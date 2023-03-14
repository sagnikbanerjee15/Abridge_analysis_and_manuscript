class: Workflow
cwlVersion: v1.0
id: rna_seq_download_align_pe_se
label: rna_seq_download_align_pe_se
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int?
    'sbg:x': -659.8040771484375
    'sbg:y': 244.91036987304688
  - id: SRA_accession
    type: string
    'sbg:x': -656.7913208007812
    'sbg:y': 379.0256042480469
  - id: genomeFastaFiles
    type: File
    'sbg:x': -647.7528686523438
    'sbg:y': 637.2176513671875
  - id: genomeSAindexNbases
    type: int?
    'sbg:x': -656.7913208007812
    'sbg:y': 506.115234375
  - id: genomeChrBinNbits
    type: int?
    'sbg:x': -644.7400512695312
    'sbg:y': 770.3328857421875
  - id: number_of_reads_to_be_selected
    type: int
    'sbg:x': -638.5133666992188
    'sbg:y': 918.7924194335938
  - id: sample_or_whole
    type:
      type: enum
      symbols:
        - SAMPLE
        - WHOLE
      name: sample_or_whole
    'sbg:x': -642.7725830078125
    'sbg:y': 1061.7740478515625
outputs:
  - id: log_PE
    outputSource:
      - align_rna_seq_reads_and_produce_all_files_PE/log
    type: File
    'sbg:x': 1416.9769287109375
    'sbg:y': 982.0648193359375
  - id: log_SE
    outputSource:
      - align_rna_seq_reads_and_produce_all_files_SE/log
    type: File
    'sbg:x': 1408.455322265625
    'sbg:y': -273.63836669921875
  - id: no_tags_unsorted_samfile_SE
    outputSource:
      - rename_file_1/renamed_file
    type: File
    'sbg:x': 1376.4588623046875
    'sbg:y': -802.9772338867188
  - id: no_tags_unsorted_bamfile_SE
    outputSource:
      - rename_file_3/renamed_file
    type: File
    'sbg:x': 1400.5638427734375
    'sbg:y': -393.1061096191406
  - id: all_tags_sorted_samfile_SE
    outputSource:
      - rename_file_5/renamed_file
    type: File
    'sbg:x': 1419.6763916015625
    'sbg:y': -28.571475982666016
  - id: all_tags_sorted_bamfile_SE
    outputSource:
      - rename_file_7/renamed_file
    type: File
    'sbg:x': 1436.05859375
    'sbg:y': 221.7147216796875
  - id: all_tags_sorted_bamfile_PE
    outputSource:
      - rename_file_12/renamed_file
    type: File
    'sbg:x': 1423.4344482421875
    'sbg:y': 1473.6964111328125
  - id: all_tags_sorted_samfile_PE
    outputSource:
      - rename_file_14/renamed_file
    type: File
    'sbg:x': 1422.7210693359375
    'sbg:y': 1225.1171875
  - id: no_tags_unsorted_bamfile_PE
    outputSource:
      - rename_file_11/renamed_file
    type: File
    'sbg:x': 1418.6424560546875
    'sbg:y': 857.419189453125
  - id: no_tags_unsorted_samfile_PE
    outputSource:
      - rename_file_9/renamed_file
    type: File
    'sbg:x': 1410.1201171875
    'sbg:y': 626.3514404296875
  - id: no_tags_unsorted_cramfile_SE
    outputSource:
      - rename_file/renamed_file
    type: File
    'sbg:x': 1388.7283935546875
    'sbg:y': -594.137451171875
  - id: all_tags_sorted_cramfile_SE
    outputSource:
      - rename_file_2/renamed_file
    type: File
    'sbg:x': 1413.5147705078125
    'sbg:y': 99.4563217163086
  - id: no_tags_unsorted_cramfile_PE
    outputSource:
      - rename_file_4/renamed_file
    type: File
    'sbg:x': 1418.94775390625
    'sbg:y': 741.048583984375
  - id: all_tags_sorted_cramfile_PE
    outputSource:
      - rename_file_6/renamed_file
    type: File
    'sbg:x': 1424.5638427734375
    'sbg:y': 1344.299072265625
steps:
  - id: align_rna_seq_reads_and_produce_all_files_SE
    in:
      - id: runThreadN
        source: threads
      - id: raw_input_files
        source:
          - download_from_sra_and_convert_to_fastq/merged_fastq
      - id: genomeFastaFiles
        source:
          - genomeFastaFiles
      - id: genomeSAindexNbases
        source: genomeSAindexNbases
      - id: genomeChrBinNbits
        source: genomeChrBinNbits
      - id: SRA_accession
        source: SRA_accession
      - id: paired
        default: SE
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: log
      - id: no_tags_unsorted_cramfile
      - id: all_tags_sorted_cramfile
    run: ./align_rna_seq_reads_and_produce_all_files.cwl
    label: align_rna_seq_reads_and_produce_all_files_SE
    'sbg:x': 906.9373168945312
    'sbg:y': -236.55581665039062
  - id: align_rna_seq_reads_and_produce_all_files_PE
    in:
      - id: runThreadN
        source: threads
      - id: raw_input_files
        source:
          - download_from_sra_and_convert_to_fastq/pair1_fastq
          - download_from_sra_and_convert_to_fastq/pair2_fastq
      - id: genomeFastaFiles
        source:
          - genomeFastaFiles
      - id: genomeSAindexNbases
        source: genomeSAindexNbases
      - id: genomeChrBinNbits
        source: genomeChrBinNbits
      - id: SRA_accession
        source: SRA_accession
      - id: paired
        default: PE
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: log
      - id: no_tags_unsorted_cramfile
      - id: all_tags_sorted_cramfile
    run: ./align_rna_seq_reads_and_produce_all_files.cwl
    label: align_rna_seq_reads_and_produce_all_files_PE
    'sbg:x': 935.0303344726562
    'sbg:y': 932.7984008789062
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
    'sbg:x': 265.1205749511719
    'sbg:y': 391.0119934082031
  - id: rename_file_1
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_SE/no_tags_unsorted_samfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1209.9761962890625
    'sbg:y': -851.5555419921875
  - id: rename_file_3
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_SE/no_tags_unsorted_bamfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1143
    'sbg:y': -462.58123779296875
  - id: rename_file_5
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_SE/all_tags_sorted_samfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1205.901123046875
    'sbg:y': -69.0815200805664
  - id: rename_file_7
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_SE/all_tags_sorted_bamfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1165.3084716796875
    'sbg:y': 135.25477600097656
  - id: rename_file_9
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_PE/no_tags_unsorted_samfile
      - id: rename_text
        default: PE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1108.59521484375
    'sbg:y': 556.7857055664062
  - id: rename_file_11
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_PE/no_tags_unsorted_bamfile
      - id: rename_text
        default: PE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1148.297607421875
    'sbg:y': 769.6944580078125
  - id: rename_file_12
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_PE/all_tags_sorted_bamfile
      - id: rename_text
        default: PE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1091.848388671875
    'sbg:y': 1504.23291015625
  - id: rename_file_14
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_PE/all_tags_sorted_samfile
      - id: rename_text
        default: PE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1146.2896728515625
    'sbg:y': 1254.5357666015625
  - id: rename_file
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_SE/no_tags_unsorted_cramfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1189.5389404296875
    'sbg:y': -648.1114501953125
  - id: rename_file_2
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_SE/all_tags_sorted_cramfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1181.4599609375
    'sbg:y': 28.275924682617188
  - id: rename_file_4
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_PE/no_tags_unsorted_cramfile
      - id: rename_text
        default: PE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1136.5076904296875
    'sbg:y': 687.6414184570312
  - id: rename_file_6
    in:
      - id: input_file
        source: align_rna_seq_reads_and_produce_all_files_PE/all_tags_sorted_cramfile
      - id: rename_text
        default: PE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file
    'sbg:x': 1140.0694580078125
    'sbg:y': 1366.894287109375
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
