cd /Users/rebecca/sudmant/analyses/myotis/analysis/exploratory/species_peaks

field_names=($(awk -F"," 'NR>1{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#field_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

gtf_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno
fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker
peak_dir=/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes

## This script takes all the features for a given species and intersects them with peaks; if the feature does not intersect any peaks, the feature row is still maintained in the output

for (( i=0; i<$len; i++ )); do
  spec1=${abbr_names[$i]}
  echo $spec1
  # Get consensus peaks for working species into BED format
  peaks="${peak_dir}/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples.csv"
  if [ $(echo ${field_names[$i]} | grep -c "Thy") -gt 0  ]; then
    peaks="${peak_dir}/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv"
    awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print $1, $2, $3, $5}' OFS='\t' $peaks > peaks.bed
  else 
    awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print $2, $3, $4, $1}' OFS='\t' $peaks > peaks.bed
  fi
  # Intersect peaks with features
  $bedtools2 intersect -wb -loj -b peaks.bed \
    -a ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 > results/data/${spec1}_genes_5000l_padded_peaks.tsv
  $bedtools2 intersect -wb -loj -b peaks.bed \
    -a ${gtf_dir}/${spec1}_genes_exon1_5000l_padded.gff3 > results/data/${spec1}_genes_exon1_5000l_padded_peaks.tsv
  $bedtools2 intersect -wb -loj -b peaks.bed \
    -a ${fa_dir}/${spec1}_TEs_chrom_subset.bed > results/data/${spec1}_TEs_peaks.tsv
  rm peaks.bed
done