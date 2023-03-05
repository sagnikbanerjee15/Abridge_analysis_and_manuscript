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
  - id: SRA_accession
    type: string
    'sbg:x': 6
    'sbg:y': 557
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
  - id: error
    outputSource:
      - bowtie_index_and_align/error
    type: File
    'sbg:x': 368.2890625
    'sbg:y': 46
  - id: no_tags_unsorted_samfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1116.2890625
    'sbg:y': 534
  - id: no_tags_unsorted_bamfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1177.2891845703125
    'sbg:y': 674
  - id: all_tags_sorted_samfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1152.2891845703125
    'sbg:y': 794
  - id: all_tags_sorted_bamfile_selected_regions
    outputSource:
      - create_sorted_unsorted_bam_and_sam_1/all_tags_sorted_bamfile
    type: File
    'sbg:x': 1185
    'sbg:y': 966
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
  - id: create_sorted_unsorted_bam_and_sam
    in:
      - id: threads
        source: threads
      - id: all_tags_sorted_bamfile
        source: samtools_sort/output_bam
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 670.7614135742188
    'sbg:y': 193
  - id: samtools_sort
    in:
      - id: input_alignment
        source: bowtie_index_and_align/aligned_samfile
      - id: output_format
        default: BAM
      - id: threads
        source: threads
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
      - id: stdout
      - id: stderr
    run: ../tools/samtools_sort.cwl
    label: samtools sort
    'sbg:x': 404
    'sbg:y': 221
  - id: subset_regions_from_alignment_file
    in:
      - id: sorted_bamfile
        source: samtools_sort/output_bam
      - id: threads
        source: threads
      - id: select_region
        default: '1 2:1-10000'
    out:
      - id: sorted_subset_bamfile
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions_from_alignment_file
    'sbg:x': 616
    'sbg:y': 604
  - id: create_sorted_unsorted_bam_and_sam_1
    in:
      - id: threads
        source: threads
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
    'sbg:x': 921
    'sbg:y': 693
requirements:
  - class: SubworkflowFeatureRequirement
