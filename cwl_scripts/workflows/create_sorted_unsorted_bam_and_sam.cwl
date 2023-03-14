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
  - id: reference
    type: File?
    'sbg:x': -135.49032592773438
    'sbg:y': -554.0030517578125
outputs:
  - id: no_tags_unsorted_samfile
    outputSource:
      - rename_file/renamed_file
    type: File
    'sbg:x': 775.8770751953125
    'sbg:y': -431.81689453125
  - id: no_tags_unsorted_bamfile
    outputSource:
      - samtools_view_1/output_bam
    type: File?
    'sbg:x': 786.7093505859375
    'sbg:y': -568.3585205078125
  - id: all_tags_sorted_samfile
    outputSource:
      - samtools_view_2/output_sam
    type: File?
    'sbg:x': 746.5077514648438
    'sbg:y': 5.41741943359375
  - id: all_tags_sorted_bamfile
    outputSource:
      - rename_file_1/renamed_file
    type: File
    'sbg:x': 686.9691162109375
    'sbg:y': 205.5328826904297
  - id: no_tags_unsorted_cramfile
    outputSource:
      - samtools_view/output_cram
    type: File?
    'sbg:x': 811.3239135742188
    'sbg:y': -758.6043701171875
  - id: all_tags_sorted_cramfile
    outputSource:
      - samtools_view_3/output_cram
    type: File?
    'sbg:x': 782.0051879882812
    'sbg:y': -174.04258728027344
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
    'sbg:x': 594.0614624023438
    'sbg:y': -604.900146484375
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
    'sbg:x': 604.8489379882812
    'sbg:y': -460.71063232421875
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
  - id: samtools_view
    in:
      - id: input_alignment
        source: remove_sam_tags/no_tags_samfile
      - id: output_format
        default: CRAM
      - id: include_header
        default: true
      - id: threads
        source: threads
      - id: reference
        source: reference
      - id: rename_string
        default: unsorted_no_tags
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
    run: ../tools/samtools_view.cwl
    label: samtools view
    'sbg:x': 601.9833374023438
    'sbg:y': -743.3636474609375
  - id: samtools_view_3
    in:
      - id: input_alignment
        source: all_tags_sorted_bamfile
      - id: output_format
        default: CRAM
      - id: include_header
        default: true
      - id: threads
        source: threads
      - id: reference
        source: reference
      - id: rename_string
        default: sorted_all_tags
    out:
      - id: output_bam
      - id: output_sam
      - id: output_cram
    run: ../tools/samtools_view.cwl
    label: samtools view
    'sbg:x': 493.78912353515625
    'sbg:y': -168.17967224121094
requirements: []
