#! /usr/bin/env python

import argparse
import sys
import os
import datetime
import multiprocessing
from dateutil.parser import parse

def parseCommandLineArguments():
    parser = argparse.ArgumentParser(prog="abridge",description="Align genomic and transcriptomic reads using STAR")
    required_named = parser.add_argument_group('Required arguments')
    optional_named = parser.add_argument_group('Optional arguments')
    
    required_named.add_argument("--metadata_filename","-md",help="Enter the metadata file to generate alignments",required=True)
    required_named.add_argument("--output_directory","-o",help="Enter the output directory",required=True)
    required_named.add_argument("--star_genome_index","-i",help="Enter the location of the STAR index",required=True)
    required_named.add_argument("--input_location","-loc",help="Enter the location of the raw fastq files. For this program all fastq files must be located under the same directory",required=True)
    
    optional_named.add_argument("--cpu","-n",help="Enter the number of CPUs. Please note that all alignments will be conducted using a single CPU. This argument will control how many parallel alignments can be lanuched", default=1)
    optional_named.add_argument("--num_times","-t",help="Enter the number of times to run the alignments to estimate time",default = 5)
    
    return parser.parse_args() 

def readMetadataFile(options):
    options.metadata = {}
    fhr=open(options.metadata_filename,"r")
    for line_num,line in enumerate(fhr):
        if line_num==0:continue
        Organism,Tissue,Layout,Assay_Type,Date_of_publication,Read_Length,SRA = line.strip().split(",")[:7]
        options.metadata[SRA]={"organism":Organism,
                               "layout":Layout,
                               "assay_type":Assay_Type}
    fhr.close()

def runCommand(eachpinput):
    cmd,dummy = eachpinput
    os.system(cmd)

def mapSamplesToReference(options):
    
    pool = multiprocessing.Pool(processes=int(options.cpu))
    os.system("mkdir -p "+options.output_directory)
    list_of_all_commands = []
    for sra in options.metadata:
        for iteration in range(int(options.num_times)):
            cmd = "STAR "
            cmd+= " --runThreadN 1 " # always run with one CPU
            cmd+= " --genomeDir "+options.star_genome_index
            cmd+=" --outSAMtype BAM SortedByCoordinate "
            cmd+=" --outFilterMultimapNmax 10000 " 
            cmd+=" --outFilterMismatchNmax 25  " 
            cmd+=" --limitBAMsortRAM 107374182400" # 100 GB
            cmd+=" --outFilterScoreMinOverLread 0.75 "
            cmd+=" --outFilterMatchNminOverLread 0.75 "
            cmd+=" --outSAMattributes NH HI AS nM NM MD jM jI XS "
            cmd+=" --outSAMunmapped Within "
            cmd+=" --genomeLoad Remove "
            cmd+=" --outFileNamePrefix "+options.output_directory+"/"+sra+"_"+str(iteration)+"_"
            if options.metadata[sra]["layout"]=="SE":
                cmd+=" --readFilesIn "+options.input_location+"/"+sra+".fastq"
            else:
                cmd+=" --readFilesIn "+options.input_location+"/"+sra+"_1.fastq "+options.input_location+"/"+sra+"_2.fastq "
            if options.metadata[sra]["layout"] == "RNA-Seq":
                cmd+=" --alignIntronMin 20  "
                cmd+=" --alignIntronMax 100000 "
            else:
                cmd+=" --alignIntronMin 1 "
                cmd+=" --alignIntronMax 1 "
            if os.path.exists(options.output_directory+"/"+sra+"_"+str(iteration)+"_Log.final.out")==False:
                list_of_all_commands.append([cmd,"dummy"])
                print()
                print(cmd)
                print()
                
    pool.map(runCommand,list_of_all_commands)
    
    ##################################################################################################
    # Remove all the useless files and rename the alignment file
    ##################################################################################################
    
    files_to_be_removed=[]
    for sra in options.metadata:
        for iteration in range(int(options.num_times)):
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_Log.out")
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_Log.progress.out")
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_SJ.out.tab")
            
            if iteration==0:
                cmd="mv "
                cmd+=options.output_directory+"/"+sra+"_"+str(iteration)+"_Aligned.sortedByCoord.out.bam "
                cmd+=options.output_directory+"/"+sra+"_"+options.metadata[sra]["layout"]+".bam "
                os.system(cmd)
            else:
                files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_Aligned.sortedByCoord.out.bam")
    
    for file in files_to_be_removed:
        os.system("rm "+file)
            
            

def mergePairedEndedSamplesIntoSingleEnded(options):
    """
    Combine the two pairs of reads and rename them
    """
    for sra in options.metadata:
        if options.metadata[sra]["layout"]=="SE":continue
        output_filename = options.input_location+"/"+sra+"_0.fastq"
        input_filename_1 = options.input_location+"/"+sra+"_1.fastq"
        input_filename_2 = options.input_location+"/"+sra+"_2.fastq"
        if os.path.exists(output_filename):continue
        counter=1
        fhw=open(output_filename,"w")
        fhr1=open(input_filename_1,"w")
        for line_num,line in enumerate(fhr1):
            if line_num%4==0:
                fhw.write("@"+str(counter)+"\n")
                counter+=1
                fhw.write(fhr1.readline())
                fhw.write(fhr1.readline())
                fhw.write(fhr1.readline())
        fhr1.close()
        
        fhr2=open(input_filename_2,"w")
        for line_num,line in enumerate(fhr1):
            if line_num%4==0:
                fhw.write("@"+str(counter)+"\n")
                counter+=1
                fhw.write(fhr2.readline())
                fhw.write(fhr2.readline())
                fhw.write(fhr2.readline())
        fhr2.close()
        fhw.close()

def convertBamToSam(options):
    for sra in options.metadata:
        bamfilename = options.output_directory+"/"+sra+"_SE.bam"
        samfilename = options.output_directory+"/"+sra+"_SE.sam"
        if os.path.exists(samfilename):continue
        cmd = "samtools view -h -@ "+options.cpu+" "+bamfilename+" > "+samfilename
        os.system(cmd)
        
        bamfilename = options.output_directory+"/"+sra+"_PE.bam"
        samfilename = options.output_directory+"/"+sra+"_PE.sam"
        if os.path.exists(samfilename):continue
        cmd = "samtools view -h -@ "+options.cpu+" "+bamfilename+" > "+samfilename
        os.system(cmd)

def compileDurationOfExecutionFile(options):
    for sra in options.metadata:
        for iteration in range(int(options.num_times)):
            STAR_log_filename = options.output_directory+"/"+sra+"_"+str(iteration)+"_Log.final.out"
            fhr=open(STAR_log_filename,"r")
            started_on=fhr.readline()
            fhr.readline()
            ended_on=fhr.readline()
            fhr.close()
            started_on = started_on.split()[-1]
            ended_on = ended_on.split()[-1]
            parse(started_on)
            parse(ended_on)
            print(sra,iteration,(ended_on-started_on).total_seconds())

def main():
    commandLineArg=sys.argv
    if len(commandLineArg)==1:
        print("Please use the --help option to get usage information")
    options=parseCommandLineArguments()
    
    readMetadataFile(options)
    
    #mergePairedEndedSamplesIntoSingleEnded(options)
    
    mapSamplesToReference(options)
    
    convertBamToSam(options)
    
    #compileDurationOfExecutionFile(options)


if __name__ == "__main__":
    main()