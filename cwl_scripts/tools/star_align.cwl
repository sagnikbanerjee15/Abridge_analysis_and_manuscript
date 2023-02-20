class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: star_align
baseCommand:
  - STAR
inputs:
  - 'sbg:toolDefaultValue': '1'
    id: threads
    type: int
    inputBinding:
      position: 0
      prefix: '--runThreadN'
      shellQuote: false
  - id: genome_directory
    type: Directory
    inputBinding:
      position: 0
      prefix: '--genomeDir'
      shellQuote: false
  - id: raw_input_files
    type:
      - File
      - type: array
        items: File
    inputBinding:
      position: 0
      prefix: '--readFilesIn'
      shellQuote: false
  - 'sbg:toolDefaultValue': '20'
    id: min_intron_length
    type: int?
    inputBinding:
      position: 0
      prefix: '--alignIntronMin'
      shellQuote: false
  - 'sbg:toolDefaultValue': '10000'
    id: max_intron_length
    type: int?
    inputBinding:
      position: 0
      prefix: '--alignIntronMax'
      shellQuote: false
  - 'sbg:toolDefaultValue': '0.66'
    id: outFilterScoreMinOverLread
    type: float?
    inputBinding:
      position: 0
      prefix: '--outFilterScoreMinOverLread'
      shellQuote: false
  - 'sbg:toolDefaultValue': '0.9'
    id: outFilterMatchNminOverLread
    type: float?
    inputBinding:
      position: 0
      prefix: '--outFilterMatchNminOverLread'
      shellQuote: false
  - 'sbg:toolDefaultValue': '500'
    id: max_multimaps
    type: int?
    inputBinding:
      position: 0
      prefix: '--outFilterMultimapNmax'
      shellQuote: false
  - 'sbg:toolDefaultValue': '1'
    id: max_memory
    type: int?
outputs:
  - id: alignment_file
    type: File
    outputBinding:
      glob: '*bam'
  - id: log
    type: File
    outputBinding:
      glob: '*final*out'
  - id: splice_junctions
    type: File
    outputBinding:
      glob: '*.tab'
label: star_align
arguments:
  - position: 1
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "--outSAMtype BAM Unsorted"
      }
  - position: 2
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "--outSAMunmapped Within"
      }
  - position: 4
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "--outFileNamePrefix " + inputs.raw_input_files.nameroot + "_"
      }
  - position: 7
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "--limitBAMsortRAM "+inputs.max_memory * 1024 * 1024 * 1024
      }
  - position: 8
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "--outSAMattributes All"
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'sagnikbanerjee15/star:2.7.9a'
  - class: InlineJavascriptRequirement
