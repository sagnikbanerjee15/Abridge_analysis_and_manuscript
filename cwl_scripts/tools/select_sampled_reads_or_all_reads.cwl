class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: select_sampled_reads_or_all_reads
baseCommand: []
inputs:
  - id: sampled_fastq
    type: File
  - id: whole_fastq
    type: File
  - id: sample_or_whole
    type:
      type: enum
      symbols:
        - SAMPLE
        - WHOLE
      name: sample_or_whole
outputs:
  - id: fastq
    type: File
    outputBinding:
      glob: '*fastq'
label: select_sampled_reads_or_all_reads
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          if(inputs.sample_or_whole == "SAMPLE")
              return "cp " +inputs.sampled_fastq.path + " "+inputs.sampled_fastq.basename
          else if(inputs.sample_or_whole = "WHOLE")
              return "cp "+inputs.whole_fastq.path + " " +inputs.whole_fastq.basename
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
