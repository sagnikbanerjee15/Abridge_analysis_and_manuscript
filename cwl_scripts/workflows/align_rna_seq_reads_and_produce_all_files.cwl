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
    'sbg:y': 106.734375
  - id: raw_input_files
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 213.46875
  - id: genomeFastaFiles
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 533.671875
  - id: genomeSAindexNbases
    type: int?
    'sbg:x': 0
    'sbg:y': 426.9375
  - id: genomeChrBinNbits
    type: int?
    'sbg:x': 0
    'sbg:y': 640.40625
  - id: SRA_accession
    type: string
    'sbg:x': 0
    'sbg:y': 0
  - id: paired
    type:
      type: enum
      symbols:
        - SE
        - PE
      name: paired
    'sbg:x': 0
    'sbg:y': 320.203125
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1074.892822265625
    'sbg:y': 53.3671875
  - id: no_tags_unsorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1074.892822265625
    'sbg:y': 266.8359375
  - id: all_tags_sorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1074.892822265625
    'sbg:y': 373.5703125
  - id: all_tags_sorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_bamfile
    type: File?
    'sbg:x': 1074.892822265625
    'sbg:y': 587.0390625
  - id: log
    outputSource:
      - star_generate_index_and_align/log
    type: File
    'sbg:x': 662.3201904296875
    'sbg:y': 231.8359375
  - id: no_tags_unsorted_cramfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_cramfile
    type: File?
    'sbg:x': 1074.892822265625
    'sbg:y': 160.1015625
  - id: all_tags_sorted_cramfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_cramfile
    type: File?
    'sbg:x': 1074.892822265625
    'sbg:y': 480.3046875
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
      - id: SRA_Acession
        source: SRA_accession
      - id: paired
        source: paired
    out:
      - id: sorted_all_tags_bamfile
      - id: log
    run: ./star_generate_index_and_align.cwl
    label: star_generate_index_and_align
    'sbg:x': 244.109375
    'sbg:y': 278.203125
  - id: create_sorted_unsorted_bam_and_sam
    in:
      - id: threads
        source: runThreadN
      - id: all_tags_sorted_bamfile
        source: star_generate_index_and_align/sorted_all_tags_bamfile
      - id: SRA_accession
        source: SRA_accession
      - id: reference
        source: genomeFastaFiles
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: no_tags_unsorted_cramfile
      - id: all_tags_sorted_cramfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 662.3201904296875
    'sbg:y': 373.5703125
requirements:
  - class: SubworkflowFeatureRequirement
