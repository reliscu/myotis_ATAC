# cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/02_UCRs/results/data

# # Here we subset to peaks to reciprocal best hit regions (unannotated):

# field_names=($(awk -F"," 'NR>1{print $1}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
# abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))
# len=${#field_names[@]}

# bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

# peak_dir=/Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes

# for (( i=0; i<$len; i++ )); do
#   echo ${field_names[$i]}
#   # Get consensus peaks for working species:
#   peaks="${peak_dir}/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples.csv"
#   if [ $(echo ${field_names[$i]} | grep -c "Thy") -gt 0  ]; then
#     peaks="${peak_dir}/${field_names[$i]}/Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv"
#     awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print $1, $2, $3, $5}' OFS='\t' $peaks > peaks.bed
#   else 
#     awk -F"\t" 'NR>1{gsub("SCAF", "SUPER", $2); print $2, $3, $4, $1}' OFS='\t' $peaks > peaks.bed
#   fi
#   for ucrs in ${abbr_names[$i]}*bed; do
#     # Intersect peaks with ultra conserved regions:
#     $bedtools2 intersect -wb -a $ucrs -b peaks.bed > $(echo $ucrs | sed 's/.bed/_peaks.tsv/')
#   done
#   rm peaks.bed
# done
