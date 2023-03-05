class: Workflow
cwlVersion: v1.0
id: create_sorted_unsorted_bam_and_sam
label: create_sorted_unsorted_bam_and_sam
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int
    'sbg:x': -92
    'sbg:y': -345
  - id: all_tags_sorted_bamfile
    type: File
    'sbg:x': -92.3303451538086
    'sbg:y': -80.8399429321289
  - id: SRA_accession
    type: string
    'sbg:x': -76.2149658203125
    'sbg:y': 146.65780639648438
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - rename_file/renamed_file
    type: File
    'sbg:x': 778
    'sbg:y': -245
  - id: no_tags_unsorted_bamfile
    outputSource:
      - samtools_view_1/output_bam
    type: File?
    'sbg:x': 809
    'sbg:y': -424
  - id: all_tags_sorted_samfile
    outputSource:
      - samtools_view_2/output_sam
    type: File?
    'sbg:x': 652
    'sbg:y': -48
  - id: all_tags_sorted_bamfile
    outputSource:
      - rename_file_1/renamed_file
    type: File
    'sbg:x': 686.9691162109375
    'sbg:y': 205.5328826904297
steps:
  - id: remove_sam_tags
    in:
      - id: samfile
        source: samtools_sort_1/output_sam
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
      - id: rename_string
        default: unsorted_no_tags
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
    run: ../tools/samtools_view.cwl
    label: samtools view
    'sbg:x': 593
    'sbg:y': -503
  - id: samtools_view_2
    in:
      - id: input_alignment
        source: all_tags_sorted_bamfile
      - id: output_format
        default: SAM
      - id: include_header
        default: true
      - id: threads
        source: threads
      - id: rename_string
        default: sorted_all_tags
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
    run: ../tools/samtools_view.cwl
    label: samtools view
    'sbg:x': 467.5590515136719
    'sbg:y': 0
  - id: samtools_sort_1
    in:
      - id: input_alignment
        source: all_tags_sorted_bamfile
      - id: output_format
        default: SAM
      - id: threads
        source: threads
      - id: sort_by_name
        default: true
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
      - id: stdout
      - id: stderr
    run: ../tools/samtools_sort.cwl
    label: samtools sort by name
    'sbg:x': 211.3060302734375
    'sbg:y': -284.76953125
  - id: rename_file
    in:
      - id: input_file
        source: remove_sam_tags/no_tags_samfile
      - id: rename_text
        default: unsorted_no_tags
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 642
    'sbg:y': -293
  - id: rename_file_1
    in:
      - id: input_file
        source: all_tags_sorted_bamfile
      - id: rename_text
        default: sorted_all_tags
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 462.9691162109375
    'sbg:y': 168.5
requirements: []
