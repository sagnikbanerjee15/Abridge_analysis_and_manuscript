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

CPU = 100
pool = multiprocessing.Pool(processes=int(CPU))
# Location of samfiles which will be compressed - Note that these are hard coded so it will not work on other machines
ROOT_DIRECTORY = "/project/maizegdb/sagnik/ABRIDGE/developing_abridge/"
inputsamfile_SE = [f"{ROOT_DIRECTORY}/SRR13711353_SE.sam", # Single ended RNA-Seq
                   f"{ROOT_DIRECTORY}/SRR12077404_SE.sam" # Single ended DNA-Seq
                   ]

inputsamfile_PE = [f"{ROOT_DIRECTORY}/SRR13711353_PE.sam", # Single ended RNA-Seq
                   f"{ROOT_DIRECTORY}/SRR12077404_PE.sam" # Single ended DNA-Seq
                   ]


# Single ended - x iterations in total
compress_commands = []
decompress_commands = []
for inputfilename in inputsamfile_SE:
    for level in ["1", "2", "3"]: # 3 iterations
        for save_scores in [0,1]: # 2 iterations
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
                                    output_directory_name += f"save_scores_{save_scores}_"
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
                                    if save_scores == 1:
                                        cmd += f" --save_scores "
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
                                    cmd += f" 1> {output_directory_name}.output "
                                    cmd += f" 2> {output_directory_name}.error "
                                    compress_commands.append([cmd,"dummy"])
                                    
                                    cmd  = f"(/usr/bin/time --verbose "
                                    cmd += f" abridge "
                                    cmd += f" --keep_intermediate_error_files "
                                    cmd += f" --decompress "
                                    cmd += f" --genome /project/maizegdb/sagnik/data/ARATH/genome/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa "
                                    cmd += f" --inputabrfilenames {output_directory_name}/{inputfilename_without_location}.abridge "
                                    for ignore_sequence in [0,1]: # 2 iterations
                                        if ignore_sequence == 1:
                                            cmd += " --ignore_sequence "
                                    
                                    output_directory_name = f"{ROOT_DIRECTORY}/" 
                                    output_directory_name += f"{inputfilename_without_location}_"
                                    output_directory_name += f"decompress_level_{level}_"
                                    output_directory_name += f"save_scores_{save_scores}_"
                                    output_directory_name += f"ignore_quality_scores_{ignore_quality_scores}_"
                                    output_directory_name += f"ignore_soft_clippings_{ignore_soft_clippings}_"
                                    output_directory_name += f"ignore_mismatches_{ignore_mismatches}_"
                                    output_directory_name += f"ignore_unmapped_reads_{ignore_unmapped_reads}_"
                                    output_directory_name += f"save_all_quality_scores_{save_all_quality_scores}_"
                                    output_directory_name += f"save_exact_quality_scores_{save_exact_quality_scores}_"
                                    output_directory_name += f"ignore_sequence_{ignore_sequence}"
                            
                                    cmd += f" --output_directory {output_directory_name} "
                                    cmd += f") "
                                    cmd += f"1> {output_directory_name}.output"
                                    cmd += f"2> {output_directory_name}.error"
                                    
                                    decompress_commands.append([cmd,"dummy"])

#pool.map(runCommand,compress_commands)
#pool.map(runCommand,decompress_commands)

 
print(decompress_commands)                                   
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
