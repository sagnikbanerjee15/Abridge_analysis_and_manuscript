class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: star_index
baseCommand:
  - STAR
inputs:
  - id: genomeFastaFiles
    type:
      - File
      - type: array
        items: File
    inputBinding:
      position: 0
      prefix: '--genomeFastaFiles'
  - id: sjdbGTFfile
    type: File?
    inputBinding:
      position: 0
      prefix: '--sjdbGTFfile'
  - id: runThreadN
    type: int?
    inputBinding:
      position: 0
      prefix: '--runThreadN'
    doc: STAR command for generating index
  - id: genomeSAindexNbases
    type: int?
    inputBinding:
      position: 0
      prefix: '--genomeSAindexNbases'
      shellQuote: false
  - id: genomeChrBinNbits
    type: int?
    inputBinding:
      position: 0
      prefix: '--genomeChrBinNbits'
      shellQuote: false
outputs:
  - id: output
    type: Directory
    outputBinding:
      glob: star_index
label: star_index
arguments:
  - position: 0
    prefix: '--runMode'
    valueFrom: genomeGenerate
  - position: 0
    prefix: '--genomeDir'
    valueFrom: star_index
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'sagnikbanerjee15/star:2.7.9a'
  - class: InlineJavascriptRequirement
