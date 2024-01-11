cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/results

field_names=($(awk -F"," 'NR>1{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#field_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for (( i=0; i<$len; i++ )); do
  echo ${field_names[$i]}
  ## Get consensus peaks for working species:
  peaks="/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples.csv"
  ## Get into BED format:
  awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print $2, $3, $4, $1, $5, $6, $7, $8, $9, $10, $11, $12, $(NF-2), $(NF-1), $NF}' OFS='\t' $peaks > peaks.bed
  for hits in ${abbr_names[$i]}*; do
    ## Get reciprocal sequences into BED format:
    awk -v pattern="${abbr_names[$i]}1.0." -F"," 'NR>1{gsub(pattern, "", $1); print $1, $3, $4}' OFS='\t' $hits > hits.bed
    ## Intersect peaks with reciprocal regions:
    $bedtools2 intersect -wb -a peaks.bed -b hits.bed > \
      ../../contextualize_best_hits/resources/$(echo $hits | sed 's/.csv/_peaks/').tsv
    rm hits.bed
  done
 rm peaks.bed
done

