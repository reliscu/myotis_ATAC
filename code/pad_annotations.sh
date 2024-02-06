abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
len=${#field_names[@]}

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

gtf_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno
fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker
  
# Pad gene annotations so that feature is extended 5000 bps upstream

for (( i=0; i<$len; i++ )); do
  spec1=${abbr_names[$i]}
  if [ ! -f ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 ]; then
    gtf1="${gtf_dir}/${spec1}1_finalAnnotation.gff3"
    # Only chromosomes present in FASTA file can be present in gene annotations
    chroms=($(awk '{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes))
    sort -k1,1 -k4,4n -k5,5n $gtf1 | grep -wFf <(printf "%s\n" "${chroms[@]}") >
        ${gtf_dir}/${spec1}_genes_chrom_subset.gff3
    # Pad annotations
    $bedtools2 slop -i ${gtf_dir}/${spec1}_genes_chrom_subset.gff3 \
      -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes -l 5000 \
      -r 0 > ${gtf_dir}/${spec1}_genes_5000l_padded.gff3
  fi
done

# Pad gene annotations upstream N bps only UP TO the first exon to be specific about the status of promoter regions

nbps=5000

for (( i=0; i<$len; i++ )); do
  spec1=${abbr_names[$i]}
  # Subset GTF to rows for exon 1 of each feature, ...
  # put the start position into the end position column, ...
  # then subtract N bps from start position
  awk -v nbps=$nbps'$NF ~ "exon1;" {print}' ${gtf_dir}/${spec1}1_finalAnnotation.gff3 |
    sort -k1,1 -k4,4n | 
    awk '{ $5 = $4; $4 = ($4 - nbps < 0) ? 0 : $4 - nbps; print }' OFS='\t' >
    ${gtf_dir}/${spec1}_genes_exon1_${nbps}l_padded.gff3 
done
   
# Pad TE annotations so that feature is extended 2000 bps upstream
  
for (( i=0; i<$len; i++ )); do
  spec1=${abbr_names[$i]}
  fa1="${fa_dir}/${spec1}1_delim.sorted.fas.out"
  # Get TEs into BED format
  awk -F" " 'NR>1{gsub("SCAF", "SUPER", $5); print $5, $6, $7, $1, $2, $10, $11}' OFS='\t' $fa1 >
    ${fa_dir}/${spec1}_TEs.bed
  # Only chromosomes present in FASTA file can be present in TE annotations
  chroms=($(awk '{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes))
  grep -wFf <(printf "%s\n" "${chroms[@]}") ${fa_dir}/${spec1}_TEs.bed >
    ${fa_dir}/${spec1}_TEs_chrom_subset.bed
  # Pad annotations
  $bedtools2 slop -i ${fa_dir}/${spec1}_TEs_chrom_subset.bed \
    -g /Users/rebecca/sudmant/analyses/myotis/data/${spec1}_chromsizes \
    -l 2000 -r 0 > ${fa_dir}/${spec1}_TEs_2000l_padded.bed 
done