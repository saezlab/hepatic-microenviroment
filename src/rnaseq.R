preprocess_count_matrix = function(count_matrix) {
  
  # removes genes with contant expression across all samples (including genes with 0 counts)
  keep = apply(count_matrix, 1, var) != 0
  
  res = log2(count_matrix[keep,] + 1)
  
  message("Discarding ", sum(!keep), " genes \nKeeping ", sum(keep), " genes")
  
  return(res)
}

voom_normalization = function(count_matrix) {

  # filter low read counts, TMM normalization and logCPM transformation
  keep = filterByExpr(count_matrix)

  norm = count_matrix[keep,,keep.lib.sizes=F] %>%
    calcNormFactors() %>%
    voom() %>%
    pluck("E")
  
  message("Discarding ", sum(!keep), " genes \nKeeping ", sum(keep), " genes")
  
  return(norm)
}

counts_to_tpm = function(count_matrix) {
  gene_length_df = readRDS("data/annotation/gene_id/gene_length.rds") %>%
    rename(gene = hgnc_symbol)
  
  res = count_matrix %>%
    rownames_to_column("gene") %>%
    pivot_longer(cols = -gene, names_to = "sample", values_to = "count") %>%
    inner_join(gene_length_df, by="gene") %>%
    # divide by gene lengths in kb
    mutate(tmp = count / (transcript_length/1000)) %>%
    group_by(sample) %>%
    mutate(lib_size = sum(tmp)) %>%
    ungroup() %>%
    # divide by library size and one million
    mutate(tpm = tmp / (lib_size/1e6)) %>%
    dplyr::select(gene, sample, tpm) %>%
    pivot_wider(names_from = sample, values_from = tpm) %>%
    data.frame(row.names = 1, check.names = F)
  
  stopifnot(colnames(res) == colnames(count_matrix))
  
  return(res)
}
