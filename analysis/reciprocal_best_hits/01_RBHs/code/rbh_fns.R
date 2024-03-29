library(pafr)
library(dplyr)
library(tidyr)
library(GenomicRanges)

overlap_ranges = function(x, y) {
  rv = x
  start(rv) = max(start(x), start(y))
  end(rv) = min(end(x), end(y))
  return(rv)
  ## Ref: https://bioinformatics.stackexchange.com/questions/874/intersection-of-two-genomic-ranges-to-keep-metadata
}

spec_intersect_fn <- function(spec_subj_paf, spec_query_paf, spec.no) {
  
  ## Get intersection of species' positions when it is the query vs. the subject
  spec_subj_ranges <- makeGRangesFromDataFrame(spec_subj_paf, keep.extra.columns = TRUE)
  spec_query_ranges <- makeGRangesFromDataFrame(spec_query_paf, keep.extra.columns = TRUE)
  spec_intersect <- suppressWarnings(
    GenomicRanges::intersect(spec_subj_ranges, spec_query_ranges)
  )
  
  ## Overlap species' subject positions with the intersection, and replace ranges with max start and min end pos
  o <- findOverlaps(query = spec_subj_ranges, subject = spec_intersect)
  grl1 <- split(spec_subj_ranges[queryHits(o)], 1:length(o))
  grl2 <- split(spec_intersect[subjectHits(o)], 1:length(o))
  spec_interesct_subj <- unlist(mendoapply(overlap_ranges, grl1, y=grl2))

  ## Overlap species' query positions with the intersection, and replace ranges with max start and min end pos
  o <- findOverlaps(query = spec_query_ranges, subject = spec_intersect)
  grl1 <- split(spec_query_ranges[queryHits(o)], 1:length(o))
  grl2 <- split(spec_intersect[subjectHits(o)], 1:length(o))
  spec_interesct_query <- unlist(mendoapply(overlap_ranges, grl1, y=grl2))

  ## Make dataframe of results for subject and query ranges
  temp_query <- data.frame(Name = spec_interesct_query@elementMetadata$name, 
                           Chr = sapply(strsplit(spec_interesct_query@elementMetadata$name, " "), "[", 1), 
                           Start = spec_interesct_query@ranges@start, 
                           Width = spec_interesct_query@ranges@width)
  temp_subj <- data.frame(Name = spec_interesct_subj@elementMetadata$name, 
                          Chr = sapply(strsplit(spec_interesct_subj@elementMetadata$name, " "), "[", 1), 
                          Start = spec_interesct_subj@ranges@start, 
                          Width = spec_interesct_subj@ranges@width)
                                                                                                 
  temp_query$Chr <- sapply(strsplit(temp_query$Chr, ".", fixed = TRUE), function(x) x[length(x)])
  temp_subj$Chr <- sapply(strsplit(temp_subj$Chr, ".", fixed = TRUE), function(x) x[length(x)])       
                 
  ## Give each range a unique ID
  temp_query <- temp_query %>%
    dplyr::mutate(End = Start + Width-1) %>%
    dplyr::select(-Width) %>%
    dplyr::mutate(ID = paste(Chr, Start, End))
  temp_subj <- temp_subj %>%
    dplyr::mutate(End = Start + Width-1) %>%
    dplyr::select(-Width) %>%
    dplyr::mutate(ID = paste(Chr, Start, End))
    
  ## Take intersection of ranges: 
  temp_query <- temp_query[temp_query$ID %in% temp_subj$ID,]
  temp_subj <- temp_subj[match(temp_query$ID, temp_subj$ID),]
  spec_intersect <- cbind(temp_query$Name, temp_subj)
  colnames(spec_intersect)[1:2] <- c("Query_ID", "Subj_ID")
  colnames(spec_intersect) <- paste0("Spec", spec.no, "_", colnames(spec_intersect)) 
  
  return(spec_intersect)
  
}