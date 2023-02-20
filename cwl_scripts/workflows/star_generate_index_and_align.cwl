class: Workflow
cwlVersion: v1.0
id: star_generate_index_and_align
label: star_generate_index_and_align
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: runThreadN
    type: int?
    'sbg:x': 0
    'sbg:y': 0
  - id: genomeFastaFiles
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 214
  - id: raw_input_files
    type:
      - File
      - type: array
        items: File
    'sbg:x': 244.28125
    'sbg:y': 214
  - id: genomeSAindexNbases
    type: int?
    'sbg:x': 0
    'sbg:y': 107
  - id: genomeChrBinNbits
    type: int?
    'sbg:x': 0
    'sbg:y': 321
outputs:
  - id: unsorted_all_tags_bamfile
    outputSource:
      - star_align/alignment_file
    type: File
    'sbg:x': 820.9400024414062
    'sbg:y': 160.5
  - id: log
    outputSource:
      - star_align/log
    type: File
    'sbg:x': 792.9609375
    'sbg:y': 14
steps:
  - id: star_index
    in:
      - id: genomeFastaFiles
        source:
          - genomeFastaFiles
      - id: runThreadN
        source: runThreadN
      - id: genomeSAindexNbases
        source: genomeSAindexNbases
      - id: genomeChrBinNbits
        source: genomeChrBinNbits
    out:
      - id: output
    run: ../tools/star_generate_index.cwl
    label: star_index
    'sbg:x': 244.28125
    'sbg:y': 86
  - id: star_align
    in:
      - id: threads
        source: runThreadN
      - id: genome_directory
        source: star_index/output
      - id: raw_input_files
        source:
          - raw_input_files
      - id: min_intron_length
        default: 20
      - id: max_intron_length
        default: 100000
      - id: max_memory
        default: 100
    out:
      - id: alignment_file
      - id: log
      - id: splice_junctions
    run: ../tools/star_align.cwl
    label: star_align
    'sbg:x': 539.1834106445312
    'sbg:y': 146.5
requirements: []
