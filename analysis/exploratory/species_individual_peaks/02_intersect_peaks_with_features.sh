cd /Users/rebecca/sudmant/analyses/myotis/analysis/exploratory/species_individual_peaks

abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#abbr_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

gtf_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno
fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker

## This script takes all the peaks from a given species and intersects them with species features; if the peak does not intersect any features, the peak row is still maintained in the output

for (( i=0; i<$len; i++ )); do
  spec1=${abbr_names[$i]}
  echo $spec1
  for ea in results/data/${spec1}*peaks.tsv; do
    # Intersect peaks with features
    $bedtools2 intersect -wb -loj -a $ea \
      -b ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 > $(echo $ea | sed 's/.tsv/_genes_5000l_padded.tsv/')
    $bedtools2 intersect -wb -loj -a $ea \
      -b ${gtf_dir}/${spec1}_genes_exon1_5000l_padded.gff3 > $(echo $ea | sed 's/.tsv/_genes_exon1_5000l_padded.tsv/')
    $bedtools2 intersect -wb -loj -a $ea \
      -b ${fa_dir}/${spec1}_TEs_chrom_subset.bed > $(echo $ea | sed 's/.tsv/_TEs.tsv/')
  done
done