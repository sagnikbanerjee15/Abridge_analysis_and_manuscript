class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: change_read_name_and_merge_from_pe_to_se
baseCommand: []
inputs:
  - id: fastq_file_pair1
    type: File
  - id: fastq_file_pair2
    type: File
outputs:
  - id: merged_fastq
    type: File
    outputBinding:
      glob: '*merged.fastq'
label: change_read_name_and_merge_from_PE_to_SE
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "cat "+inputs.fastq_file_pair1.path +"|sed '1~4s/\\//_/' > temp_1.fastq  && cat "+inputs.fastq_file_pair2.path+"|sed '1~4s/\\//_/' > temp_2.fastq && cat temp_1.fastq temp_2.fastq > merged.fastq"
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
