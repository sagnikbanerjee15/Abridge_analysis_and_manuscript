#! /usr/bin/env python

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
    required_named.add_argument("--hisat2_index","-hi",help="Enter the location of the hisat2 index",required=True)
    required_named.add_argument("--input_location","-loc",help="Enter the location of the raw fastq files. For this program all fastq files must be located under the same directory",required=True)
    
    optional_named.add_argument("--cpu","-n",help="Enter the number of CPUs. Please note that all alignments will be conducted using a single CPU. This argument will control how many parallel alignments can be lanuched", default=1)
    optional_named.add_argument("--num_times","-t",help="Enter the number of times to run the alignments to estimate time",default = 5)
    optional_named.add_argument("--temp_directory","-temp_dir",help="Enter a temporary directory. All files will be dumped in this directory to prevent the output directory to get crowded. Outputs and Error files will not be moved",default = None)
    
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
    for iteration in range(int(options.num_times)):
        for row in options.metadata:
            sra,layout,assay_type = row
            flag=0
            for iteration in range(int(options.num_times)):
                if os.path.exists(f"{options.output_directory}/{sra}_{layout}_{iteration}.error ")==False:
                    flag=1
                    break
            if flag==0:continue 
            if layout == "PE":
                cmd  = f" cp "
                cmd += f" {options.temp_directory}/{sra}_1.fastq "
                cmd += f" {options.input_location}/ "
                if os.path.exists(f"{options.input_location}/{sra}_1.fastq")==False:
                    os.system(cmd)
                
                cmd  = f" cp "
                cmd += f" {options.temp_directory}/{sra}_2.fastq "
                cmd += f" {options.input_location}/ "
                if os.path.exists(f"{options.input_location}/{sra}_2.fastq")==False:
                    os.system(cmd)
            else:
                cmd  = f" cp "
                cmd += f" {options.temp_directory}/{sra}_0.fastq "
                cmd += f" {options.input_location}/ "
                if os.path.exists(f"{options.input_location}/{sra}_0.fastq")==False:
                    os.system(cmd)
            
            files_to_be_removed=[]
        
            if assay_type=="RNA-Seq":
                cmd  = f"(/usr/bin/time --verbose STAR "
                cmd += f" --runThreadN 1 " # always run with one CPU
                cmd += f" --genomeDir "+options.star_genome_index
                cmd += f" --outSAMtype BAM SortedByCoordinate "
                cmd += f" --outFilterMultimapNmax 10000 " 
                cmd += f" --outFilterMismatchNmax 25  " 
                cmd += f" --outBAMsortingThreadN 1 " # Use a single CPU for sorting
                cmd += f" --limitBAMsortRAM 107374182400" # 100 GB
                cmd += f" --outFilterScoreMinOverLread 0.75 "
                cmd += f" --outFilterMatchNminOverLread 0.75 "
                cmd += f" --outSAMattributes NH HI AS nM NM MD jM jI XS "
                cmd += f" --outSAMunmapped Within "
                if layout=="SE":
                    cmd += f" --readFilesIn {options.input_location}/{sra}_0.fastq"
                else:
                    cmd += f" --readFilesIn {options.input_location}/{sra}_1.fastq {options.input_location}/{sra}_2.fastq"
                cmd += f" --outFileNamePrefix {options.output_directory}/{sra}_{layout}_{iteration}_"
                cmd += f" --alignIntronMin 20  "
                cmd += f" --alignIntronMax 100000 "
                cmd += f") "
                cmd += f" 1> {options.output_directory}/{sra}_{layout}_{iteration}.output "
                cmd += f" 2> {options.output_directory}/{sra}_{layout}_{iteration}.error "
    
                if os.path.exists(f"{options.temp_directory}/{sra}_{layout}.bam")==False and os.path.exists(f"{options.temp_directory}/{sra}_{layout}.sam")==False: 
                    list_of_all_commands.append([cmd,"dummy"])
                    os.system(cmd)
                
                if iteration==0:
                    if os.path.exists(f"{options.output_directory}/{sra}_{iteration}_{layout}_Aligned.sortedByCoord.out.bam")==False and os.path.exists(f"{options.output_directory}/{sra}_{layout}.bam")==True:continue
                    cmd  = f"mv "
                    cmd += f"{options.output_directory}/{sra}_{iteration}_{layout}_Aligned.sortedByCoord.out.bam "
                    cmd += f"{options.output_directory}/{sra}_{layout}.bam "
                    os.system(cmd)
                    
                    # Convert to sam file
                    cmd  = f" samtools "
                    cmd += f" view -h "
                    cmd += f" {options.output_directory}/{sra}_{layout}.bam "
                    cmd += f" > {options.output_directory}/{sra}_{layout}.sam "
                    os.system(cmd)
                    
                    cmd  = f" mv "
                    cmd += f" {options.output_directory}/{sra}_{layout}.* "
                    cmd += f" {options.temp_directory}/"
                    os.system(cmd)
                
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{iteration}_{layout}_Log.out")
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{iteration}_{layout}_Log.progress.out")
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{iteration}_{layout}_SJ.out.tab")
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{iteration}_{layout}_Aligned.sortedByCoord.out.bam")
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{iteration}_{layout}_Log.final.out")
                
            else:
                """
                cmd  = f"(/usr/bin/time --verbose bwa mem "
                cmd += f" -t 1 " # Number of threads
                cmd += f" -k 50 " # Minimum seed length 
                cmd += f" -c 1000 "
                cmd += f" -o {options.output_directory}/{sra}_{layout}_{iteration}.sam "
                cmd += f" -v 1 "
                cmd += f" {options.bwa_genome_index} "
                if layout=="SE":
                    cmd += f" {options.input_location}/{sra}_0.fastq "
                else:
                    cmd += f" {options.input_location}/{sra}_1.fastq {options.input_location}/{sra}_2.fastq "
                cmd += f") "
                cmd += f" 1> {options.output_directory}/{sra}_{layout}_{iteration}.output "
                cmd += f" 2> {options.output_directory}/{sra}_{layout}_{iteration}.error "
                os.system(cmd)
                """
                cmd  = f"(/usr/bin/time --verbose hisat2 "
                cmd += f" -x  {options.hisat2_index} "
                cmd += f" -S {options.output_directory}/{sra}_{layout}_{iteration}.sam "
                if layout=="SE":
                    cmd += f" -1 {options.input_location}/{sra}_0.fastq "
                else:
                    cmd += f" -2 {options.input_location}/{sra}_1.fastq {options.input_location}/{sra}_2.fastq "
                cmd += f" --no-spliced-alignment "
                cmd += ") "
                cmd += f" 1> {options.output_directory}/{sra}_{layout}_{iteration}.output "
                cmd += f" 2> {options.output_directory}/{sra}_{layout}_{iteration}.error "
                os.system(cmd)
                
                cmd  = f"samtools view "
                cmd += f" -Sbh "
                cmd += f" {options.output_directory}/{sra}_{layout}_{iteration}.sam "
                cmd += f" > {options.output_directory}/{sra}_{layout}_{iteration}.bam "
                cmd += f" 2> {options.output_directory}/{sra}_{layout}_{iteration}_converting_sam_to_bam.error"
                os.system(cmd)
                
                cmd  = f" samtools sort "
                cmd += f" {options.output_directory}/{sra}_{layout}_{iteration}.bam "
                cmd += f" -o {options.output_directory}/{sra}_{layout}_{iteration}_sorted.bam "
                cmd += f" 2> {options.output_directory}/{sra}_{layout}_{iteration}_sorting_bam.error "
                os.system(cmd)
                
               
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{layout}_{iteration}.sam")
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{layout}_{iteration}.bam")
                files_to_be_removed.append(f"{options.output_directory}/{sra}_{layout}_{iteration}_sorted.bam")
                
                if iteration==0:
                    cmd = f"mv {options.output_directory}/{sra}_{layout}_{iteration}_sorted.bam {options.output_directory}/{sra}_{layout}.bam "
                    os.system(cmd)
                    
                    cmd = f"samtools view -h {options.output_directory}/{sra}_{layout}.bam > {options.output_directory}/{sra}_{layout}.sam"
                    os.system(cmd)
                    
                    cmd  = f" mv "
                    cmd += f" {options.output_directory}/{sra}_{layout}.* "
                    cmd += f" {options.temp_directory}/"
                    os.system(cmd)
            
            cmd = f"mv {options.output_directory}/{sra}_{layout}_{iteration}*.error {options.output_directory}/../errors/"
            os.system(cmd)
            
            cmd = f"mv {options.output_directory}/{sra}_{layout}_{iteration}*.output {options.output_directory}/../outputs/"
            os.system(cmd)
            
            
            if layout == "SE":
                files_to_be_removed.append(f"{options.input_location}/{sra}_0.fastq")
            else:
                files_to_be_removed.append(f"{options.input_location}/{sra}_1.fastq")
                files_to_be_removed.append(f"{options.input_location}/{sra}_2.fastq")
            """
            for file in files_to_be_removed:
                os.system("rm -f "+file)
            """
            

def mergePairedEndedSamplesIntoSingleEnded(eachinput):
    """
    Combine the two pairs of reads and rename them
    """
    options, sra = eachinput
    output_filename = f"{options.temp_directory}/{sra}_0.fastq"
    input_filename_1 = f"{options.temp_directory}/{sra}_1.fastq"
    input_filename_2 = f"{options.temp_directory}/{sra}_2.fastq"
    
    if os.path.exists(f"{output_filename}") == True:return
    
    fhw=open(output_filename,"w")
    for fhr in [open(input_filename_1,"r") ,open(input_filename_2,"r")]:
        for line_num,line in enumerate(fhr):
            if line_num % 4 == 0 and line[0]=='@' and '/' in line:
                line = line.replace('/','_')
            fhw.write(line)
    fhw.close()
    

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
    
    mapSamplesToReference(options)
    
    #convertBamToSam(options)
    
    #compileDurationOfExecutionFile(options)


if __name__ == "__main__":
    main()