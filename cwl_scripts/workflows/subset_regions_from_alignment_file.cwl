class: Workflow
cwlVersion: v1.0
id: subset_regions_from_alignment_file
label: subset_regions
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int?
    'sbg:x': -6
    'sbg:y': -206.5425262451172
  - id: input_alignment
    type: File
    'sbg:x': -19
    'sbg:y': 285
  - id: chromosome
    type: string?
    'sbg:x': -19
    'sbg:y': 442
  - id: to
    type: int?
    'sbg:x': -16
    'sbg:y': 5
  - id: from
    type: int?
    'sbg:x': -15
    'sbg:y': 152
  - id: alignment_file_format
    type:
      type: enum
      symbols:
        - SAM
        - BAM
        - CRAM
      name: alignment_file_format
    'sbg:x': -22
    'sbg:y': 587.1808471679688
outputs:
  - id: output_sam
    outputSource:
      - samtools_view_1/output_sam
    type: File?
    'sbg:x': 1021.619873046875
    'sbg:y': 121
  - id: output_bam
    outputSource:
      - samtools_view_1/output_bam
    type: File?
    'sbg:x': 1021.619873046875
    'sbg:y': 228
steps:
  - id: samtools_view
    in:
      - id: input_alignment
        source: input_alignment
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
    'sbg:x': 161
    'sbg:y': -64
  - id: select_region_from_samfile
    in:
      - id: samfile
        source: samtools_view/output_sam
      - id: chromosome
        source: chromosome
      - id: from
        source: from
      - id: to
        source: to
      - id: include_unmapped_reads
        default: 'yes'
    out:
      - id: subset_samalignments
    run: ../tools/select_region_from_samfile.cwl
    label: select_region_from_samfile
    'sbg:x': 402
    'sbg:y': 110
  - id: samtools_view_1
    in:
      - id: input_alignment
        source: select_region_from_samfile/subset_samalignments
      - id: output_format
        source: alignment_file_format
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
    'sbg:x': 755.0564575195312
    'sbg:y': 160.5
requirements: []
