# Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/02_annotate_best_hits/resources/peaks

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

gtf_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno
fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker

for ea in *peaks.tsv; do

  echo $ea
  spec1=$(echo $ea | sed 's/_vs.*//')
  
  # Get best hit peaks into BED format
  awk '{print $1, $2, $3, $4}' OFS='\t' $ea | sort -k1,1 -k2,2n -k3,3n > peaks.bed
  
  # Intersect peaks with features
  $bedtools2 intersect -wb -a peaks.bed \
    -b ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 > $(echo $ea | sed 's/.tsv/_genes.tsv/')
  $bedtools2 intersect -wb -a peaks.bed \
    -b ${fa_dir}/${spec1}_TEs_2000l_padded.bed > $(echo $ea | sed 's/.tsv/_TEs.tsv/')
  
  rm peaks.bed
  
done
