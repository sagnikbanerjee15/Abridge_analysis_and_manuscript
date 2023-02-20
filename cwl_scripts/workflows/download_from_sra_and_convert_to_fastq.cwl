class: Workflow
cwlVersion: v1.0
id: download_from_sra_and_convert_to_fastq
label: download_from_sra_and_convert_to_fastq
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int?
    'sbg:x': 0
    'sbg:y': 60.5
  - id: SRA_accession
    type: string
    'sbg:x': 37.7578125
    'sbg:y': 215.5
outputs:
  - id: pair2_fastq
    outputSource:
      - sratools_fasterq_dump/pair2_fastq
    type: File?
    'sbg:x': 608.6571655273438
    'sbg:y': 0
  - id: pair1_fastq
    outputSource:
      - sratools_fasterq_dump/pair1_fastq
    type: File?
    'sbg:x': 608.6571655273438
    'sbg:y': 107
  - id: merged_fastq
    outputSource:
      - change_read_name_and_merge_from_pe_to_se/merged_fastq
    type: File
    'sbg:x': 900.0634155273438
    'sbg:y': 114
steps:
  - id: sratools_fasterq_dump
    in:
      - id: SRA_accession
        source: SRA_accession
      - id: threads
        source: threads
    out:
      - id: fastqs
      - id: pair1_fastq
      - id: pair2_fastq
    run: ../tools/sratools_fasterq_dump.cwl
    label: sratools_fasterq_dump
    'sbg:x': 392.546875
    'sbg:y': 100
  - id: change_read_name_and_merge_from_pe_to_se
    in:
      - id: fastq_file_pair1
        source: sratools_fasterq_dump/pair1_fastq
      - id: fastq_file_pair2
        source: sratools_fasterq_dump/pair2_fastq
    out:
      - id: merged_fastq
    run: ../tools/change_read_name_and_merge_from_pe_to_se.cwl
    label: change_read_name_and_merge_from_PE_to_SE
    'sbg:x': 608.6571655273438
    'sbg:y': 221
requirements: []
