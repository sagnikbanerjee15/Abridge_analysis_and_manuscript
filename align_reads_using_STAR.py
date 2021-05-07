#! /project/maizegdb/sagnik/softwares/anaconda/bin/python

import argparse
import sys
import os
import datetime
import multiprocessing
import pprint
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
    options.metadata = []
    fhr=open(options.metadata_filename,"r")
    for line_num,line in enumerate(fhr):
        Organism,Tissue,Layout,Assay_Type,Date_of_publication,Read_Length,SRA = line.strip().split(",")[:7]
        options.metadata.append([SRA,Layout,Assay_Type])
    fhr.close()

def runCommand(eachpinput):
    cmd,dummy = eachpinput
    os.system(cmd)
    
def isEmpty(filename):
    if os.path.exists(filename) == False:
        return True
    else:
        if os.stat(filename).st_size == 0:
            return True
    return False
    
def mapSamplesToReference(options):
    pool = multiprocessing.Pool(processes=int(options.cpu))
    os.system("mkdir -p "+options.output_directory)
    list_of_all_commands = []
    for row in options.metadata:
        sra,layout,assay_type = row
        for iteration in range(int(options.num_times)):
            cmd ="STAR "
            cmd+=" --runThreadN 1 " # always run with one CPU
            cmd+=" --genomeDir "+options.star_genome_index
            cmd+=" --outSAMtype BAM SortedByCoordinate "
            cmd+=" --outFilterMultimapNmax 10000 " 
            cmd+=" --outFilterMismatchNmax 25  " 
            cmd+=" --outBAMsortingThreadN 1 " # Use a single CPU for sorting
            cmd+=" --limitBAMsortRAM 107374182400" # 100 GB
            cmd+=" --outFilterScoreMinOverLread 0.75 "
            cmd+=" --outFilterMatchNminOverLread 0.75 "
            cmd+=" --outSAMattributes NH HI AS nM NM MD jM jI XS "
            cmd+=" --outSAMunmapped Within "
            #cmd+=" --genomeLoad Remove "
            if layout=="SE":
                cmd+=" --readFilesIn "+options.input_location+"/"+sra+".fastq.gz "
                cmd+=" --outFileNamePrefix "+options.output_directory+"/"+sra+"_"+str(iteration)+"_SE_"
            else:
                cmd+=" --readFilesIn "+options.input_location+"/"+sra+"_1.fastq.gz "+options.input_location+"/"+sra+"_2.fastq.gz "
                cmd+=" --outFileNamePrefix "+options.output_directory+"/"+sra+"_"+str(iteration)+"_PE_"
            if assay_type == "RNA-Seq":
                cmd+=" --alignIntronMin 20  "
                cmd+=" --alignIntronMax 100000 "
            else:
                cmd+=" --alignIntronMin 1 "
                cmd+=" --alignIntronMax 1 "
            cmd+=f"1> {options.output_directory}/{sra}_{iteration}_{layout}.output "
            cmd+=f"1> {options.output_directory}/{sra}_{iteration}_{layout}.error "

            if os.path.exists(options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_Log.final.out")==False: 
                list_of_all_commands.append([cmd,"dummy"])
                os.system(cmd)
            
            if iteration==0:
                if os.path.exists(options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_Aligned.sortedByCoord.out.bam")==False and os.path.exists(options.output_directory+"/"+sra+"_"+layout+".bam")==True:continue
                cmd="mv "
                cmd+=options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_Aligned.sortedByCoord.out.bam "
                cmd+=options.output_directory+"/"+sra+"_"+layout+".bam "
                os.system(cmd)
                
            files_to_be_removed=[]
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_Log.out")
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_Log.progress.out")
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_SJ.out.tab")
            files_to_be_removed.append(options.output_directory+"/"+sra+"_"+str(iteration)+"_"+layout+"_Aligned.sortedByCoord.out.bam")
            
            for file in files_to_be_removed:
                os.system("rm -f "+file)
    #pool.map(runCommand,list_of_all_commands)
            
            

def mergePairedEndedSamplesIntoSingleEnded(eachinput):
    """
    Combine the two pairs of reads and rename them
    """
    options, sra = eachinput
    
    output_filename = options.input_location+"/"+sra+"_0.fastq"
    input_filename_1 = options.input_location+"/"+sra+"_1.fastq"
    input_filename_2 = options.input_location+"/"+sra+"_2.fastq"
    
    if os.path.exists(f"{output_filename}.gz") == True:return
    cmd = f"gunzip -c {input_filename_1}.gz > {input_filename_1}"
    os.system(cmd)
    cmd = f"gunzip -c {input_filename_2}.gz > {input_filename_2}"
    os.system(cmd)
    
    fhw=open(output_filename,"w")
    for fhr in [open(input_filename_1,"r") ,open(input_filename_2,"r")]:
        for line_num,line in enumerate(fhr):
            if line_num % 4 == 0 and line[0]=='@' and '/' in line:
                line = line.replace('/','_')
            fhw.write(line)
    fhw.close()
    
    cmd = f"rm {input_filename_1} {input_filename_2}"
    os.system(cmd)
    
    cmd = f"gzip -9 {output_filename}"
    os.system(cmd)

def convertBamToSam(options):
    for row in options.metadata:
        sra,layout,assay_type = row
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
    
    pool = multiprocessing.Pool(processes=int(options.cpu))
    list_of_all_commands=[]
    for row in options.metadata:
        sra,layout,assay_type = row
        if layout=="SE":continue
        list_of_all_commands.append([options,sra])
    pool.map(mergePairedEndedSamplesIntoSingleEnded,list_of_all_commands)
    return
    mapSamplesToReference(options)
    
    #convertBamToSam(options)
    
    #compileDurationOfExecutionFile(options)


if __name__ == "__main__":
    main()