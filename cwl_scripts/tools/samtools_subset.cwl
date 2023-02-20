class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: samtools_subset
baseCommand:
  - samtools
  - view
inputs:
  - id: input_alignment
    type: File
    inputBinding:
      position: 100
      shellQuote: false
  - id: include_header
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-h'
      shellQuote: false
  - id: only_header
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-H'
      shellQuote: false
  - id: count_only
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-c'
      shellQuote: false
  - id: threads
    type: int?
    inputBinding:
      position: 0
      prefix: '-@'
      shellQuote: false
  - id: reference
    type: File?
    inputBinding:
      position: 0
      prefix: '-T'
      shellQuote: false
  - id: select_region
    type: string?
    inputBinding:
      position: 101
      shellQuote: false
outputs:
  - id: output_bam
    type: File?
    outputBinding:
      glob: |-
        ${
            return "*.bam"
        }
  - id: output_sam
    type: File?
    outputBinding:
      glob: '${     return "*.sam" }'
  - id: output_cram
    type: File?
    outputBinding:
      glob: '${     return "*.cram" }'
label: samtools subset
arguments:
  - position: 0
    prefix: '-o'
    shellQuote: false
    valueFrom: |-
      ${
        var suffix=inputs.input_alignment.nameext
        if(inputs.select_region==null)
          return inputs.input_alignment.nameroot  + suffix
        else
          return inputs.input_alignment.nameroot + "_"+ inputs.select_region + suffix
      }
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          return "--output-fmt "+inputs.input_alignment.nameext.slice(1).toUpperCase()
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'sagnikbanerjee15/samtools:1.16.1'
  - class: InlineJavascriptRequirement
stdout: |-
  ${
    var suffix=".bam"
    if( inputs.output_format === "CRAM"){suffix='.cram'}
    if( inputs.output_format === "SAM"){suffix='.sam'}
    if( inputs.output_format === "BAM"){suffix='.bam'}
    if(inputs.count_only===true ){ suffix=".counts"}
    return inputs.input_alignment.nameroot + suffix + ".output"
  }
stderr: |-
  ${
    var suffix=".bam"
    if( inputs.output_format === "CRAM"){suffix='.cram'}
    if( inputs.output_format === "SAM"){suffix='.sam'}
    if( inputs.output_format === "BAM"){suffix='.bam'}
    if(inputs.count_only===true ){ suffix=".counts"}
    return inputs.input_alignment.nameroot + suffix + ".error"
  }
