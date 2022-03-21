# Outline

Date of conception of idea - January 15, 2021

## Data Analysis

###  **Summary of compression softwares**

Check Summary of Compression Softwares.xlsx in CyBox

 ###  **Other Important papers**

Review - Comparison of high-throughput sequencing data compression tools

CRAM - Efficient storage of high throughput dna sequencing data using reference-based compression, The scramble conversion tool

BAM - The sequence alignment/map format and samtools Check Data Compression Conference

### **Todo**

1. abcds



## Future enhancements

1. Record the maximum length of a read at the beginning. Select those alignments which are perfect (No splice, no mismatch, no-indels). Instead of storing the whole CIGAR, just store the character that represents the SAM format flag. For example, 150B~255~148-2 will become B~255~148-2. This will reduce space consumption to some extent.
2. For paired ended reads, think of a way to represent more SAM format flags.
3. Include multi-threading option within each compression
4. Incorporate suggestion from Dr. Dorman. Include sum of quality scores
5. Generating coverage

## Main Figures

### 1. WorkflowMF

Caption - This is the caption for this figure

About - Figure will have two panels. One describing compression the other panel describing decompression. Figure will be made in Microsoft power point

### **2. CompressionRatioComparisonRNAMF**

Only compression no decompression. Compare all the softwares and include BAM and CRAM as well.

Illustrate linear increase of compression size with increase in number of reads x-axis - Increasing size of input

### **3. TimeComparisonDecompressionMF**

Illustrate linear increase of time with increase in number of reads x-axis - Increasing size of input

y-axis - Compression time

4 panels - RNA, DNA, & Single-ended, Paired-ended

Include retrieval from bam file too. In the manuscript mention that retrieval from bam file works faster since it is not a very good form of compression.

## Main Tables

### **1. SummaryOfCompressionSoftwareMT**

Check Summary of Compression Softwares.xlsx in CyBox

## Supplementary Figures

### **1. IntegratedCIGARConstructionSF**

 A figure to depict how complicated icigars are constructed

### **2. CompressionTimeSF**

## Supplementary Tables

### **1. ListOfNCBI-SRASamplesForExperimentST**

 Select a mix of RNA-Seq, DNA-Seq, and other types of sequencing

### **2. ComparisonAmongCompressorsST**

Compare compression (and decompression) algorithms based on time, memory consumed, and compression ratio achieved. A comprehensive list of all durations, memory requirement for all analysis. Make this table first and then construct figures from this. Optional to include time for mapping the raw reads to reference

### **3. CompressionSoftwaresST**

Table to explain the compression softwares - 7z, zpaq and brotli. List their merits and demerits 

### **4. RandomRetrievalTimeST**

 Time to retrieve different regions one panel for RNA-Seq and another for DNA-Seq. 2 kinds of retrieval one with sequence and one without

### **5. IndexGenerationTimeST**

Time taken to generate abridge index vs boiler or bai csi cram etc.

### **6. ComparisonAmongDecompressorsST**

### **7. DifferentSettingsCompressionST **

