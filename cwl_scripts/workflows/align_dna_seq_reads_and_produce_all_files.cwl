class: Workflow
cwlVersion: v1.0
id: align_dna_seq_reads_and_produce_all_files
label: align_dna_seq_reads_and_produce_all_files
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: unpaired
    type: File?
    'sbg:x': 0
    'sbg:y': 0
  - id: threads
    type: int?
    'sbg:x': 0
    'sbg:y': 107
  - id: reference
    type: File
    'sbg:x': 0
    'sbg:y': 214
  - id: mate2
    type: File?
    'sbg:x': 0
    'sbg:y': 321
  - id: mate1
    type: File?
    'sbg:x': 0
    'sbg:y': 428
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1075.982666015625
    'sbg:y': 53.5
  - id: no_tags_unsorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1075.982666015625
    'sbg:y': 160.5
  - id: all_tags_sorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1075.982666015625
    'sbg:y': 267.5
  - id: all_tags_sorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_bamfile
    type: File?
    'sbg:x': 1075.982666015625
    'sbg:y': 374.5
steps:
  - id: bowtie_index_and_align
    in:
      - id: reference
        source: reference
      - id: threads
        source: threads
      - id: mate1
        source: mate1
      - id: mate2
        source: mate2
      - id: unpaired
        source: unpaired
    out:
      - id: aligned_samfile
      - id: log
      - id: error
    run: ../tools/bowtie_index_and_align.cwl
    label: bowtie_index_and_align
    'sbg:x': 133.875
    'sbg:y': 186
  - id: samtools_view
    in:
      - id: input_alignment
        source: bowtie_index_and_align/aligned_samfile
      - id: output_format
        default: BAM
      - id: include_header
        default: true
      - id: threads
        source: threads
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
    run: ../tools/samtools_view.cwl
    label: samtools view
    'sbg:x': 404.197998046875
    'sbg:y': 200
  - id: create_sorted_unsorted_bam_and_sam
    in:
      - id: threads
        source: threads
      - id: all_tags_unsorted_bamfile
        source: samtools_view/output_bam
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_bamfile
      - id: all_tags_sorted_samfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 670.7614135742188
    'sbg:y': 193
requirements:
  - class: SubworkflowFeatureRequirement
