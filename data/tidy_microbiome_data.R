library(tidyverse)
library(readxl)
library(janitor)

rdna = read_excel("data/raw/SampleOverview+16s_rDNA.xlsx") %>%
  clean_names() %>%
  select(id = sample, sample = sample_id, group, rdna = x16s_r_dna_ng_dna) %>%
  mutate(group = str_remove(group, "human_"),
         group = factor(group, levels = c("control", "cirrhosis")))

saveRDS(rdna, "data/rdna.rds")

# bacteria on family level
bac_family = read_excel(
  "data/raw/microbiome_taxanomy_family.xlsx"
  ) %>%
  rename(id = Sample, group = Group) %>%
  mutate(group = str_remove(group, "healthy_"),
         group = factor(group, levels = c("control", "cirrhosis"))) %>%
  clean_names()

# bacteria on order level
bac_order = read_excel(
  "data/raw/microbiome_taxanomy_order.xlsx"
) %>%
  rename(id = Sample, group = Group) %>%
  mutate(group = str_remove(group, "healthy_"),
         group = factor(group, levels = c("control", "cirrhosis"))) %>%
  clean_names()

bac = list(family = bac_family, order = bac_order)

saveRDS(bac, "data/bacteria.rds")

