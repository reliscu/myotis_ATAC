cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/01_get_best_hits/results

# Get genes and TEs associated with reciprocal best hits:

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *csv; do
  echo $ea
  spec1=$(awk -F"," 'NR==2{print $1}' $ea | sed "s/1.*$//g")
  # Get reciprocal sequences for each species into BED format
  awk -v pattern="${spec1}1.0." -F"," 'NR>1{gsub(pattern, "", $1); print $1, $3, $4}' OFS='\t' $ea > spec1.bed
  # Cross ref. reciprocal sequences with genes:
  gff1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno/${spec1}1_finalAnnotation.gff3"
  if [ $(head $gff1 | grep -c SCAF) -gt 0 ]; then 
    sed -i.backup "s/SCAF/SUPER/g" $gff1
  fi
  $bedtools2 intersect -wb -a $gff1 -b spec1.bed > ../../02_annotate_best_hits/resources/best_hits/$(echo $ea | sed 's/.csv/_genes.tsv/')
  # Cross ref. reciprocal sequences with TEs:
  anno1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker/${spec1}1_delim.sorted.fas.out"
  # Get TEs into BED format
  if [ ! -f ../../02_annotate_best_hits/resources/beds/${spec1}_TEs.bed ]; then
    awk -F" " 'NR>1{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $10, $11}' OFS='\t' $anno1 > ../../02_annotate_best_hits/resources/beds/${spec1}_TEs.bed
  fi
  $bedtools2 intersect -wb -a ../../02_annotate_best_hits/resources/beds/${spec1}_TEs.bed -b spec1.bed > ../../02_annotate_best_hits/resources/best_hits/$(echo $ea | sed 's/.csv/_TEs.tsv/')
  rm spec1.bed 
done