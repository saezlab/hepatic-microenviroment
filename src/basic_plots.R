library(lemon)
library(cowplot)
library(ggpubr)
library(gridExtra)
library(AachenColorPalette) # devtools::install_github("christianholland/AachenColorPalette")
library(VennDiagram)
library(UpSetR)
library(ComplexHeatmap)
library(circlize)
library(ggrepel)
library(scales)

plot_pca = function(pca_result, x = "PC1", y = "PC2", feature = NULL) {
  if (!is.null(feature)) {
    
    if (!(feature %in% colnames(pca_result$coords))) {
      stop(feature, " is not a valid feature")
    }
    
    p = pca_result$coords %>%
      ggplot(aes(x=.data[[as.character(x)]], 
                 y=.data[[as.character(y)]], 
                 color=.data[[as.character(feature)]]))
    
  } else if (is.null(feature)) {
    p = pca_result$coords %>%
      ggplot(aes(x=.data[[as.character(x)]], 
                 y=.data[[as.character(y)]]))
  }
  p + 
    geom_point(size=2) +
    labs(x = paste0(x, " (", pca_result$var[parse_number(x)], "%)"),
         y = paste0(y, " (", pca_result$var[parse_number(y)], "%)"),
         color = feature)
}
  

#' This function plots volcano plot(s)
#' 
#' A volcano plot it plotted for each contrast. In case that multiple contrasts
#'   are provided each contrast will be an individual facet.
#' 
#' @param df A data frame that stores the output of a differential gene 
#'   expression analysis (e.g. via \code{\link{limma}}). This data frame must 
#'   contain the columns \code{logFC, contrast, regulation} and one of 
#'   \code{pval, p, p-value, p.value}. The column \code{regulation} should be a 
#'   factor contaiing three levels reflecting up-, down and non signifiant 
#'   regulation. The column \code{contrast} should contain an identifier for 
#'   this contrrast. It is possible to have multiple contrast within the data 
#'   frame. All other columns will be ignored.
#' @param ... further parameters of \code{facet_wrap()} function, e.g.
#'   \code{scales="free"} 
#'   
#' @return ggplot object of volcano plots
plot_volcano = function(df, ...) {
  df %>%
    rename(p = any_of(c("pval", "p", "p-value", "p.value"))) %>%
    ggplot(aes(x=logFC, y=-log10(p), color=regulation, alpha = regulation)) +
    geom_point() +
    facet_rep_wrap(~contrast, ...) +
    labs(x="logFC", y=expression(-log['10']*"(p-value)")) +
    scale_color_manual(values = aachen_color(c("green", "blue", "black50")), 
                       drop = F) +
    scale_alpha_manual(values = c(0.7,0.7,0.2), guide ="none", drop=F)
}


#' This function plots p-value histogram(s)
#'
#' @param A data frame that must contain at least a column with p-values. The 
#'   column must be named either: \code{pval, p, p-value, p.value}. If there 
#'   exist different groups (e.g. in case of GSEA on different contrast each 
#'   contrast is a group) their identifier should be stored in an additional 
#'   column with variable column name. All other columns will be ignored
#' @param facet_var Quoted string of the column name that stores the group 
#'   information. A p-value histogram will be plotted for each group. In case
#'   of multiple groups also a vector of quoted strings can be provided.
#' @param ... further parameters of \code{facet_wrap()} function, e.g. 
#'   \code{scales="free"}
#' 
#' @return ggplot object of p-value histograms
plot_phist = function(df, facet_var = NULL, ...) {
  p_synonyms = c("pval", "p", "p-value", "p.value", "p_val", "P.Value")
  
  p = df %>%
    rename(p = any_of(p_synonyms)) %>%
    ggplot(aes(x=p)) +
    geom_histogram(color = "white", bins = 21, boundary = 0) +
    labs(x="p-value", y="Count") +
    scale_x_continuous(limits = c(0,1.0001), labels = label_percent())
  
  if (!is.null(facet_var)) {
    if (length(facet_var) > 1) {
      facet_var = str_c(facet_var, collapse = "+")
    }
    p = p + 
      facet_rep_wrap(as.formula(str_c("~", facet_var)), ...)
    }
   return(p) 
  }
