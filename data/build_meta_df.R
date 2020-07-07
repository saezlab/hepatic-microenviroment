library(tidyverse)
library(readxl)

df = read_excel("data/raw/Mapping_mRNASeq.xlsx", 
                col_names = c("sample", "xxx", "zzz", "row", "col", "id", 
                              "group"), skip = 3) %>%
  transmute(sample = str_remove(sample, "-S1"), group)

# human
meta_df = df %>%
  filter(str_detect(group, "human")) %>%
  separate(group, into = c("organism", "group"), sep = "_") %>%
  transmute(sample, group = factor(group, levels = c("control", "cirrhosis")))

saveRDS(meta_df, "data/meta_df.rds")
