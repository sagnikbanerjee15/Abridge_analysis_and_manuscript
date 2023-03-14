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
    'sbg:y': 107.0625
  - id: reference
    type: File
    'sbg:x': 0
    'sbg:y': 321.1875
  - id: mate2
    type: File?
    'sbg:x': 0
    'sbg:y': 428.25
  - id: mate1
    type: File?
    'sbg:x': 0
    'sbg:y': 535.3125
  - id: SRA_accession
    type: string
    'sbg:x': 0
    'sbg:y': 214.125
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_samfile
    type: File
    'sbg:x': 1149.28271484375
    'sbg:y': 0
  - id: no_tags_unsorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_bamfile
    type: File?
    'sbg:x': 1149.28271484375
    'sbg:y': 214.125
  - id: all_tags_sorted_samfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_samfile
    type: File?
    'sbg:x': 1149.28271484375
    'sbg:y': 321.1875
  - id: all_tags_sorted_bamfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_bamfile
    type: File?
    'sbg:x': 1149.28271484375
    'sbg:y': 535.3125
  - id: error
    outputSource:
      - bowtie_index_and_align/error
    type: File
    'sbg:x': 447.182373046875
    'sbg:y': 321.1875
  - id: no_tags_unsorted_cramfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/no_tags_unsorted_cramfile
    type: File?
    'sbg:x': 1149.28271484375
    'sbg:y': 107.0625
  - id: all_tags_sorted_cramfile
    outputSource:
      - create_sorted_unsorted_bam_and_sam/all_tags_sorted_cramfile
    type: File?
    'sbg:x': 1149.28271484375
    'sbg:y': 428.25
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
    'sbg:x': 176.859375
    'sbg:y': 239.65625
  - id: create_sorted_unsorted_bam_and_sam
    in:
      - id: threads
        source: threads
      - id: all_tags_sorted_bamfile
        source: samtools_sort/output_bam
      - id: SRA_accession
        source: SRA_accession
      - id: reference
        source: reference
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: no_tags_unsorted_cramfile
      - id: all_tags_sorted_cramfile
    run: ./create_sorted_unsorted_bam_and_sam.cwl
    label: create_sorted_unsorted_bam_and_sam
    'sbg:x': 736.710205078125
    'sbg:y': 232.65625
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
    'sbg:x': 447.182373046875
    'sbg:y': 186.125
requirements:
  - class: SubworkflowFeatureRequirement
