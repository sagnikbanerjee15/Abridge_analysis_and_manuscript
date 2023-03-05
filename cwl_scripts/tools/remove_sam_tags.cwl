class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: remove_sam_tags
baseCommand: []
inputs:
  - id: samfile
    type: File
outputs:
  - id: no_tags_samfile
    type: File
    outputBinding:
      glob: '*sam'
label: remove_tags
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "cat "+inputs.samfile.path+"| grep ^@ > only_header && cat "+inputs.samfile.path+"|grep -v ^@|cut -f1-11 > only_alignments && cat only_header only_alignments > "+inputs.samfile.nameroot+"_no_tags.sam"
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
