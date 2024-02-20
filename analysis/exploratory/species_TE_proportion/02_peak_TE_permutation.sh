cd /Users/rebecca/sudmant/analyses/myotis/analysis/exploratory/species_TE_proportion

field_names=($(awk -F"," 'NR>1{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#field_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker
peak_dir=/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes

n_perms=1000

# This script takes the consensus peaks for a given species, randomly assigns different positions to those peaks, then intersects them with TE annotations.
# (If the peak does not intersect with any features, the peak row is still maintained in the output.)
# We can use these results to calculate the probability of seeing a given proportion of peaks in TEs by chance.

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
  sort -k1,1 peaks.bed | grep -wFf <(printf "%s\n" "${chroms[@]}") > peaks_chrom_subset.bed
  # Remove simple repeats from TE annotations:
  grep -v "Simple_repeat" ${fa_dir}/${spec1}_TEs_chrom_subset.bed > TEs.bed
  # Intersect peaks with TEs:
  $bedtools2 intersect -wb -loj \
    -a peaks_chrom_subset.bed -b TEs.bed \
    > results/data/${spec1}_peaks_TEs.tsv
  for (( n=1; n<=$n_perms; n++ )); do
    # Shuffle positions of peaks:
    $bedtools2 shuffle \
      -i peaks_chrom_subset.bed \
      -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes \
      -seed $n -chrom > peaks_perm.bed
    # Intersect shuffled peaks with features
    $bedtools2 intersect -wb -loj \
      -a peaks_perm.bed -b TEs.bed \
      > results/data/permutations/${spec1}_TEs_permuted_peaks_${n}.tsv
    rm peaks_perm.bed
  done
  rm peaks*.bed TEs.bed
done