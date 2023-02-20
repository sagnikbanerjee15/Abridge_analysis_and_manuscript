class: Workflow
cwlVersion: v1.0
id: align_rna_seq_reads_produce_all_files
label: align_rna_seq_reads_produce_all_files
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: runThreadN
    type: int?
    'sbg:x': 0
    'sbg:y': 0
  - id: raw_input_files
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 107
  - id: genomeFastaFiles
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 321
  - id: genomeSAindexNbases
    type: int?
    'sbg:x': 0
    'sbg:y': 214
  - id: genomeChrBinNbits
    type: int?
    'sbg:x': 0
    'sbg:y': 428
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1062.83056640625
    'sbg:y': 53.5
  - id: no_tags_unsorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1062.83056640625
    'sbg:y': 160.5
  - id: all_tags_sorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1062.83056640625
    'sbg:y': 267.5
  - id: all_tags_sorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_bamfile
    type: File?
    'sbg:x': 1062.83056640625
    'sbg:y': 374.5
  - id: log
    outputSource:
      - star_generate_index_and_align/log
    type: File
    'sbg:x': 641.3203125
    'sbg:y': 487.5
steps:
  - id: star_generate_index_and_align
    in:
      - id: runThreadN
        source: runThreadN
      - id: genomeFastaFiles
        source:
          - genomeFastaFiles
      - id: raw_input_files
        source:
          - raw_input_files
      - id: genomeSAindexNbases
        source: genomeSAindexNbases
      - id: genomeChrBinNbits
        source: genomeChrBinNbits
    out:
      - id: unsorted_all_tags_bamfile
      - id: log
    run: ./star_generate_index_and_align.cwl
    label: star_generate_index_and_align
    'sbg:x': 244.28125
    'sbg:y': 186
  - id: create_sorted_unsorted_bam_and_sam
    in:
      - id: threads
        source: runThreadN
      - id: all_tags_unsorted_bamfile
        source: star_generate_index_and_align/unsorted_all_tags_bamfile
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_bamfile
      - id: all_tags_sorted_samfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 657.609375
    'sbg:y': 193
requirements:
  - class: SubworkflowFeatureRequirement
