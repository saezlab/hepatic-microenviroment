library(biomaRt)
library(tidyverse)

# download gene lengths for human gene symbols

# listEnsemblArchives()
# used version/host = "http://apr2020.archive.ensembl.org" 

human_ensembl = useMart("ensembl", dataset = "hsapiens_gene_ensembl")

biomart_output = getBM(attributes = c("hgnc_symbol","transcript_length"), 
                       mart = human_ensembl)

tidy_biomart_output = biomart_output %>%
  as_tibble() %>%
  na_if("") %>%
  drop_na() %>%
  group_by(hgnc_symbol) %>%
  summarise(transcript_length = round(median(transcript_length)))

saveRDS(tidy_biomart_output,
        "data/annotation/gene_id/gene_length.rds")
