library(tidyverse)
library(readxl)
library(janitor)

numeric_features = c("af_pngml", "albumingl", "alkalische_phosphatase", 
                     "bilirubinmgdl", "calciummmoll", "che_ul", "crp", 
                     "erythrozyten", "gesamt_cholesterinmgdl", 
                     "gesamteiweissgl", "got_ul", "gpt_ul", "hamatokrit", 
                     "hamoglobin", "inr", "kaliummmoll", "kreatininmgdl", 
                     "leukozyten_gl", "meldscore", "natriummmoll",
                     "thrombozyten_gl", "triglyceridemgdl", "γ_gt_ul")

categorical_features = c("aszites", "atiogruppen", "child_score", 
                         "childscore_punktzahl", "hepatische_enzephalopathie",
                         "hepatorenalsyndrome", "lci_athiologie", "odeme", 
                         "osophagusvarizen", "spontaneousbacterialperitontis", 
                         "varizenblutungen")

clinical_data = read_excel(
  "data/raw/ClinicalCohortData_CirrhosisPatients.xlsx", 
  sheet = "Tabelle1") %>%
  rename(feature = Samplename) %>%
  gather(id, value, -feature) %>%
  spread(feature, value) %>%
  clean_names() %>%
  mutate_at(vars(matches(str_c(numeric_features, collapse = "|"))), 
            as.numeric) %>%
  mutate_at(vars(matches(str_c(categorical_features, collapse = "|"))),
            as_factor) %>%
  mutate_if(is.factor, fct_inseq) %>%
  mutate(g_gt_ul = as.numeric(g_gt_ul))

saveRDS(clinical_data, "data/clinical_data.rds")
     
