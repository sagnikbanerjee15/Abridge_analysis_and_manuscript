import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from plotnine import ggplot, aes, geom_point
from plotnine import *


all_info_filename  = "/Users/sagnik/work/ABRIDGE/Abridge_analysis_for_MS/all_info_prev.csv"

all_info = pd.read_csv(all_info_filename, index_col = 0)
all_info = all_info.T

# Convert to number
for col in all_info.columns:
    if col != "layout" and col != "rna_dna" and col != "sample_id":
        all_info[col] = pd.to_numeric(all_info[col])

all_info["num_reads"] = round(all_info["num_reads"]/1000000)
all_info["num_reads"] = all_info["num_reads"].astype("int")
all_info["num_reads"] = all_info["num_reads"].astype("str")

##########################################################################################
# CompressionRatioComparisonRNAMF
##########################################################################################

columns = list(all_info.columns)
columns_to_be_selected = [col for col in columns if "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores" in col]
columns_to_be_selected.extend(["num_reads",
                               "s_cram",
                               "s_compress_deez_lossy_0_mode_1",
                               "s_compress_samcomp",
                               "s_compress_genozip_optimize__compression_best",
                               "s_compress_csam_q_0_m_0"])

all_info_RNA_Seq_SE = all_info.loc [ (all_info['rna_dna'] == "RNA-Seq") & (all_info["layout"] == "SE")]
all_info_RNA_Seq_SE = all_info_RNA_Seq_SE[columns_to_be_selected]

all_info_RNA_Seq_SE = all_info_RNA_Seq_SE.rename(columns={
    "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_zpaq":"ABRIDGE_ZPAQ",
    "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_7z":"ABRIDGE_7Z",
    "s_compress_samcomp" : "SAMCOMP",
    "s_cram":"CRAM",
    "s_compress_abridge_save_all_quality_scores_save_exact_quality_scores_br":"ABRIDGE_BR",
                                    "s_compress_deez_lossy_0_mode_1":"DEEZ",
                                    "s_compress_genozip_optimize__compression_best" : "GENOZIP",
                                    "s_compress_csam_q_0_m_0" : "CSAM"
                                    
                                    })

print(all_info_RNA_Seq_SE)
all_info_RNA_Seq_SE = all_info_RNA_Seq_SE.melt(id_vars=['num_reads'])

x_axis_order = list(map(str,sorted(list(map(int,list(set(list(all_info_RNA_Seq_SE["num_reads"]))))))))

p = (ggplot(data = all_info_RNA_Seq_SE, mapping = aes( x = 'num_reads' , fill = 'variable' , y = 'value')) 
     + geom_bar(stat = "identity", position = position_dodge())
     + scale_fill_brewer(type="qual", palette="Dark2")
     + scale_x_discrete(limits =  x_axis_order)
     + geom_text(aes(label='value'), position=position_dodge(width = 0.8), size=5, angle = 90, ha = 'center', va = "baseline")
     )
ggsave(plot=p, filename='test.png', dpi=1000)

