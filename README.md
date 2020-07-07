## Gut microbiota fuels HCC development by shaping the hepatic inflammatory microenvironment

### Abstract
Hepatocellular carcinoma (HCC) is a leading cause of cancer-related deaths worldwide and therapeutic options for advanced HCC are limited. Here, we discovered that intestinal dysbiosis affects antitumor immune surveillance and drives liver disease progression towards cancer. Dysbiotic microbiota as seen in Nlrp6-/- mice induced a Toll-like receptor 4 dependent expansion of hepatic monocytic myeloid-derived suppressor cells (mMDSC) and suppression of T-cell abundance. This phenotype was transmissible via fecal microbiota transfer and reversible upon microbiota depletion, pointing to the high plasticity of the tumor microenvironment. While loss of Akkermansia muciniphila correlated with mMDSC abundance, its transfer restored intestinal barrier function and strongly reduced steatohepatitis activity. Cirrhosis patients displayed increased hepatic tissue microbiota, which induced pronounced transcriptional changes including activation of fibro-inflammatory pathways as well as circuits mediating cancer immunosuppression. This study demonstrates that gut microbiota closely shape the hepatic inflammatory microenvironment defining new approaches for cancer prevention and therapy. 

*** 

### Content
This repository deals exclusively with the analysis of the **human** RNA-seq data (Cirrhosis cohort). The mouse models mentioned in the abstract were analyzed elsewhere. 

More information of the

* `data` folder [here](https://github.com/saezlab/hepatic-microenviroment/tree/master/data).
* `output` folder [here](https://github.com/saezlab/hepatic-microenviroment/tree/master/output).

***

### Analyses and scripts

* Basic analysis of patient cohort (normalization, clustering, differential gene expression analysis) available [here](https://github.com/saezlab/hepatic-microenviroment/blob/master/analyses/transcriptome_analysis.Rmd#L40).

* Functional analyses (pathway/transcription factor analysis) available [here](https://github.com/saezlab/hepatic-microenviroment/blob/master/analyses/transcriptome_analysis.Rmd#L148).

* Microbiata analysis (correlation analysis with 16s rRNA) available [here](https://github.com/saezlab/hepatic-microenviroment/blob/master/analyses/transcriptome_analysis.Rmd#L715).

* Celltype deconvolution available [here](https://github.com/saezlab/hepatic-microenviroment/blob/master/analyses/transcriptome_analysis.Rmd#L968).

***

### Misc
In case you are interested in reproduing the results you can install easily all required packages with the workflow from the [`renv`](https://rstudio.github.io/renv/index.html) package. This ensures also that the correct version of the required packages is installed.

First clone the repository and then run the following command in an R session:
```
# install all required packages using the renv package
renv::restore()
```

***

### How to cite?
> Schneider KM, Mohs A, Gui W, Galvez EJC, Candels LS, Holland CH, Elfers C, Kilic K, Schneider CV, Strnad P, Wirtz TH, Marschall HU, Latz E, Lelouvier B, Saez-Rodriguez J, de Vos W, Strowig T, Trebicka J and Trautwein C. "Gut microbiota fuels HCC development by shaping the hepatic inflammatory microenvironment." _In preparation_. 2020.
