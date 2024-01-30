
## Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/contextualize_best_hits/resources

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *peaks.tsv; do

  echo $ea
  spec1=$(echo $ea | sed 's/_vs.*//')

  # Get best hit peaks into BED format
  awk '{print $1, $2, $3, $4}' OFS='\t' $ea > peaks.bed
  ## Sort peaks

  # Sort GTFs

  # Fix gene annotation chromosome names, if necessary
  
  gff1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno/${spec1}1_finalAnnotation.gff3"
  if [ grep -c "Thy" $spec1 ]; then
    sort -k1,1 $gff1 > gffs/${gff1}_sorted
  else
    cat $gff1 > gffs${gff1}_sorted
  fi

   # Get TEs into BED format, if necessary
  anno1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker/${spec1}1_sorted.fas.out"
  if [ ! -f resources/beds/${spec1}${spec1}_TEs.bed ]; then
    awk 'NR>3{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $9, $11}' OFS='\t' $anno1 > resources/beds/${spec1}_TEs.bed
  fi

  # Get feature(s) closest to each peak
  $bedtools2 closest -s -D b -fu -a peaks.bed -b $gff1 > peaks/$(echo $ea | sed 's/.tsv/_genes.tsv/')
  $bedtools2 closest -s -D b -fu -a peaks.bed -b resources/beds/${spec1}_TEs.bed > peaks/$(echo $ea | sed 's/.tsv/_TEs.tsv/')

  rm genes_padded.bed peaks.bed
  
done

