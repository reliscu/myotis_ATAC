cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/contextualize_best_hits/resources

## Make genome file  with chromosome length per species:

abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))

for ea in ${abbr_names[@]}; do
  echo $ea
  faidx /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/${ea}1.cleaned.hapheader.fa \
    -i chromsizes | sed "s/SCAF/SUPER/" | sed "s/#0#/.0./" | sed "s/${ea}1.0.//g" > ${ea}_chromsizes
done

## Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/contextualize_best_hits/resources/peaks

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *peaks.tsv; do

  echo $ea

  spec1=$(echo $ea | sed 's/_vs.*//')
  spec2=$(echo $ea | sed 's/^.*_vs_//' | sed 's/_best_hits_peaks.tsv//')

  ## Get best hit genes into BED format:
  awk '{print $1, $4, $5, $3, $4, $5, $9}' OFS='\t' ../genes/${spec1}_vs_${spec2}_best_hits_genes.tsv > genes.bed

  ## Pad gene positions with 5000 bases
  $bedtools2 flank -i genes.bed -g  ../${spec1}_chromsizes -b 5000 > genes_padded.bed

  ## Get best hit peaks into BED format:
  awk '{print $1, $2, $3, $4}' OFS='\t' $ea > peaks.bed

  ## Intersect peaks and genes:
  $bedtools2 intersect -wb -a peaks.bed -b genes_padded.bed > $(echo $ea | sed 's/.tsv/_genes.tsv/')

  rm genes.bed genes_padded.bed peaks.bed

done

