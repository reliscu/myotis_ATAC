# Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/02_annotate_best_hits/resources/peaks

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for ea in *peaks.tsv; do

  echo $ea
  spec1=$(echo $ea | sed 's/_vs.*//')
  
  # Get best hit peaks into BED format
  awk '{print $1, $2, $3, $4}' OFS='\t' $ea | sort -k1,1 -k2,2n -k3,3n > peaks.bed
  
  # Pad gene annotations so that feature is extended 5000 bps upstream
  if [ ! -f ../gffs/${spec1}_padded.gff3 ]; then
    gff1="/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno/${spec1}1_finalAnnotation.gff3"
    sort -k1,1 -k4,4n -k5,5n $gff1 > ../gffs/${spec1}.gff3
    # Only chromosomes present in FASTA file can be present in GTF for this step
    chroms=($(awk '{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes))
    grep -wFf <(printf "%s\n" "${chroms[@]}") ../gffs/${spec1}.gff3 > ../gffs/${spec1}_chrom_subset.gff3
    $bedtools2 slop -i ../gffs/${spec1}_chrom_subset.gff3 -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -l 5000 -r 0 > ../gffs/${spec1}_5000l_padded.gff3
  fi
  
  # Pad TE annotations so that feature is extended 2000 bps upstream
  if [ ! -f ../beds/${spec1}_TEs_padded.bed ]; then
    # Only chromosomes present in FASTA file can be present in TE annotations for this step
    grep -wFf <(printf "%s\n" "${chroms[@]}") ../beds/${spec1}_TEs.bed > ../beds/${spec1}_TEs_chrom_subset.bed
    $bedtools2 slop -i ../beds/${spec1}_TEs_chrom_subset.bed -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -l 2000 -r 0 > ../beds/${spec1}_TEs_2000l_padded.bed 
  fi
  
  # Intersect peaks with features
  $bedtools2 intersect -wb -a peaks.bed -b ../gffs/${spec1}_padded.gff3 > $(echo $ea | sed 's/.tsv/_genes.tsv/')
  $bedtools2 intersect -wb -a peaks.bed -b ../beds/${spec1}_TEs_padded.bed > $(echo $ea | sed 's/.tsv/_TEs.tsv/')
  
  rm peaks.bed
  
done
