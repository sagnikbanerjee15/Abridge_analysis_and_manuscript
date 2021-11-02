library(ggpattern)
library(ggplot2)
library(readxl)
library(ggsci)
library(gridExtra)
library(ggpubr)
library(dplyr)
library(stringr)
library(scales)
library(fmsb)
library(pivottabler)
library(ggiraph)
library(plyr)
library(reshape2)
library(moonBook)
library(sjmisc)
library(ggiraphExtra)
library(devtools)
library(wesanderson)
library(shadowtext)
library(jcolors)
library(patternplot)
library(ggtextures)
library(grid)
library(magick)
library(MASS)   
library("ggpubr")
library(nortest)
data("ToothGrowth")


axis_label_font_size=10
axis_text_font_size=9
legend_text_size=8
all_info_filename = "/Users/sagnik/work/ABRIDGE/Abridge_analysis_for_MS/all_info_prev.csv"
all_info <- as.data.frame(read.csv(all_info_filename,sep=",", header = TRUE, stringsAsFactors=FALSE))
rownames(all_info) <- all_info$X
all_info$X <- NULL
all_info <- as.data.frame(t(all_info))
all_info$num_reads <- round(as.numeric(all_info$num_reads) / 1000000)

#####################################################################################################
# CompressionRatioComparisonRNAMF
#####################################################################################################

all_info_RNA_Seq_SE <- all_info[all_info$rna_dna == "RNA-Seq" & all_info$layout == "SE", ]
all_info_RNA_Seq_SE$num_reads <- as.numeric(all_info_RNA_Seq_SE$num_reads)
order(all_info_RNA_Seq_SE$num_reads)
all_info_RNA_Seq_SE <- cbind(all_info_RNA_Seq_SE[, c("num_reads", "s_cram", "s_compress_deez_lossy_0_mode_1",
                                                     "s_compress_samcomp",
                                                     "s_compress_genozip_optimize__compression_best",
                                                     "s_compress_csam_q_0_m_0")],
              all_info_RNA_Seq_SE[, grep(pattern="^s_compress_abridge_save_all_quality_scores_save_exact_quality_scores",colnames(all_info_RNA_Seq_SE)) ])

setnames(all_info_RNA_Seq_SE, "s_compress_csam_q_0_m_0", "CSAM")
setnames(all_info_RNA_Seq_SE, "s_cram", "CRAM")
setnames(all_info_RNA_Seq_SE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_br", "ABRIDGE_BR")
setnames(all_info_RNA_Seq_SE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_7z", "ABRIDGE_7z")
setnames(all_info_RNA_Seq_SE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_zpaq", "ABRIDGE_ZPAQ")
setnames(all_info_RNA_Seq_SE, "s_compress_deez_lossy_0_mode_1", "DEEZ")
setnames(all_info_RNA_Seq_SE, "s_compress_samcomp", "SAMCOMP")
setnames(all_info_RNA_Seq_SE, "s_compress_genozip_optimize__compression_best", "GENOZIP")


all_info_RNA_Seq_SE <- data.frame(lapply(all_info_RNA_Seq_SE,as.numeric))
all_info_RNA_Seq_SE <- melt(data = all_info_RNA_Seq_SE, id.vars = 'num_reads' )
all_info_RNA_Seq_SE$variable<-factor(all_info_RNA_Seq_SE$variable,levels = c("CRAM", "CSAM",  "ABRIDGE_ZPAQ","SAMCOMP","ABRIDGE_7z","GENOZIP","ABRIDGE_BR","DEEZ"))

p_a<-ggplot(data = all_info_RNA_Seq_SE, aes( x = factor(num_reads) , fill = variable , y = value, na.rm = F)) + 
  geom_bar(position="dodge", stat="identity", color="black")+
  geom_text(aes(label=value), position = position_dodge(width=0.9), hjust = -0.3, vjust = 0.5, size=4, fontface="bold", angle = 90) +
  scale_x_discrete(labels  =  as.factor(all_info_RNA_Seq_SE$num_reads)) +
  scale_y_continuous(limits=c(min(all_info_RNA_Seq_SE$value)-1,max(all_info_RNA_Seq_SE$value)+1500),oob = rescale_none) +
  geom_vline(xintercept = 1.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 2.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 3.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 4.5, linetype="dashed", color = "black")+
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size=legend_text_size,color="black"),
        legend.box.background = element_rect(colour = "black", size = 1), 
        axis.title.y = element_text(size=axis_label_font_size, colour = "black", face = "bold"),
        axis.title.x = element_text( size=axis_label_font_size, colour = "black" , face = "bold"),
        axis.text.x = element_text(size=axis_text_font_size, colour = "black"),
        axis.text.y = element_text(size=axis_text_font_size, colour = "black", margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2)
  )+
  labs(title="RNA-Seq Single Paired",x="Number of reads (in Millions)", y = "Size in MB") + 
  scale_fill_igv()


#####################################################################################################
all_info_RNA_Seq_PE <- all_info[all_info$rna_dna == "RNA-Seq" & all_info$layout == "PE", ]
all_info_RNA_Seq_PE$num_reads <- as.numeric(all_info_RNA_Seq_PE$num_reads)
order(all_info_RNA_Seq_PE$num_reads)
all_info_RNA_Seq_PE <- cbind(all_info_RNA_Seq_PE[, c("num_reads", "s_cram", "s_compress_deez_lossy_0_mode_1",
                                                     "s_compress_samcomp",
                                                     "s_compress_genozip_optimize__compression_best",
                                                     "s_compress_csam_q_0_m_0")],
                             all_info_RNA_Seq_PE[, grep(pattern="^s_compress_abridge_save_all_quality_scores_save_exact_quality_scores",colnames(all_info_RNA_Seq_PE)) ])

setnames(all_info_RNA_Seq_PE, "s_compress_csam_q_0_m_0", "CSAM")
setnames(all_info_RNA_Seq_PE, "s_cram", "CRAM")
setnames(all_info_RNA_Seq_PE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_br", "ABRIDGE_BR")
setnames(all_info_RNA_Seq_PE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_7z", "ABRIDGE_7z")
setnames(all_info_RNA_Seq_PE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_zpaq", "ABRIDGE_ZPAQ")
setnames(all_info_RNA_Seq_PE, "s_compress_deez_lossy_0_mode_1", "DEEZ")
setnames(all_info_RNA_Seq_PE, "s_compress_samcomp", "SAMCOMP")
setnames(all_info_RNA_Seq_PE, "s_compress_genozip_optimize__compression_best", "GENOZIP")


all_info_RNA_Seq_PE <- data.frame(lapply(all_info_RNA_Seq_PE,as.numeric))
all_info_RNA_Seq_PE <- melt(data = all_info_RNA_Seq_PE, id.vars = 'num_reads' )
all_info_RNA_Seq_PE$variable<-factor(all_info_RNA_Seq_PE$variable,levels = c("CRAM", "CSAM",  "ABRIDGE_ZPAQ","SAMCOMP","ABRIDGE_7z","GENOZIP","ABRIDGE_BR","DEEZ"))

p_b<-ggplot(data = all_info_RNA_Seq_PE, aes( x = factor(num_reads) , fill = variable , y = value, na.rm = F)) + 
  geom_bar(position="dodge", stat="identity", color="black")+
  geom_text(aes(label=value), position = position_dodge(width=0.9), hjust = -0.3, vjust = 0.5, size=4, fontface="bold", angle = 90) +
  scale_x_discrete(labels  =  as.factor(all_info_RNA_Seq_PE$num_reads)) +
  scale_y_continuous(limits=c(min(all_info_RNA_Seq_PE$value)-1,max(all_info_RNA_Seq_PE$value)+1500),oob = rescale_none) +
  geom_vline(xintercept = 1.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 2.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 3.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 4.5, linetype="dashed", color = "black")+
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size=legend_text_size,color="black"),
        legend.box.background = element_rect(colour = "black", size = 1), 
        axis.title.y = element_text(size=axis_label_font_size, colour = "black", face = "bold"),
        axis.title.x = element_text( size=axis_label_font_size, colour = "black" , face = "bold"),
        axis.text.x = element_text(size=axis_text_font_size, colour = "black"),
        axis.text.y = element_text(size=axis_text_font_size, colour = "black", margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2)
  )+
  labs(title="RNA-Seq Paired Ended",x="Number of reads (in Millions)", y = "Size in MB") + 
  scale_fill_igv()


#####################################################################################################






all_info_DNA_Seq_SE <- all_info[all_info$rna_dna == "DNA-Seq" & all_info$layout == "SE", ]
all_info_DNA_Seq_SE$num_reads <- as.numeric(all_info_DNA_Seq_SE$num_reads)
order(all_info_DNA_Seq_SE$num_reads)
all_info_DNA_Seq_SE <- cbind(all_info_DNA_Seq_SE[, c("num_reads", "s_cram", "s_compress_deez_lossy_0_mode_1",
                                                     "s_compress_samcomp",
                                                     "s_compress_genozip_optimize__compression_best",
                                                     "s_compress_csam_q_0_m_0")],
                             all_info_DNA_Seq_SE[, grep(pattern="^s_compress_abridge_save_all_quality_scores_save_exact_quality_scores",colnames(all_info_DNA_Seq_SE)) ])

setnames(all_info_DNA_Seq_SE, "s_compress_csam_q_0_m_0", "CSAM")
setnames(all_info_DNA_Seq_SE, "s_cram", "CRAM")
setnames(all_info_DNA_Seq_SE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_br", "ABRIDGE_BR")
setnames(all_info_DNA_Seq_SE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_7z", "ABRIDGE_7z")
setnames(all_info_DNA_Seq_SE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_zpaq", "ABRIDGE_ZPAQ")
setnames(all_info_DNA_Seq_SE, "s_compress_deez_lossy_0_mode_1", "DEEZ")
setnames(all_info_DNA_Seq_SE, "s_compress_samcomp", "SAMCOMP")
setnames(all_info_DNA_Seq_SE, "s_compress_genozip_optimize__compression_best", "GENOZIP")


all_info_DNA_Seq_SE <- data.frame(lapply(all_info_DNA_Seq_SE,as.numeric))
all_info_DNA_Seq_SE <- melt(data = all_info_DNA_Seq_SE, id.vars = 'num_reads' )
all_info_DNA_Seq_SE$variable<-factor(all_info_DNA_Seq_SE$variable,levels = c("CRAM", "CSAM",  "ABRIDGE_ZPAQ","SAMCOMP","ABRIDGE_7z","GENOZIP","ABRIDGE_BR","DEEZ"))

p_c<-ggplot(data = all_info_DNA_Seq_SE, aes( x = factor(num_reads) , fill = variable , y = value, na.rm = F)) + 
  geom_bar(position="dodge", stat="identity", color="black")+
  geom_text(aes(label=value), position = position_dodge(width=0.9), hjust = -0.3, vjust = 0.5, size=4, fontface="bold", angle = 90) +
  scale_x_discrete(labels  =  as.factor(all_info_DNA_Seq_SE$num_reads)) +
  scale_y_continuous(limits=c(min(all_info_DNA_Seq_SE$value)-1,max(all_info_DNA_Seq_SE$value)+1500),oob = rescale_none) +
  geom_vline(xintercept = 1.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 2.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 3.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 4.5, linetype="dashed", color = "black")+
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size=legend_text_size,color="black"),
        legend.box.background = element_rect(colour = "black", size = 1), 
        axis.title.y = element_text(size=axis_label_font_size, colour = "black", face = "bold"),
        axis.title.x = element_text( size=axis_label_font_size, colour = "black" , face = "bold"),
        axis.text.x = element_text(size=axis_text_font_size, colour = "black"),
        axis.text.y = element_text(size=axis_text_font_size, colour = "black", margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2)
  )+
  labs(title="DNA-Seq Single Ended",x="Number of reads (in Millions)", y = "Size in MB") + 
  scale_fill_igv()


#####################################################################################################
all_info_DNA_Seq_PE <- all_info[all_info$rna_dna == "DNA-Seq" & all_info$layout == "PE", ]
all_info_DNA_Seq_PE$num_reads <- as.numeric(all_info_DNA_Seq_PE$num_reads)
order(all_info_DNA_Seq_PE$num_reads)
all_info_DNA_Seq_PE <- cbind(all_info_DNA_Seq_PE[, c("num_reads", "s_cram", "s_compress_deez_lossy_0_mode_1",
                                                     "s_compress_samcomp",
                                                     "s_compress_genozip_optimize__compression_best",
                                                     "s_compress_csam_q_0_m_0")],
                             all_info_DNA_Seq_PE[, grep(pattern="^s_compress_abridge_save_all_quality_scores_save_exact_quality_scores",colnames(all_info_DNA_Seq_PE)) ])

setnames(all_info_DNA_Seq_PE, "s_compress_csam_q_0_m_0", "CSAM")
setnames(all_info_DNA_Seq_PE, "s_cram", "CRAM")
setnames(all_info_DNA_Seq_PE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_br", "ABRIDGE_BR")
setnames(all_info_DNA_Seq_PE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_7z", "ABRIDGE_7z")
setnames(all_info_DNA_Seq_PE, "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_zpaq", "ABRIDGE_ZPAQ")
setnames(all_info_DNA_Seq_PE, "s_compress_deez_lossy_0_mode_1", "DEEZ")
setnames(all_info_DNA_Seq_PE, "s_compress_samcomp", "SAMCOMP")
setnames(all_info_DNA_Seq_PE, "s_compress_genozip_optimize__compression_best", "GENOZIP")


all_info_DNA_Seq_PE <- data.frame(lapply(all_info_DNA_Seq_PE,as.numeric))
all_info_DNA_Seq_PE <- melt(data = all_info_DNA_Seq_PE, id.vars = 'num_reads' )
all_info_DNA_Seq_PE$variable<-factor(all_info_DNA_Seq_PE$variable,levels = c("CRAM", "CSAM",  "ABRIDGE_ZPAQ","SAMCOMP","ABRIDGE_7z","GENOZIP","ABRIDGE_BR","DEEZ"))

p_d<-ggplot(data = all_info_DNA_Seq_PE, aes( x = factor(num_reads) , fill = variable , y = value, na.rm = F)) + 
  geom_bar(position="dodge", stat="identity", color="black")+
  geom_text(aes(label=value), position = position_dodge(width=0.9), hjust = -0.3, vjust = 0.5, size=4, fontface="bold", angle = 90) +
  scale_x_discrete(labels  =  as.factor(all_info_DNA_Seq_PE$num_reads)) +
  scale_y_continuous(limits=c(min(all_info_DNA_Seq_PE$value)-1,max(all_info_DNA_Seq_PE$value)+1500),oob = rescale_none) +
  geom_vline(xintercept = 1.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 2.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 3.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 4.5, linetype="dashed", color = "black")+
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size=legend_text_size,color="black"),
        legend.box.background = element_rect(colour = "black", size = 1), 
        axis.title.y = element_text(size=axis_label_font_size, colour = "black", face = "bold"),
        axis.title.x = element_text( size=axis_label_font_size, colour = "black" , face = "bold"),
        axis.text.x = element_text(size=axis_text_font_size, colour = "black"),
        axis.text.y = element_text(size=axis_text_font_size, colour = "black", margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2)
  )+
  labs(title="DNA-Seq Paired Ended",x="Number of reads (in Millions)", y = "Size in MB") + 
  scale_fill_igv()


#####################################################################################################

margin_for_no_space<-c(0.2,0.5,0,0)
ggarrange(p_a+theme(plot.margin=unit(margin_for_no_space, "cm")),
          p_b+theme(plot.margin=unit(margin_for_no_space, "cm")),
          p_c+theme(plot.margin=unit(margin_for_no_space, "cm")),
          p_d+theme(plot.margin=unit(margin_for_no_space, "cm")),
          labels = c("(A)","(B)","(C)","(D)"),
          ncol = 2, nrow = 2,
          legend = "none")

ggsave(paste0("/Users/sagnik/work/ABRIDGE/Manuscript/Figures/CompressionRatioComparisonMF.pdf"),
       plot = last_plot(), 
       dpi = 1000,
       height = 7,
       width = 15)
















all_info_RNA_Seq_SE <- all_info[all_info$rna_dna == "RNA-Seq" & all_info$layout == "SE", ]
all_info_RNA_Seq_SE$num_reads <- as.numeric(all_info_RNA_Seq_SE$num_reads)
order(all_info_RNA_Seq_SE$num_reads)
all_info_RNA_Seq_SE <- cbind(all_info_RNA_Seq_SE[, c("num_reads", "t_cram", "t_decompress_deez_lossy_0_mode_1",
                                                     "t_decompress_samcomp",
                                                     "t_decompress_genozip_optimize__compression_best",
                                                     "t_decompress_csam_q_0_m_0")],
                             all_info_RNA_Seq_SE[, grep(pattern="^t_decompress_abridge_save_all_quality_scores_save_exact_quality_scores",colnames(all_info_RNA_Seq_SE)) ])

setnames(all_info_RNA_Seq_SE, "t_decompress_csam_q_0_m_0", "CSAM")
setnames(all_info_RNA_Seq_SE, "t_cram", "CRAM")
setnames(all_info_RNA_Seq_SE, "t_decompress_abridge_save_all_quality_scores_save_exact_quality_scores_br", "ABRIDGE_BR")
setnames(all_info_RNA_Seq_SE, "t_decompress_abridge_save_all_quality_scores_save_exact_quality_scores_7z", "ABRIDGE_7z")
setnames(all_info_RNA_Seq_SE, "t_decompress_abridge_save_all_quality_scores_save_exact_quality_scores_zpaq", "ABRIDGE_ZPAQ")
setnames(all_info_RNA_Seq_SE, "t_decompress_deez_lossy_0_mode_1", "DEEZ")
setnames(all_info_RNA_Seq_SE, "t_decompress_samcomp", "SAMCOMP")
setnames(all_info_RNA_Seq_SE, "t_decompress_genozip_optimize__compression_best", "GENOZIP")


all_info_RNA_Seq_SE <- data.frame(lapply(all_info_RNA_Seq_SE,as.numeric))
all_info_RNA_Seq_SE <- melt(data = all_info_RNA_Seq_SE, id.vars = 'num_reads' )
all_info_RNA_Seq_SE$variable<-factor(all_info_RNA_Seq_SE$variable,levels = c("CRAM", "CSAM",  "ABRIDGE_ZPAQ","SAMCOMP","ABRIDGE_7z","GENOZIP","ABRIDGE_BR","DEEZ"))

p_a<-ggplot(data = all_info_RNA_Seq_SE, aes( x = factor(num_reads) , fill = variable , y = value, na.rm = F)) + 
  geom_bar(position="dodge", stat="identity", color="black")+
  geom_text(aes(label=value), position = position_dodge(width=0.9), hjust = -0.3, vjust = 0.5, size=4, fontface="bold", angle = 90) +
  scale_x_discrete(labels  =  as.factor(all_info_RNA_Seq_SE$num_reads)) +
  scale_y_continuous(limits=c(min(all_info_RNA_Seq_SE$value)-1,max(all_info_RNA_Seq_SE$value)+1500),oob = rescale_none) +
  geom_vline(xintercept = 1.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 2.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 3.5, linetype="dashed", color = "black")+
  geom_vline(xintercept = 4.5, linetype="dashed", color = "black")+
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        legend.text = element_text(size=legend_text_size,color="black"),
        legend.box.background = element_rect(colour = "black", size = 1), 
        axis.title.y = element_text(size=axis_label_font_size, colour = "black"),
        axis.title.x = element_text( size=axis_label_font_size, colour = "black"),
        axis.text.x = element_text(size=axis_text_font_size, colour = "black"),
        axis.text.y = element_text(size=axis_text_font_size, colour = "black", margin = margin(t = 0, r = 0, b = 0, l = 0)),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2)
  )+
  labs(title="RNA-Seq Single Paired",x="Number of reads (in Millions)", y = "Size in MB") + 
  scale_fill_igv()
p_a

