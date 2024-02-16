cd /Users/rebecca/sudmant/analyses/myotis/analysis/exploratory/species_peaks

field_names=($(awk -F"," 'NR>1{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#field_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker
peak_dir=/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes

n_perms=1000

# This script takes all the features for a given species and intersects them with peaks; if the feature does not intersect any peaks, the feature row is still maintained in the output

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
  # Only chromosomes present in FASTA file can be present in peak file
  chroms=($(awk '{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes))
  sort -k1,1 peaks.bed | grep -wFf <(printf "%s\n" "${chroms[@]}") > peaks_subset.bed
  for (( n=0; n<$n_perms; n++ )); do
    # Shuffle order of peaks
    $bedtools2 shuffle -i peaks_subset.bed \
      -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes \
      -chrom > peaks_perm.bed
    # Intersect peaks with features
    $bedtools2 intersect -wb -loj -b peaks_perm.bed \
      -a ${fa_dir}/${spec1}_TEs_chrom_subset.bed \
        > results/data/permutations/${spec1}_TEs_permuted_peaks_${i}.tsv
    rm peaks*.bed
  done
done