class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: downsample_fastq
baseCommand: []
inputs:
  - id: fastq_files
    type: File
  - 'sbg:toolDefaultValue': '1'
    id: number_of_reads_to_be_selected
    type: int
outputs:
  - id: downsampled_fastq
    type: File
    outputBinding:
      glob: '*fastq'
label: downsample_fastq
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
         if(inputs.number_of_reads_to_be_selected == -1)
              return "cp "+inputs.fastq_files.path+ " "+inputs.fastq_files.nameroot + inputs.fastq_files.nameext
          else
              return "cat "+inputs.fastq_files.path+"|head -n "+inputs.number_of_reads_to_be_selected*4 + " > "+inputs.fastq_files.nameroot + "_" + inputs.number_of_reads_to_be_selected + inputs.fastq_files.nameext
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
