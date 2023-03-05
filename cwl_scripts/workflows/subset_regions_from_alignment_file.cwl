class: Workflow
cwlVersion: v1.0
id: subset_regions_from_alignment_file
label: subset_regions_from_alignment_file
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: sorted_bamfile
    type: File
    'sbg:x': -58
    'sbg:y': 5
  - id: threads
    type: int?
    'sbg:x': -10
    'sbg:y': -217.72335815429688
  - id: select_region
    type: string?
    'sbg:x': -80
    'sbg:y': 200
outputs:
  - id: sorted_subset_bamfile
    outputSource:
      - samtools_merge/output_bam
    type: File?
    'sbg:x': 752.15283203125
    'sbg:y': 107
steps:
  - id: samtools_subset
    in:
      - id: input_alignment
        source: sorted_bamfile
      - id: include_header
        default: true
      - id: threads
        source: threads
      - id: select_region
        source: select_region
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
    run: ../tools/samtools_subset.cwl
    label: samtools subset
    'sbg:x': 127.78125
    'sbg:y': -57.5
  - id: samtools_unmapped
    in:
      - id: input_alignment
        source: sorted_bamfile
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
      - id: stdout
      - id: stderr
    run: ../tools/samtools_unmapped_reads.cwl
    label: samtools unmapped
    'sbg:x': 186.78125
    'sbg:y': 161.5
  - id: samtools_merge
    in:
      - id: input_alignment
        source:
          - samtools_subset/output_bam
          - samtools_unmapped/output_bam
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
    run: ../tools/samtools_merge.cwl
    label: samtools merge
    'sbg:x': 462.625
    'sbg:y': 79
requirements:
  - class: MultipleInputFeatureRequirement
