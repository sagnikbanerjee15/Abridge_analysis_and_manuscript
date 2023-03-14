class: Workflow
cwlVersion: v1.0
id: download_from_sra_and_convert_to_fastq
label: download_from_sra_and_convert_to_fastq
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int?
    'sbg:x': 34
    'sbg:y': 65
  - id: SRA_accession
    type: string
    'sbg:x': 37.7578125
    'sbg:y': 215.5
  - id: number_of_reads_to_be_selected
    type: int
    'sbg:x': 44
    'sbg:y': -75
  - id: sample_or_whole
    type:
      type: enum
      symbols:
        - SAMPLE
        - WHOLE
      name: sample_or_whole
    'sbg:x': 35.1917724609375
    'sbg:y': 408.5331726074219
outputs:
  - id: pair1_fastq
    outputSource:
      - select_sampled_reads_or_all_reads_pair1/fastq
    type: File
    'sbg:x': 1483.6396484375
    'sbg:y': 353.5025329589844
  - id: pair2_fastq
    outputSource:
      - select_sampled_reads_or_all_reads_pair2/fastq
    type: File
    'sbg:x': 1436.954345703125
    'sbg:y': -466
  - id: merged_fastq
    outputSource:
      - select_sampled_reads_or_all_reads_1/fastq
    type: File
    'sbg:x': 1848.1319580078125
    'sbg:y': -119.08629608154297
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
    'sbg:x': 400.88323974609375
    'sbg:y': 40.35533142089844
  - id: change_read_name_and_merge_from_pe_to_se
    in:
      - id: fastq_file_pair1
        source: select_reads_randomly_seqtk_1/sampled_fastq
      - id: fastq_file_pair2
        source: select_reads_randomly_seqtk/sampled_fastq
    out:
      - id: merged_fastq
    run: ../tools/change_read_name_and_merge_from_pe_to_se.cwl
    label: change_read_name_and_merge_from_PE_to_SE
    'sbg:x': 1284.6751708984375
    'sbg:y': 122.95938873291016
  - id: select_reads_randomly_seqtk
    in:
      - id: fastq_filename
        source: sratools_fasterq_dump/pair2_fastq
      - id: number_of_reads_to_be_sampled
        source: number_of_reads_to_be_selected
    out:
      - id: sampled_fastq
    run: ../tools/select_reads_randomly_seqtk.cwl
    label: select_reads_randomly_seqtk
    'sbg:x': 598.5736083984375
    'sbg:y': -454.3045654296875
  - id: select_reads_randomly_seqtk_1
    in:
      - id: fastq_filename
        source: sratools_fasterq_dump/pair1_fastq
      - id: number_of_reads_to_be_sampled
        source: number_of_reads_to_be_selected
    out:
      - id: sampled_fastq
    run: ../tools/select_reads_randomly_seqtk.cwl
    label: select_reads_randomly_seqtk
    'sbg:x': 708.6751098632812
    'sbg:y': 477.0152282714844
  - id: change_read_name_and_merge_from_pe_to_se_1
    in:
      - id: fastq_file_pair1
        source: sratools_fasterq_dump/pair1_fastq
      - id: fastq_file_pair2
        source: sratools_fasterq_dump/pair2_fastq
    out:
      - id: merged_fastq
    run: ../tools/change_read_name_and_merge_from_pe_to_se.cwl
    label: change_read_name_and_merge_from_PE_to_SE
    'sbg:x': 802.071044921875
    'sbg:y': 26.563451766967773
  - id: select_sampled_reads_or_all_reads_pair1
    in:
      - id: sampled_fastq
        source: select_reads_randomly_seqtk_1/sampled_fastq
      - id: whole_fastq
        source: sratools_fasterq_dump/pair1_fastq
      - id: sample_or_whole
        source: sample_or_whole
    out:
      - id: fastq
    run: ../tools/select_sampled_reads_or_all_reads.cwl
    label: select_sampled_reads_or_all_reads_pair1
    'sbg:x': 1217.6700439453125
    'sbg:y': 401.36041259765625
  - id: select_sampled_reads_or_all_reads_pair2
    in:
      - id: sampled_fastq
        source: select_reads_randomly_seqtk/sampled_fastq
      - id: whole_fastq
        source: sratools_fasterq_dump/pair2_fastq
      - id: sample_or_whole
        source: sample_or_whole
    out:
      - id: fastq
    run: ../tools/select_sampled_reads_or_all_reads.cwl
    label: select_sampled_reads_or_all_reads_pair2
    'sbg:x': 1068
    'sbg:y': -414.4771423339844
  - id: select_sampled_reads_or_all_reads_1
    in:
      - id: sampled_fastq
        source: change_read_name_and_merge_from_pe_to_se/merged_fastq
      - id: whole_fastq
        source: change_read_name_and_merge_from_pe_to_se_1/merged_fastq
      - id: sample_or_whole
        source: sample_or_whole
    out:
      - id: fastq
    run: ../tools/select_sampled_reads_or_all_reads.cwl
    label: select_sampled_reads_or_all_reads
    'sbg:x': 1582.9136962890625
    'sbg:y': 8.167512893676758
requirements: []
