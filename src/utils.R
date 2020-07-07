do_pca = function(df, meta=NULL, top_n_var_genes = NULL) {
  
  if (!is.null(top_n_var_genes)) {
    top_var_genes = base::apply(df, 1, var) %>% 
      sort() %>%
      tail(top_n_var_genes) %>%
      names()
    
    df = df[top_var_genes, , drop=F]
    
  }
  pca_obj = prcomp(t(df), center = T, scale.=T)
  
  coords = pca_obj$x %>%
    data.frame(check.names = F, stringsAsFactors = F) %>%
    rownames_to_column("sample") %>%
    as_tibble()
  
  if (!is.null(meta)) {
    coords = left_join(coords, meta, by="sample")
  }
  
  var = round(summary(pca_obj)$importance[2,] * 100, 2)
  
  res = list()
  res$coords = coords
  res$var = var
  
  return(res)
}



#' This function performs differential gene expression analysis via the limma
#'   workflow.
#' 
#' @param expr expression matrix with genes in rows and samples in columns.
#' @param design design matrix. For more information see 
#'   \code{\link[limma:lmFit]{lmFit}}.
#' @param contrasts contrasts. For more information see 
#'   \code{\link[limma:contrasts.fit]{contrasts.fit}}. If NULL no contrasts are 
#'   computed
#'   
#' @return limma result in table format. Contains the columns \code{gene, 
#'   (contrast), logFC, statistic, pval, fdr}.
run_limma = function(expr, design, contrasts = NULL, ...) {
  if (!is.null(contrasts)) {
    limma_result = lmFit(expr, design) %>%
      contrasts.fit(contrasts) %>%
      eBayes() %>%
      tidy() %>%
      select(gene, contrast = term, logFC = estimate, statistic = statistic, 
             pval = p.value) %>%
      group_by(contrast) %>%
      mutate(fdr = p.adjust(pval, method = "BH")) %>%
      ungroup()
  } else if (is.null(contrasts)) {
    limma_result = lmFit(expr, design) %>%
      eBayes() %>%
      topTableF(n = Inf) %>%
      rownames_to_column("gene") %>%
      as_tibble()
    }
  
  return(limma_result)
}

#' Classification/Assignment of differential expressed genes
#' 
#' This function classifies genes as deregulated based on effect size and 
#'   adjusted p-value. A gene is considered as differential expressed if the 
#'   adjusted p-value is below AND if the absolute effect size is above user 
#'   specified cutoffs.
#' 
#' @param df A table that must contain at least the columns \code{gene}, 
#'   \code{fdr} and \code{logFC}. The table must not include a column named 
#'   \code{regulation}.
#' @param fdr_cutoff numeric value that denotes the adjusted p-value cutoff. 
#' @param effect_size_cutoff numeric value that denotes the effect size cutoff.
#' 
#' @return The input table with an additional colum names \code{regulation}. A 
#'   gene can be upregulated (up), downregulated (down) or not significantly 
#'   regulated (ns).
assign_deg = function(df, fdr_cutoff = 0.05, effect_size_cutoff = 1, 
                      fdr_id = fdr, effect_size_id = logFC) {
  
  degs = df %>%
    mutate(regulation = case_when(
      {{effect_size_id}} >= effect_size_cutoff & {{fdr_id}} <= fdr_cutoff ~ "up",
      {{effect_size_id}} <= -effect_size_cutoff & {{fdr_id}} <= fdr_cutoff ~ "down",
      TRUE ~ "ns")
    ) %>%
    mutate(regulation = factor(regulation, levels = c("up", "down", "ns")))
  
  return(degs)
}

#' Tidy a matrix
#'
#' This utility function takes a matrix and converts it to a tidy format and
#' adds if available observations' meta data.
#'
#' @param mat A matrix with observations/features in rows and variables in
#' columns
#' @param feature Class name of observations/features, e.g.
#' transcription_factors
#' @param key Class name of variables, e.g. samples
#' @param value Class name of matrix values, e.g. activities
#' @param meta Data frame with meta data of the observations. To map the meta
#' data to the tidied table the observation/feature column name must be
#' identical.
#'
#' @return Tidy table.
#'
#' @export
tdy = function(mat, feature, key, value, meta = NULL) {
  res = mat %>%
    data.frame(check.names = F, stringsAsFactors = F) %>%
    rownames_to_column(feature) %>%
    as_tibble() %>%
    gather({{key}}, {{value}}, -{{feature}})
  
  if (!is.null(meta)) {
    res = res %>%
      left_join(meta, by=key)
  }
  
  return(res)
}

#' Untidy a tibble
#'
#' This utility function takes a tidy tibble and converts it to a matrix.
#'
#' @param tbl A tidy tibble
#' @param feature Class name of observations/features present in tidy tibble
#' @param key Class name of key present in tidy tibble
#' @param value Class name of values in tidy tibble
#'
#' @return Matrix with observation in rows and variables in columns.
#'
#' @export
untdy = function(tbl, feature, key, value, fill=NA) {
  tbl %>%
    select({{feature}}, {{key}}, {{value}}) %>%
    spread({{key}}, {{value}}, fill=fill) %>%
    data.frame(row.names = 1, check.names = F, stringsAsFactors = F)
}
