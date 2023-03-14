class: Workflow
cwlVersion: v1.0
id: dna_seq_download_align_pe_se
label: dna_seq_download_align_pe_se
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int?
    'sbg:x': 0
    'sbg:y': 378.59375
  - id: SRA_accession
    type: string
    'sbg:x': 0
    'sbg:y': 485.140625
  - id: reference
    type: File
    'sbg:x': 0
    'sbg:y': 591.6875
  - id: number_of_reads_to_be_selected
    type: int
    'sbg:x': 10.152168273925781
    'sbg:y': 736.2301025390625
  - id: sample_or_whole
    type:
      type: enum
      symbols:
        - SAMPLE
        - WHOLE
      name: sample_or_whole
    'sbg:x': 8.428817749023438
    'sbg:y': 864.586181640625
outputs:
  - id: no_tags_unsorted_cramfile_SE
    outputSource:
      - rename_file/renamed_file
    type: File
    'sbg:x': 1182.2381591796875
    'sbg:y': -767.3264770507812
  - id: no_tags_unsorted_samfile_SE
    outputSource:
      - rename_file_1/renamed_file
    type: File
    'sbg:x': 1130.843017578125
    'sbg:y': -966.469482421875
  - id: no_tags_unsorted_bamfile_SE
    outputSource:
      - rename_file_3/renamed_file
    type: File?
    'sbg:x': 1240.528564453125
    'sbg:y': -359.824951171875
  - id: log_SE
    outputSource:
      - align_dna_seq_reads_and_produce_all_files_SE/error
    type: File
    'sbg:x': 1243.9273681640625
    'sbg:y': -225.59408569335938
  - id: all_tags_sorted_samfile_SE
    outputSource:
      - rename_file_6/renamed_file
    type: File?
    'sbg:x': 1315.9241943359375
    'sbg:y': 134.8195343017578
  - id: all_tags_sorted_cramfile_SE
    outputSource:
      - rename_file_5/renamed_file
    type: File
    'sbg:x': 1320.22265625
    'sbg:y': 253.0890655517578
  - id: all_tags_sorted_bamfile_SE
    outputSource:
      - rename_file_4/renamed_file
    type: File?
    'sbg:x': 1276.21240234375
    'sbg:y': 396.8399963378906
  - id: no_tags_unsorted_samfile_PE
    outputSource:
      - rename_file_9/renamed_file
    type: File
    'sbg:x': 1316.9918212890625
    'sbg:y': 959.2432861328125
  - id: no_tags_unsorted_cramfile_PE
    outputSource:
      - rename_file_10/renamed_file
    type: File?
    'sbg:x': 1322
    'sbg:y': 1075.656982421875
  - id: no_tags_unsorted_bamfile_PE
    outputSource:
      - rename_file_11/renamed_file
    type: File?
    'sbg:x': 1347.596923828125
    'sbg:y': 1195.866455078125
  - id: log_PE
    outputSource:
      - align_dna_seq_reads_and_produce_all_files_PE/error
    type: File
    'sbg:x': 1344.1790771484375
    'sbg:y': 1375.523681640625
  - id: all_tags_sorted_samfile_PE
    outputSource:
      - rename_file_14/renamed_file
    type: File?
    'sbg:x': 1335.6845703125
    'sbg:y': 1674.4864501953125
  - id: all_tags_sorted_cramfile_PE
    outputSource:
      - rename_file_13/renamed_file
    type: File
    'sbg:x': 1350.97705078125
    'sbg:y': 1852.892333984375
  - id: all_tags_sorted_bamfile_PE
    outputSource:
      - rename_file_12/renamed_file
    type: File?
    'sbg:x': 1335.685546875
    'sbg:y': 2070.377685546875
steps:
  - id: download_from_sra_and_convert_to_fastq
    in:
      - id: threads
        source: threads
      - id: SRA_accession
        source: SRA_accession
      - id: number_of_reads_to_be_selected
        source: number_of_reads_to_be_selected
      - id: sample_or_whole
        source: sample_or_whole
    out:
      - id: pair1_fastq
      - id: pair2_fastq
      - id: merged_fastq
    run: ./download_from_sra_and_convert_to_fastq.cwl
    label: download_from_sra_and_convert_to_fastq
    'sbg:x': 401.2880859375
    'sbg:y': 469.0409851074219
  - id: align_dna_seq_reads_and_produce_all_files_SE
    in:
      - id: unpaired
        source: download_from_sra_and_convert_to_fastq/merged_fastq
      - id: threads
        source: threads
      - id: reference
        source: reference
      - id: mate2
        source: download_from_sra_and_convert_to_fastq/pair2_fastq
      - id: mate1
        source: download_from_sra_and_convert_to_fastq/pair1_fastq
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: error
      - id: no_tags_unsorted_cramfile
      - id: all_tags_sorted_cramfile
    run: ./align_dna_seq_reads_and_produce_all_files.cwl
    label: align_dna_seq_reads_and_produce_all_files_SE
    'sbg:x': 839.2227783203125
    'sbg:y': -147.9590301513672
  - id: align_dna_seq_reads_and_produce_all_files_PE
    in:
      - id: unpaired
        source: download_from_sra_and_convert_to_fastq/merged_fastq
      - id: threads
        source: threads
      - id: reference
        source: reference
      - id: mate2
        source: download_from_sra_and_convert_to_fastq/pair2_fastq
      - id: mate1
        source: download_from_sra_and_convert_to_fastq/pair1_fastq
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: error
      - id: no_tags_unsorted_cramfile
      - id: all_tags_sorted_cramfile
    run: ./align_dna_seq_reads_and_produce_all_files.cwl
    label: align_dna_seq_reads_and_produce_all_files_PE
    'sbg:x': 859.5748901367188
    'sbg:y': 1384.0767822265625
  - id: rename_file
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_SE/no_tags_unsorted_cramfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 967.960205078125
    'sbg:y': -675.94140625
  - id: rename_file_1
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_SE/no_tags_unsorted_samfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 896.9361572265625
    'sbg:y': -847.1809692382812
  - id: rename_file_3
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_SE/no_tags_unsorted_bamfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1017.662353515625
    'sbg:y': -403.7509460449219
  - id: rename_file_4
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_SE/all_tags_sorted_bamfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 993.7750244140625
    'sbg:y': 394.9554748535156
  - id: rename_file_5
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_SE/all_tags_sorted_cramfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1036.8065185546875
    'sbg:y': 302.77410888671875
  - id: rename_file_6
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_SE/all_tags_sorted_samfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1062.7940673828125
    'sbg:y': 167.94126892089844
  - id: rename_file_9
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_PE/no_tags_unsorted_samfile
      - id: rename_text
        default: PE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 987.5523681640625
    'sbg:y': 930.76171875
  - id: rename_file_10
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_PE/no_tags_unsorted_cramfile
      - id: rename_text
        default: PE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1039.7015380859375
    'sbg:y': 1044.149169921875
  - id: rename_file_11
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_PE/no_tags_unsorted_bamfile
      - id: rename_text
        default: PE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1078.0601806640625
    'sbg:y': 1169.2093505859375
  - id: rename_file_12
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_PE/all_tags_sorted_bamfile
      - id: rename_text
        default: PE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1000.984375
    'sbg:y': 1960.117919921875
  - id: rename_file_13
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_PE/all_tags_sorted_cramfile
      - id: rename_text
        default: PE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1044.11181640625
    'sbg:y': 1844.296630859375
  - id: rename_file_14
    in:
      - id: input_file
        source: align_dna_seq_reads_and_produce_all_files_PE/all_tags_sorted_samfile
      - id: rename_text
        default: PE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1058.5078125
    'sbg:y': 1725.612548828125
requirements:
  - class: SubworkflowFeatureRequirement
