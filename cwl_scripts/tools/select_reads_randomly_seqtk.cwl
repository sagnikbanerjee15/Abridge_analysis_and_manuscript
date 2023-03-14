class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: select_reads_randomly_seqtk
baseCommand:
  - seqtk
  - sample
inputs:
  - id: fastq_filename
    type: File
    inputBinding:
      position: 100
      shellQuote: false
  - id: number_of_reads_to_be_sampled
    type: int
    inputBinding:
      position: 101
      shellQuote: false
outputs:
  - id: sampled_fastq
    type: File
    outputBinding:
      glob: '*fastq'
label: select_reads_randomly_seqtk
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "-s100"
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'sagnikbanerjee15/seqtk:1.3'
  - class: InlineJavascriptRequirement
stdout: |-
  ${
      return inputs.fastq_filename.nameroot + "_sampled.fastq"
  }
