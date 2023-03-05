class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: select_region_from_samfile
baseCommand: []
inputs:
  - id: samfile
    type: File
  - id: chromosome1
    type: string?
  - id: from
    type: int?
  - id: to
    type: int?
  - id: include_unmapped_reads
    type:
      type: enum
      symbols:
        - 'yes'
        - 'no'
      name: include_unmapped_reads
  - id: chromosome12
    type: string?
outputs:
  - id: subset_samalignments
    type: File
    outputBinding:
      glob: '*sam'
label: select_region_from_samfile
arguments:
  - position: 0
    prefix: ''
    shellQuote: false
    valueFrom: |-
      ${
          var cmd_extract_header = "cat " + inputs.samfile.path +" | grep ^@ > headers"
          var outputfilename = ""
          if(inputs.chromosome1 !=null)
          {
              if(inputs.from == null && inputs.to == null)
              {
                  var cmd_extract_alignments = "cat " + inputs.samfile.path + " | awk '$3=="+ inputs.chromosome1 +"' > alignments"
                  outputfilename = inputs.samfile.nameroot + "_" +inputs.chromosome1+".sam"
              }
              else if(inputs.from == null && inputs.to != null)
              {
                  var cmd_extract_alignments = "cat " + inputs.samfile.path + " | awk '$3=="+ inputs.chromosome1 +" && $4<="+inputs.to+"'  > alignments "
                  outputfilename = inputs.samfile.nameroot + "_" +inputs.chromosome1 + ":1-"+inputs.to+".sam"
              }
              else if(inputs.from != null && inputs.to == null)
              {
                  var cmd_extract_alignments = "cat " + inputs.samfile.path + " | awk '$3=="+ inputs.chromosome1 +" && $4>="+inputs.from+"'  > alignments "
                  outputfilename = inputs.samfile.nameroot + "_" +inputs.chromosome1 + ":"+inputs.from+"-"+".sam"
              }
              else if(inputs.from != null && inputs.to != null)
              {
                  var cmd_extract_alignments = "cat " + inputs.samfile.path + " | awk '$3=="+ inputs.chromosome1 +" && $4>="+inputs.from+" && $4<="+inputs.to+"' > alignments "
                  outputfilename = inputs.samfile.nameroot + "_" +inputs.chromosome1 + ":"+inputs.from+"-"+inputs.to+".sam"
              }
              
              if(inputs.include_unmapped_reads=="yes")
              {
                  var cmd_extract_unmapped_reads = "cat "+inputs.samfile.path+"|awk '$2==4' > unmapped_reads"
                  var cmd_merge = cmd_extract_unmapped_reads + " && cat headers alignments unmapped_reads > "+ outputfilename
              }
              else
                  var cmd_merge = "cat headers alignments > "+outputfilename 
          }
          if(inputs.from == null && inputs.to == null && inputs.chromosome1 == null)
          {
              return "cp " + inputs.samfile.path +  " "+ inputs.samfile.nameroot+".sam"
          }
          else
              return cmd_extract_header + " && " + cmd_extract_alignments + " && " + cmd_merge 
          
      }
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu
  - class: InlineJavascriptRequirement
