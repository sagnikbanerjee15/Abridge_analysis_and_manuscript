class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: extract_alignment_format
baseCommand: []
inputs:
  - id: alignment_file
    type: File
outputs:
  - id: file_extension
    type:
      type: enum
      symbols:
        - SAM
        - BAM
        - CRAM
      name: file_extension
    outputBinding:
      glob: |-
        ${
            return inputs.alignment_file.nameext.slice(1).toUpperCase()
        }
label: extract_alignment_format
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
