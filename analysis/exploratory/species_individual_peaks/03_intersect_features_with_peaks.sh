cd /Users/rebecca/sudmant/analyses/myotis/analysis/exploratory/species_individual_peaks/results/data

abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#abbr_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

gtf_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno
fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker

for (( i=0; i<$len; i++ )); do
  spec1=${abbr_names[$i]}
  echo $spec1
  for ea in ${spec1}*peaks.tsv; do
    # Intersect features with peaks
    $bedtools2 intersect -wb -loj -b $ea \
      -a ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 > $(echo $ea | sed 's/peaks.tsv/genes_5000l_padded_peaks.tsv/')
    $bedtools2 intersect -wb -loj -b $ea \
      -a ${gtf_dir}/${spec1}_genes_exon1_5000l_padded.gff3 > $(echo $ea | sed 's/peaks.tsv/genes_exon1_5000l_padded_peaks.tsv/')
    $bedtools2 intersect -wb -loj -b $ea \
      -a ${fa_dir}/${spec1}_TEs_chrom_subset.bed > $(echo $ea | sed 's/peaks.tsv/TEs_peaks.tsv/')
  done
done