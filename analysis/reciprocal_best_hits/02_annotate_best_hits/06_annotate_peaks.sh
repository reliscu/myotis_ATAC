
## Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/02_annotate_best_hits/resources/peaks

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in peaks/*peaks.tsv; do
  echo $ea
  spec1=$(echo $ea | sed 's/_vs.*//')
  ## Get best hit peaks into BED format:
  awk '{print $1, $2, $3, $4}' OFS='\t' $ea | sort -k1,1 -k2,2n -k3,3n > peaks.bed
  # Pad annotations so that feature is extended upstream:
  gff1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno/${spec1}1_finalAnnotation.gff3"
  sort -k1,1 -k4,4n -k5,5n $gff1 > ../gffs/${spec1}.gff3
  $bedtools2 slop -i ../gffs/${spec1}.gff3 -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -l 100 -r 0 > ../gffs/${spec1}_padded.gff3
  ## Intersect peaks and genes:
  $bedtools2 intersect -wb -a peaks.bed -b ../gffs/${spec1}_padded.gff3 > $(echo $ea | sed 's/.tsv/_genes.tsv/')
  # Intersect peaks and TEs:
  $bedtools2 intersect -wb -a peaks.bed -b ../beds/${spec1}_TEs.bed > $(echo $ea | sed 's/.tsv/_TEs.tsv/')
  rm peaks.bed
done

  # Get TEs into BED format, if necessary
  # anno1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker/${spec1}1_sorted.fas.out"
  # Get TEs into BED format, if necessary
  # if [ ! -f resources/beds/${spec1}_TEs.bed ]; then
  #   awk 'NR>3{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $9, $11}' OFS='\t' $anno1 > resources/beds/${spec1}_TEs.bed
  # fi
  
  
  SUPER__1	EVM	gene	81926	82381	.	+	.	ID=evm.TU.SUPER__2.7;Name=EVM prediction SUPER__2.7
  SUPER__1	EVM	gene	76926	81925	.	+	.	ID=evm.TU.SUPER__2.7;Name=EVM prediction SUPER__2.7
