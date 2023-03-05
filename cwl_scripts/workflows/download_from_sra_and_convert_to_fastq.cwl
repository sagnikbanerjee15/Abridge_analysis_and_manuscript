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
  - id: number_of_reads_to_be_selected
    type: int
    'sbg:x': -43.640869140625
    'sbg:y': -81.52608489990234
outputs:
  - id: pair2_fastq
    outputSource:
      - downsample_fastq/downsampled_fastq
    type: File?
    'sbg:x': 856
    'sbg:y': -225
  - id: pair1_fastq
    outputSource:
      - downsample_fastq_1/downsampled_fastq
    type: File?
    'sbg:x': 894
    'sbg:y': -46
  - id: merged_fastq
    outputSource:
      - change_read_name_and_merge_from_pe_to_se/merged_fastq
    type: File
    'sbg:x': 1061
    'sbg:y': 101
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
        source: downsample_fastq_1/downsampled_fastq
      - id: fastq_file_pair2
        source: downsample_fastq/downsampled_fastq
    out:
      - id: merged_fastq
    run: ../tools/change_read_name_and_merge_from_pe_to_se.cwl
    label: change_read_name_and_merge_from_PE_to_SE
    'sbg:x': 923
    'sbg:y': 109
  - id: downsample_fastq
    in:
      - id: fastq_files
        source: sratools_fasterq_dump/pair2_fastq
      - id: number_of_reads_to_be_selected
        source: number_of_reads_to_be_selected
    out:
      - id: downsampled_fastq
    run: ../tools/downsample_fastq.cwl
    label: downsample_fastq
    'sbg:x': 584
    'sbg:y': -206
  - id: downsample_fastq_1
    in:
      - id: fastq_files
        source: sratools_fasterq_dump/pair1_fastq
      - id: number_of_reads_to_be_selected
        source: number_of_reads_to_be_selected
    out:
      - id: downsampled_fastq
    run: ../tools/downsample_fastq.cwl
    label: downsample_fastq
    'sbg:x': 645
    'sbg:y': -33
requirements: []
