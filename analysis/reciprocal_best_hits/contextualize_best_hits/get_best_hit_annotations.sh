cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/results

## Get genes and TEs associated with reciprocal best hits:

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *csv; do

  spec1=$(awk -F"," 'NR==2{print $1}' $ea | sed "s/1.*$//g")
  spec2=$(awk -F"," 'NR==2{print $6}' $ea | sed "s/1.*$//g")
  echo ${spec1} vs. ${spec2}

  ## Get reciprocal sequences for each species into BED format:
  awk -v pattern="${spec1}1.0." -F"," 'NR>1{gsub(pattern, "", $1); print $1, $3, $4}' OFS='\t' $ea > spec1.bed
  awk -v pattern="${spec2}1.0." -F"," 'NR>1{gsub(pattern, "", $6); print $6, $8, $9}' OFS='\t' $ea > spec2.bed

  ## Cross ref. reciprocal sequences with genes:
  
  gff1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/${spec1}1_finalAnnotation.gff3"
  gff2="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/${spec2}1_finalAnnotation.gff3"

  if [ $(head $gff1 | grep -c SCAF) -gt 0 ]; then echo sed -i  "s/SCAF/SUPER/g" $gff1; fi
  if [ $(head $gff2 | grep -c SCAF) -gt 0 ]; then echo sed -i "s/SCAF/SUPER/g" $gff2; fi

  $bedtools2 intersect -wb -a $gff1 -b spec1.bed > ../../contextualize_best_hits/results/${spec1}_${spec1}_vs_${spec2}_best_hits_gene_annotations.csv
  $bedtools2 intersect -wb -a $gff2 -b spec2.bed > ../../contextualize_best_hits/results/${spec2}_${spec1}_vs_${spec2}_best_hits_gene_annotations.csv 
  
  ## Cross ref. reciprocal sequences with TEs: 

  anno1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker/${spec1}1_sorted.fas.out"
  anno2="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker/${spec2}1_sorted.fas.out"

  ## Get TE annotations into BED format:
  if [ ! -f ../../contextualize_best_hits/resources/${spec1}_TEs.bed ]; then
    awk 'NR>3{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $9, $11}' OFS='\t' $anno1 > \
      ../../contextualize_best_hits/resources/${spec1}_TEs.bed
  fi
  if [ ! -f ../../contextualize_best_hits/resources/${spec2}_TEs.bed ]; then
    awk 'NR>3{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $9, $11}' OFS='\t' $anno2 > \
      ../../contextualize_best_hits/resources/${spec2}_TEs.bed
  fi

  $bedtools2 intersect -wb -a ../../contextualize_best_hits/resources/${spec1}_TEs.bed -b spec1.bed > \
    ../../contextualize_best_hits/results/${spec1}_${spec1}_vs_${spec2}_best_hits_TE_annotations.csv
  $bedtools2 intersect -wb -a ../../contextualize_best_hits/resources/${spec2}_TEs.bed -b spec2.bed > \ 
    ../../contextualize_best_hits/results/${spec2}_${spec1}_vs_${spec2}_best_hits_TE_annotations.csv

  rm spec1.bed spec2.bed

done