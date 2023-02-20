class: Workflow
cwlVersion: v1.0
id: create_sorted_unsorted_bam_and_sam
label: create_sorted_unsorted_bam_and_sam
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int
    'sbg:x': -89
    'sbg:y': -259.7069091796875
  - id: all_tags_unsorted_bamfile
    type: File
    'sbg:x': -110
    'sbg:y': 24
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - remove_sam_tags/no_tags_samfile
    type: File
    'sbg:x': 778
    'sbg:y': -245
  - id: no_tags_unsorted_bamfile
    outputSource:
      - samtools_view_1/output_bam
    type: File?
    'sbg:x': 809
    'sbg:y': -424
  - id: all_tags_sorted_bamfile
    outputSource:
      - samtools_sort/output_bam
    type: File?
    'sbg:x': 431
    'sbg:y': 296
  - id: all_tags_sorted_samfile
    outputSource:
      - samtools_view_2/output_sam
    type: File?
    'sbg:x': 652
    'sbg:y': -48
steps:
  - id: samtools_view
    in:
      - id: input_alignment
        source: all_tags_unsorted_bamfile
      - id: output_format
        default: SAM
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
    'sbg:x': 229
    'sbg:y': -283
  - id: remove_sam_tags
    in:
      - id: samfile
        source: samtools_view/output_sam
    out:
      - id: no_tags_samfile
    run: ../tools/remove_sam_tags.cwl
    label: remove_tags
    'sbg:x': 419
    'sbg:y': -376.78912353515625
  - id: samtools_view_1
    in:
      - id: input_alignment
        source: remove_sam_tags/no_tags_samfile
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
    'sbg:x': 593
    'sbg:y': -503
  - id: samtools_sort
    in:
      - id: input_alignment
        source: all_tags_unsorted_bamfile
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
    'sbg:x': 229
    'sbg:y': 141
  - id: samtools_view_2
    in:
      - id: input_alignment
        source: samtools_sort/output_bam
      - id: output_format
        default: SAM
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
    'sbg:x': 467.5590515136719
    'sbg:y': 0
requirements: []
