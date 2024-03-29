#! /usr/bin/env python

# Srcipt written for testing abridge - hence the poor organization

import argparse 
import logging
import os
import pprint
import sys
import re
import time
import multiprocessing
import random
import glob
import time
import subprocess
from pprint import pformat

def runCommand(eachpinput):
    cmd,dummy = eachpinput
    os.system(cmd)

def run2CommandsInSeries(eachpinput):
    cmd1,cmd2 = eachpinput
    os.system(cmd1)
    os.system(cmd2)
    

def runMultipleCommandsInSeries(eachpinput):
    for cmd in eachpinput:
        #if os.path.exists("/project/maizegdb/sagnik/ABRIDGE/Abridge_analysis_for_MS/core*") == True: return
        if cmd=="":continue
        print(cmd)
        sys.stdout.flush()
        os.system(cmd)
    print("="*100)
    

CPU = 1
pool = multiprocessing.Pool(processes=int(CPU))
# Location of samfiles which will be compressed - Note that these are hard coded so it will not work on other machines
if "ceres" in open("/etc/hostname","r").read().strip():
    ROOT_DIRECTORY = "/project/maizegdb/sagnik/ABRIDGE/developing_abridge/"
    TEMP_DIRECTORY = "/90daydata/maizegdb/sagnik/ABRIDGE/developing_abridge/"
else:
    ROOT_DIRECTORY = "/project/maizegdb/sagnik/ABRIDGE/developing_abridge/"
    TEMP_DIRECTORY = "/project/90daydata/maizegdb/sagnik/ABRIDGE/developing_abridge/"
inputsamfile_SE = [f"{ROOT_DIRECTORY}/SRR13711353_SE.sam", # Single ended RNA-Seq
                   f"{ROOT_DIRECTORY}/SRR12077404_SE.sam" # Single ended DNA-Seq
                   ]

inputsamfile_PE = [f"{ROOT_DIRECTORY}/SRR13711353_PE.sam", # Single ended RNA-Seq
                   f"{ROOT_DIRECTORY}/SRR12077404_PE.sam" # Single ended DNA-Seq
                   ]

#os.system(f"rm -rf {ROOT_DIRECTORY}/*compress*")
#os.system(f"rm -rf {TEMP_DIRECTORY}/*compress*")
#os.system(f"mkdir -p {TEMP_DIRECTORY}")


compress_commands = []
decompress_commands = []
compress_and_decompress_commands = []
level = 1
for level in ["1","2","3"]: # 3 iterations
    if level=="2" or level=="3":continue
    for paired_type in [inputsamfile_SE,inputsamfile_PE]: # 2 iterations
        for inputfilename in paired_type: # 2 iterations
            if "SE" in inputfilename:continue
            for ignore_scores in [0,1]: # 2 iterations
                for ignore_quality_scores in [0,1]: # 2 iterations
                    for ignore_soft_clippings in [0,1]: # 2 iterations
                        for ignore_mismatches in [0,1]: # 2 iterations
                            for ignore_unmapped_reads in [0,1]: # 2 iterations
                                for save_all_quality_scores in [0,1]: # 2 iterations
                                    for save_exact_quality_scores in [0,1]: # 2 iterations
                                        
                                        inputfilename_without_location = inputfilename.split("/")[-1][:-4]
                                        output_directory_name = f"{ROOT_DIRECTORY}/" 
                                        output_directory_name += f"{inputfilename_without_location}_"
                                        output_directory_name += f"compress_level_{level}_"
                                        output_directory_name += f"ignore_scores_{ignore_scores}_"
                                        output_directory_name += f"ignore_quality_scores_{ignore_quality_scores}_"
                                        output_directory_name += f"ignore_soft_clippings_{ignore_soft_clippings}_"
                                        output_directory_name += f"ignore_mismatches_{ignore_mismatches}_"
                                        output_directory_name += f"ignore_unmapped_reads_{ignore_unmapped_reads}_"
                                        output_directory_name += f"save_all_quality_scores_{save_all_quality_scores}_"
                                        output_directory_name += f"save_exact_quality_scores_{save_exact_quality_scores}"
                                        
                                        cmd  = f"(/usr/bin/time --verbose "
                                        cmd += f" abridge "
                                        cmd += f" --keep_intermediate_error_files "
                                        cmd += f" --compress "
                                        cmd += f" --genome /project/maizegdb/sagnik/data/ARATH/genome/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa "
                                        cmd += f" --inputsamfilenames {inputfilename} "
                                        cmd += f" --output_directory {output_directory_name} "
                                        cmd += f" --level {level} "
                                        if ignore_scores == 1:
                                            cmd += f" --ignore_scores "
                                        if ignore_quality_scores == 1:
                                            cmd += f" --ignore_quality_scores "
                                        if ignore_soft_clippings == 1:
                                            cmd += f" --ignore_soft_clippings "
                                        if ignore_mismatches == 1:
                                            cmd += f" --ignore_mismatches "
                                        if ignore_unmapped_reads == 1:
                                            cmd += f" --ignore_unmapped_reads "
                                        if save_all_quality_scores == 1:
                                            cmd += f" --save_all_quality_scores "
                                        if save_exact_quality_scores == 1:
                                            cmd += f" --save_exact_quality_scores "
                                        cmd += f") "
                                        cmd += f" 1>> {output_directory_name}.output "
                                        cmd += f" 2> {output_directory_name}.error "
                                        output_directory_name_without_location = output_directory_name.split("/")[-1]
                                        if os.path.exists(f"{output_directory_name}/{inputfilename_without_location}.abridge")==False and os.path.exists(f"{TEMP_DIRECTORY}/{output_directory_name_without_location}/{inputfilename_without_location}.abridge") == False:
                                            os.system(f"rm -rf {TEMP_DIRECTORY}/{output_directory_name_without_location}")
                                            cmd_mv = f"mv {output_directory_name}* {TEMP_DIRECTORY}"
                                            compress_and_decompress_commands.append(["" for _ in range(6)])
                                            compress_and_decompress_commands[-1][0] = cmd
                                            compress_and_decompress_commands[-1][5] = cmd_mv
                                            os.system(f"echo \"{cmd}\" > {output_directory_name}.output")
                                        
                                        
                                        for ignore_sequence in [0,1]: # 2 iterations
                                            output_directory_name = f"{ROOT_DIRECTORY}/" 
                                            output_directory_name += f"{inputfilename_without_location}_"
                                            output_directory_name += f"decompress_level_{level}_"
                                            output_directory_name += f"ignore_scores_{ignore_scores}_"
                                            output_directory_name += f"ignore_quality_scores_{ignore_quality_scores}_"
                                            output_directory_name += f"ignore_soft_clippings_{ignore_soft_clippings}_"
                                            output_directory_name += f"ignore_mismatches_{ignore_mismatches}_"
                                            output_directory_name += f"ignore_unmapped_reads_{ignore_unmapped_reads}_"
                                            output_directory_name += f"save_all_quality_scores_{save_all_quality_scores}_"
                                            output_directory_name += f"save_exact_quality_scores_{save_exact_quality_scores}_"
                                            output_directory_name += f"ignore_sequence_{ignore_sequence}"
                                            
                                            cmd  = f"(/usr/bin/time --verbose "
                                            cmd += f" abridge "
                                            cmd += f" --keep_intermediate_error_files "
                                            cmd += f" --decompress "
                                            cmd += f" --genome /project/maizegdb/sagnik/data/ARATH/genome/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa "
                                            cmd += f" --inputabrfilenames {output_directory_name.split('_ignore_sequence_')[0].replace('decompress','compress')}/{inputfilename_without_location}.abridge "
                                            cmd += f" --output_directory {output_directory_name} "
                                            if ignore_sequence == 1:
                                                cmd += " --ignore_sequence "
                                            cmd += f") "
                                            cmd += f" 1>> {output_directory_name}.output"
                                            cmd += f" 2> {output_directory_name}.error"
                                            os.system(f"echo \"{cmd}\" > {output_directory_name}.output")
                                            
                                            if os.path.exists(f"{output_directory_name}/{inputfilename_without_location}.decompressed.sam") == False:
                                                compressed_directory_location = "/90daydata/" + "/".join(output_directory_name.split("_ignore_sequence_")[0].replace('decompress','compress').split("/")[2:])
                                                cmd_cp = f"cp -r {compressed_directory_location} {ROOT_DIRECTORY}"
                                                cmd_mv = f"mv {output_directory_name}* {TEMP_DIRECTORY}"
                                                cmd_rm = f"rm -rf {output_directory_name.split('_ignore_sequence_')[0].replace('decompress','compress')}"
                                                decompress_commands.append([cmd_cp, cmd, cmd_mv, cmd_rm])
                                                """
                                                if ignore_sequence==0:
                                                    compress_and_decompress_commands[-1][1] = cmd
                                                    compress_and_decompress_commands[-1][2] = cmd_mv
                                                else:
                                                    compress_and_decompress_commands[-1][3] = cmd
                                                    compress_and_decompress_commands[-1][4] = cmd_mv
                                                """
pool.map(runMultipleCommandsInSeries,compress_and_decompress_commands)
pool.map(runMultipleCommandsInSeries,decompress_commands)
                                   
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
