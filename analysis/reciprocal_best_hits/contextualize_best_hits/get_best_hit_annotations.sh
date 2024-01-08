cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/results

for ea in *csv; do

  spec1=$(awk -F"," 'NR==2{print $1}' $ea | sed "s/1.*$//g")
  spec2=$(awk -F"," 'NR==2{print $6}' $ea | sed "s/1.*$//g")
  awk -F"," 'NR>1{print $1, $3, $4}' $ea > ${spec1}_${spec1}_vs_${spec2}.bed
  awk -F"," 'NR>1{print $6, $8, $9}' $ea > ${spec2}_${spec1}_vs_${spec2}.bed

done

## Use intersect BEDs with annotation files:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/results
bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *bed; do

  spec1=$(echo $ea | sed "s/_.*$//g")
  spec2=$(echo $ea | cut -c 9- | sed "s/_vs_.*$//g")
  gff="/Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/gff_final_curated/${spec1}1_finalAnnotation.gff3"
  $bedtools2 intersect -wb -a $gff -b $ea > ${spec1}_${spec1}_vs_${spec2}_gene_annotations.csv

done
