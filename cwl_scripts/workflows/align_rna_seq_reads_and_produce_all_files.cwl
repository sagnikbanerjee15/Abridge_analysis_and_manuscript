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
    'sbg:y': 14
  - id: raw_input_files
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 120.671875
  - id: genomeFastaFiles
    type:
      - File
      - type: array
        items: File
    'sbg:x': 0
    'sbg:y': 334.015625
  - id: genomeSAindexNbases
    type: int?
    'sbg:x': 0
    'sbg:y': 227.34375
  - id: genomeChrBinNbits
    type: int?
    'sbg:x': 0
    'sbg:y': 440.6875
  - id: select_region
    type: string
    'sbg:x': -9.630783081054688
    'sbg:y': 575.1271362304688
  - id: SRA_accession
    type: string
    'sbg:x': 0.09603072702884674
    'sbg:y': -103.94622039794922
  - id: paired
    type:
      type: enum
      symbols:
        - SE
        - PE
      name: paired
    'sbg:x': 4.162574291229248
    'sbg:y': 742.8047485351562
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1115.413818359375
    'sbg:y': -277.5897521972656
  - id: no_tags_unsorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1136.766845703125
    'sbg:y': -157.43173217773438
  - id: all_tags_sorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1133.3953857421875
    'sbg:y': -34.09172439575195
  - id: all_tags_sorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_bamfile
    type: File?
    'sbg:x': 1130.49072265625
    'sbg:y': 82.1795425415039
  - id: log
    outputSource:
      - star_generate_index_and_align/log
    type: File
    'sbg:x': 638.24658203125
    'sbg:y': 160.0078125
  - id: no_tags_unsorted_samfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1406.84130859375
    'sbg:y': 120.671875
  - id: no_tags_unsorted_bamfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1406.84130859375
    'sbg:y': 227.34375
  - id: all_tags_sorted_samfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1406.84130859375
    'sbg:y': 334.015625
  - id: all_tags_sorted_bamfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/all_tags_sorted_bamfile
    type: File?
    'sbg:x': 1404.2420654296875
    'sbg:y': 450.1921081542969
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
    'sbg:x': 243.234375
    'sbg:y': 146.0078125
  - id: create_sorted_unsorted_bam_and_sam
    in:
      - id: threads
        source: runThreadN
      - id: all_tags_sorted_bamfile
        source: star_generate_index_and_align/sorted_all_tags_bamfile
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 924.8270874023438
    'sbg:y': -169.98220825195312
  - id: subset_regions_from_alignment_file
    in:
      - id: sorted_bamfile
        source: star_generate_index_and_align/sorted_all_tags_bamfile
      - id: threads
        source: runThreadN
      - id: select_region
        source: select_region
    out:
      - id: sorted_subset_bamfile
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions_from_alignment_file
    'sbg:x': 624.7604370117188
    'sbg:y': 569.7908325195312
  - id: create_sorted_unsorted_bam_and_sam_1
    in:
      - id: threads
        source: runThreadN
      - id: all_tags_sorted_bamfile
        source: subset_regions_from_alignment_file/sorted_subset_bamfile
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 1016.7618408203125
    'sbg:y': 418.9142150878906
requirements:
  - class: SubworkflowFeatureRequirement
