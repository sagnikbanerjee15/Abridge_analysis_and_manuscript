class: Workflow
cwlVersion: v1.0
id: rna_seq_download_align_pe_se
label: rna_seq_download_align_pe_se
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: threads
    type: int?
    'sbg:x': -1196.8343505859375
    'sbg:y': -117.18411254882812
  - id: SRA_accession
    type: string
    'sbg:x': -1082.22607421875
    'sbg:y': 1185.9326171875
  - id: genomeFastaFiles
    type: File
    'sbg:x': -794.9031982421875
    'sbg:y': 970.7398071289062
  - id: genomeSAindexNbases
    type: int?
    'sbg:x': -810.4547729492188
    'sbg:y': 611.7125244140625
  - id: genomeChrBinNbits
    type: int?
    'sbg:x': -797.4292602539062
    'sbg:y': 802.6921997070312
  - id: chromosome
    type: string?
    'sbg:x': -1192.1026611328125
    'sbg:y': 1947.4228515625
outputs:
  - id: no_tags_unsorted_samfile_SE
    outputSource:
      - subset_regions_from_alignment_file_1/output_sam
    type: File
    'sbg:x': 1631.12548828125
    'sbg:y': 206.54345703125
  - id: no_tags_unsorted_bamfile_SE
    outputSource:
      - subset_regions_from_alignment_file_2/output_bam
    type: File
    'sbg:x': 1631.12548828125
    'sbg:y': 311.9715881347656
  - id: all_tags_sorted_samfile_SE
    outputSource:
      - subset_regions_from_alignment_file_4/output_sam
    type: File
    'sbg:x': 1666.9285888671875
    'sbg:y': 472.046630859375
  - id: all_tags_sorted_bamfile_SE
    outputSource:
      - subset_regions_from_alignment_file_6/output_bam
    type: File
    'sbg:x': 1619.8192138671875
    'sbg:y': 666.0404052734375
  - id: no_tags_unsorted_samfile_PE
    outputSource:
      - subset_regions_from_alignment_file/output_sam
    type: File
    'sbg:x': 1464.67822265625
    'sbg:y': 976.9035034179688
  - id: no_tags_unsorted_bamfile_PE
    outputSource:
      - subset_regions_from_alignment_file_3/output_bam
    type: File
    'sbg:x': 1432.6439208984375
    'sbg:y': 1176.5504150390625
  - id: all_tags_sorted_samfile_PE
    outputSource:
      - subset_regions_from_alignment_file_5/output_sam
    type: File
    'sbg:x': 1432.6439208984375
    'sbg:y': 1336.62548828125
  - id: all_tags_sorted_bamfile_PE
    outputSource:
      - subset_regions_from_alignment_file_7/output_bam
    type: File
    'sbg:x': 1364.8062744140625
    'sbg:y': 1521.197265625
  - id: log_PE
    outputSource:
      - align_rna_seq_reads_and_produce_all_files_PE/log
    type: File
    'sbg:x': -66.21389770507812
    'sbg:y': 1134.887451171875
  - id: log_SE
    outputSource:
      - align_rna_seq_reads_and_produce_all_files_SE/log
    type: File
    'sbg:x': -124.62956237792969
    'sbg:y': 273.8245544433594
  - id: all_chr_no_tags_unsorted_samfile_SE
    outputSource:
      - rename_file_no_tags_unsorted_samfile_SE/renamed_file
    type: File
    'sbg:x': 1158.0811767578125
    'sbg:y': -380.3377380371094
  - id: all_chr_no_tags_unsorted_bamfile_SE
    outputSource:
      - rename_file_no_tags_unsorted_bamfile_SE/renamed_file
    type: File
    'sbg:x': 1149.231201171875
    'sbg:y': -268.8719482421875
  - id: all_chr_all_tags_sorted_samfile_SE
    outputSource:
      - rename_file_all_tags_sorted_samfile_SE/renamed_file
    type: File
    'sbg:x': 1154.421875
    'sbg:y': -137.3468780517578
  - id: all_chr_all_tags_sorted_bamfile_SE
    outputSource:
      - rename_file_all_tags_sorted_bamfile_SE/renamed_file
    type: File
    'sbg:x': 1159.0064697265625
    'sbg:y': -15.453235626220703
  - id: all_chr_all_tags_sorted_bamfile_PE
    outputSource:
      - rename_file_all_tags_sorted_bamfile_PE/renamed_file
    type: File
    'sbg:x': 1089.28515625
    'sbg:y': 2426.05322265625
  - id: all_chr_all_tags_sorted_samfile_PE
    outputSource:
      - rename_file_all_tags_sorted_samfile_PE/renamed_file
    type: File
    'sbg:x': 1121.3193359375
    'sbg:y': 2260.227294921875
  - id: all_chr_no_tags_unsorted_bamfile_PE
    outputSource:
      - rename_file_no_tags_unsorted_bamfile_PE/renamed_file
    type: File
    'sbg:x': 1151.4693603515625
    'sbg:y': 2111.36181640625
  - id: all_chr_no_tags_unsorted_samfile_PE
    outputSource:
      - rename_file_no_tags_unsorted_samfile_PE/renamed_file
    type: File
    'sbg:x': 1151.4693603515625
    'sbg:y': 1919.1556396484375
steps:
  - id: download_from_sra_and_convert_to_fastq
    in:
      - id: threads
        source: threads
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: pair2_fastq
      - id: pair1_fastq
      - id: merged_fastq
    run: ./download_from_sra_and_convert_to_fastq.cwl
    label: download_from_sra_and_convert_to_fastq
    'sbg:x': -632.3751220703125
    'sbg:y': 425.6837158203125
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
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: log
    run: ./align_rna_seq_reads_and_produce_all_files.cwl
    label: align_rna_seq_reads_and_produce_all_files_SE
    'sbg:x': -258.3708190917969
    'sbg:y': 474.123291015625
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
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
      - id: log
    run: ./align_rna_seq_reads_and_produce_all_files.cwl
    label: align_rna_seq_reads_and_produce_all_files_PE
    'sbg:x': -241.0936737060547
    'sbg:y': 891.880859375
  - id: rename_file_no_tags_unsorted_samfile_SE
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
    label: rename_file_no_tags_unsorted_samfile_SE
    'sbg:x': 500.5682678222656
    'sbg:y': 129.34841918945312
  - id: rename_file_no_tags_unsorted_bamfile_SE
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
    label: rename_file_no_tags_unsorted_bamfile_SE
    'sbg:x': 508.10577392578125
    'sbg:y': 282.6953125
  - id: rename_file_all_tags_sorted_samfile_SE
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
    label: rename_file_all_tags_sorted_samfile_SE
    'sbg:x': 508.10577392578125
    'sbg:y': 404.0078125
  - id: rename_file_all_tags_sorted_bamfile_SE
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
    label: rename_file_all_tags_sorted_bamfile_SE
    'sbg:x': 508.10577392578125
    'sbg:y': 525.3203125
  - id: rename_file_no_tags_unsorted_samfile_PE
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
    label: rename_file_no_tags_unsorted_samfile_PE
    'sbg:x': 908.0086059570312
    'sbg:y': 931.8533935546875
  - id: rename_file_no_tags_unsorted_bamfile_PE
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
    label: rename_file_no_tags_unsorted_bamfile_PE
    'sbg:x': 909.8930053710938
    'sbg:y': 1107.812744140625
  - id: rename_file_all_tags_sorted_samfile_PE
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
    label: rename_file_all_tags_sorted_samfile_PE
    'sbg:x': 908.0086059570312
    'sbg:y': 1234.7784423828125
  - id: rename_file_all_tags_sorted_bamfile_PE
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
    label: rename_file_all_tags_sorted_bamfile_PE
    'sbg:x': 908.0086059570312
    'sbg:y': 1397.5472412109375
  - id: subset_regions_from_alignment_file
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_no_tags_unsorted_samfile_PE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: SAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1184.5283203125
    'sbg:y': 950.1596069335938
  - id: subset_regions_from_alignment_file_1
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_no_tags_unsorted_samfile_SE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: SAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1185.0118408203125
    'sbg:y': 181.6967315673828
  - id: subset_regions_from_alignment_file_2
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_no_tags_unsorted_bamfile_SE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: BAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1203.855712890625
    'sbg:y': 338.4625244140625
  - id: subset_regions_from_alignment_file_3
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_no_tags_unsorted_bamfile_PE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: BAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1186.41259765625
    'sbg:y': 1120.1160888671875
  - id: subset_regions_from_alignment_file_4
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_all_tags_sorted_samfile_SE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: SAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1224.5838623046875
    'sbg:y': 500.8814697265625
  - id: subset_regions_from_alignment_file_5
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_all_tags_sorted_samfile_PE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: SAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1146.8406982421875
    'sbg:y': 1316.4537353515625
  - id: subset_regions_from_alignment_file_6
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_all_tags_sorted_bamfile_SE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: BAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1215.161865234375
    'sbg:y': 675.9644165039062
  - id: subset_regions_from_alignment_file_7
    in:
      - id: threads
        source: threads
      - id: input_alignment
        source: rename_file_all_tags_sorted_bamfile_PE/renamed_file
      - id: chromosome
        source: chromosome
      - id: alignment_file_format
        default: BAM
    out:
      - id: output_sam
      - id: output_bam
    run: ./subset_regions_from_alignment_file.cwl
    label: subset_regions
    'sbg:x': 1116.6907958984375
    'sbg:y': 1478.8726806640625
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
