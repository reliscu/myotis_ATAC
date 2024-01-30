
## Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/contextualize_best_hits/resources/genes/peaks

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *peaks.tsv; do
  echo $ea
  spec1=$(echo $ea | sed 's/_vs.*//')
  spec2=$(echo $ea | sed 's/^.*_vs_//' | sed 's/_best_hits_peaks.tsv//')
  ## Get best hit genes into BED format:
  awk '{print $1, $4, $5, $3, $4, $5, $9}' OFS='\t' ../${spec1}_vs_${spec2}_best_hits_genes.tsv > genes.bed
  ## Pad gene positions with 5000 bases
  $bedtools2 flank -i genes.bed -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -b 5000 > genes_padded.bed
  ## Get best hit peaks into BED format:
  awk '{print $1, $2, $3, $4}' OFS='\t' $ea > peaks.bed
  ## Intersect peaks and genes:
  $bedtools2 intersect -wb -a peaks.bed -b genes_padded.bed > $(echo $ea | sed 's/.tsv/_genes.tsv/')
  rm genes.bed genes_padded.bed peaks.bed
done
