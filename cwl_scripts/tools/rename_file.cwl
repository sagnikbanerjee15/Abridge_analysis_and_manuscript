class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: rename_file
baseCommand: []
inputs:
  - id: input_file
    type: File
  - id: rename_text
    type: string
  - id: SRA_accession
    type: string
outputs:
  - id: renamed_file
    type: File
    outputBinding:
      glob: |-
        ${
            return "*"+inputs.input_file.nameext
        }
label: rename_file
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "cp "+inputs.input_file.path+" "+inputs.SRA_accession+"_"+inputs.rename_text+inputs.input_file.nameext
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
