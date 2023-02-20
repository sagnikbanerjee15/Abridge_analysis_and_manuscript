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
  - id: chromosome
    type: string?
    'sbg:x': 6.140827655792236
    'sbg:y': 711.2120361328125
outputs:
  - id: no_tags_unsorted_bamfile_SE
    outputSource:
      - subset_regions_from_alignment_file_5/output_bam
    type: File
    'sbg:x': 1744.51513671875
    'sbg:y': 272.3822937011719
  - id: all_tags_sorted_samfile_SE
    outputSource:
      - subset_regions_from_alignment_file_3/output_sam
    type: File
    'sbg:x': 1788.2138671875
    'sbg:y': 584.2417602539062
  - id: all_tags_sorted_bamfile_SE
    outputSource:
      - subset_regions_from_alignment_file_1/output_bam
    type: File
    'sbg:x': 1882.0987548828125
    'sbg:y': 826.6683349609375
  - id: no_tags_unsorted_samfile_PE
    outputSource:
      - subset_regions_from_alignment_file_6/output_sam
    type: File
    'sbg:x': 1310.38232421875
    'sbg:y': 28.829116821289062
  - id: no_tags_unsorted_bamfile_PE
    outputSource:
      - subset_regions_from_alignment_file_4/output_bam
    type: File
    'sbg:x': 1330.702392578125
    'sbg:y': 431.8671875
  - id: all_tags_sorted_samfile_PE
    outputSource:
      - subset_regions_from_alignment_file_2/output_sam
    type: File
    'sbg:x': 1332.3948974609375
    'sbg:y': 674.7645874023438
  - id: all_tags_sorted_bamfile_PE
    outputSource:
      - subset_regions_from_alignment_file/output_bam
    type: File
    'sbg:x': 1346.815185546875
    'sbg:y': 1016.343017578125
  - id: no_tags_unsorted_samfile_SE
    outputSource:
      - subset_regions_from_alignment_file_7/output_sam
    type: File?
    'sbg:x': 1600.06201171875
    'sbg:y': -322.6999816894531
  - id: all_chr_no_tags_unsorted_samfile_SE
    outputSource:
      - rename_file_no_tags_unsorted_samfile_SE/renamed_file
    type: File
    'sbg:x': 1582.4505615234375
    'sbg:y': -407.87213134765625
  - id: all_chr_no_tags_unsorted_samfile_PE
    outputSource:
      - rename_file_no_tags_unsorted_samfile_PE/renamed_file
    type: File
    'sbg:x': 1318.8291015625
    'sbg:y': -71.61138916015625
  - id: all_chr_no_tags_unsorted_bamfile_SE
    outputSource:
      - rename_file_no_tags_unsorted_bamfile_SE/renamed_file
    type: File
    'sbg:x': 1739.1138916015625
    'sbg:y': 161.38861083984375
  - id: all_chr_no_tags_unsorted_bamfile_PE
    outputSource:
      - rename_file_no_tags_unsorted_bamfile_PE/renamed_file
    type: File
    'sbg:x': 1330
    'sbg:y': 315.8088684082031
  - id: all_chr_all_tags_sorted_samfile_SE
    outputSource:
      - rename_file_all_tags_sorted_samfile_SE/renamed_file
    type: File
    'sbg:x': 1804.5008544921875
    'sbg:y': 467.25885009765625
  - id: all_chr_all_tags_sorted_samfile_PE
    outputSource:
      - rename_file_all_tags_sorted_samfile_PE/renamed_file
    type: File
    'sbg:x': 1326.669189453125
    'sbg:y': 577.9588623046875
  - id: all_chr_all_tags_sorted_bamfile_SE
    outputSource:
      - rename_file_all_tags_sorted_bamfile_SE/renamed_file
    type: File
    'sbg:x': 1877.98095703125
    'sbg:y': 745.8341674804688
  - id: all_chr_all_tags_sorted_bamfile_PE
    outputSource:
      - rename_file_all_tags_sorted_bamfile_PE/renamed_file
    type: File
    'sbg:x': 1346.2862548828125
    'sbg:y': 873.6256103515625
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
    'sbg:x': 176.703125
    'sbg:y': 471.140625
  - id: align_dna_seq_reads_and_produce_all_files_SE_SE
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
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
    run: ./align_dna_seq_reads_and_produce_all_files.cwl
    label: align_dna_seq_reads_and_produce_all_files_SE_SE
    'sbg:x': 440.76202392578125
    'sbg:y': 375.8671875
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
    out:
      - id: no_tags_unsorted_samfile
      - id: no_tags_unsorted_bamfile
      - id: all_tags_sorted_samfile
      - id: all_tags_sorted_bamfile
    run: ./align_dna_seq_reads_and_produce_all_files.cwl
    label: align_dna_seq_reads_and_produce_all_files_PE
    'sbg:x': 440.76202392578125
    'sbg:y': 538.4140625
  - id: rename_file_no_tags_unsorted_samfile_SE
    in:
      - id: input_file
        source: >-
          align_dna_seq_reads_and_produce_all_files_SE_SE/no_tags_unsorted_samfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file_no_tags_unsorted_samfile_SE
    'sbg:x': 806.4249877929688
    'sbg:y': 2.953125
  - id: rename_file_no_tags_unsorted_bamfile_SE
    in:
      - id: input_file
        source: >-
          align_dna_seq_reads_and_produce_all_files_SE_SE/no_tags_unsorted_bamfile
      - id: rename_text
        default: SE_no_tags_unsorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file_no_tags_unsorted_bamfile_SE
    'sbg:x': 806.4249877929688
    'sbg:y': 244.046875
  - id: rename_file_all_tags_sorted_samfile_SE
    in:
      - id: input_file
        source: >-
          align_dna_seq_reads_and_produce_all_files_SE_SE/all_tags_sorted_samfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file_all_tags_sorted_samfile_SE
    'sbg:x': 806.4249877929688
    'sbg:y': 485.140625
  - id: rename_file_all_tags_sorted_bamfile_SE
    in:
      - id: input_file
        source: >-
          align_dna_seq_reads_and_produce_all_files_SE_SE/all_tags_sorted_bamfile
      - id: rename_text
        default: SE_all_tags_sorted
      - id: SRA_accession
        source: SRA_accession
    out:
      - id: renamed_file
    run: ../tools/rename_file.cwl
    label: rename_file_all_tags_sorted_bamfile_SE
    'sbg:x': 806.4249877929688
    'sbg:y': 726.234375
  - id: rename_file_no_tags_unsorted_samfile_PE
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
    label: rename_file_no_tags_unsorted_samfile_PE
    'sbg:x': 806.4249877929688
    'sbg:y': 123.5
  - id: rename_file_no_tags_unsorted_bamfile_PE
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
    label: rename_file_no_tags_unsorted_bamfile_PE
    'sbg:x': 806.4249877929688
    'sbg:y': 364.59375
  - id: rename_file_all_tags_sorted_samfile_PE
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
    label: rename_file_all_tags_sorted_samfile_PE
    'sbg:x': 806.4249877929688
    'sbg:y': 605.6875
  - id: rename_file_all_tags_sorted_bamfile_PE
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
    label: rename_file_all_tags_sorted_bamfile_PE
    'sbg:x': 806.4249877929688
    'sbg:y': 846.78125
  - id: subset_regions_from_alignment_file
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
    'sbg:x': 1067.373291015625
    'sbg:y': 942.0546875
  - id: subset_regions_from_alignment_file_1
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
    'sbg:x': 1067.373291015625
    'sbg:y': 807.5078125
  - id: subset_regions_from_alignment_file_2
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
    'sbg:x': 1067.373291015625
    'sbg:y': 672.9609375
  - id: subset_regions_from_alignment_file_3
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
    'sbg:x': 1067.373291015625
    'sbg:y': 538.4140625
  - id: subset_regions_from_alignment_file_4
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
    'sbg:x': 1067.373291015625
    'sbg:y': 403.8671875
  - id: subset_regions_from_alignment_file_5
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
    'sbg:x': 1067.373291015625
    'sbg:y': 269.3203125
  - id: subset_regions_from_alignment_file_6
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
    'sbg:x': 1067.373291015625
    'sbg:y': 134.7734375
  - id: subset_regions_from_alignment_file_7
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
    'sbg:x': 1058.097412109375
    'sbg:y': -30.179746627807617
requirements:
  - class: SubworkflowFeatureRequirement
