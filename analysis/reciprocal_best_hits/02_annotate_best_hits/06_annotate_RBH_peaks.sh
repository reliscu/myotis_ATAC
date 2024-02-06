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
  
  # Get consensus peaks for working species into BED format
  peaks="/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples.csv"
  if [ $(echo ${field_names[$i]} | grep -c "Thy") -gt 0  ]; then
    peaks="/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv"
    awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print}' OFS='\t' $peaks > peaks.bed
  else 
    # Get peaks into BED format:
    awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print $2, $3, $4, $1}' OFS='\t' $peaks > peaks.bed
  fi
  
  # Pad gene annotations so that feature is extended 5000 bps upstream
  
  if [ ! -f ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 ]; then
    # Only chromosomes present in FASTA file can be present in gene annotations for this step
    if [ -f ${gtf_dir}/${spec1}_genes_chrom_subset.gff3 ]; then
      gtf1="${gtf_dir}/${spec1}1_finalAnnotation.gff3"
      chroms=($(awk '{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes))
      sort -k1,1 -k4,4n -k5,5n $gtf1 | grep -wFf <(printf "%s\n" "${chroms[@]}") > ${gtf_dir}/${spec1}_genes_chrom_subset.gff3
    fi
    $bedtools2 slop -i ${gtf_dir}/${spec1}_genes_chrom_subset.gff3 \
      -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -l 5000 -r 0 > ${gtf_dir}/${spec1}_genes_5000l_padded.gff3
  fi
  
  # Pad TE annotations so that feature is extended 2000 bps upstream
  
  if [ ! -f ${fa_dir}/${spec1}_TEs_2000l_padded.bed ]; then
    if [ ! -f ${fa_dir}/${spec1}_TEs_chrom_subset.bed ]; then
      if [! -f ${fa_dir}/${spec1}_TEs.bed ]; then
        fa1="${fa_dir}/${spec1}1_delim.sorted.fas.out"
        awk -F" " 'NR>1{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $10, $11}' OFS='\t' $fa1 > ${fa_dir}/${spec1}_TEs.bed
      fi
      chroms=($(awk '{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes))
      # Only chromosomes present in FASTA file can be present in TE annotations for this step
      grep -wFf <(printf "%s\n" "${chroms[@]}") ${fa_dir}/${spec1}_TEs.bed > ${fa_dir}/${spec1}_TEs_chrom_subset.bed
    fi
    $bedtools2 slop -i ${fa_dir}/${spec1}_TEs_chrom_subset.bed \
      -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -l 2000 -r 0 > ${fa_dir}/${spec1}_TEs_2000l_padded.bed 
  fi
  
  # Make annotation file encompassing only up to the first exon per feature to be specific about the status of promoter regions:
  
  # Intersect peaks with features
  $bedtools2 intersect -wb -a peaks.bed -b ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 > $(echo $ea | sed 's/.tsv/_genes.tsv/')
  $bedtools2 intersect -wb -a peaks.bed -b ${fa_dir}/${spec1}_TEs_2000l_padded.bed > $(echo $ea | sed 's/.tsv/_TEs.tsv/')
  
  rm peaks.bed
  
done
