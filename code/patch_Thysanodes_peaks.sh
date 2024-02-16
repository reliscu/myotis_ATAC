cd /Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes/Myotis-Thysanodes

# Make backup of unmodified peak calls
cp Consensus_Peaks_Annotations_Accross_All_Samples.csv Consensus_Peaks_Annotations_Accross_All_Samples.csv.backup
# Get peak calls into compatible format:
awk -F"\t" '{temp=$1; for (i=2; i<=6; i++) {if (i<6) printf "%s\t", $i; if (i==6) printf "%s", temp} print ""}' \
  OFS='\t' Consensus_Peaks_Annotations_Accross_All_Samples.csv > Consensus_Peaks_Annotations_Accross_All_Samples.bed 
# Make beds for specific regions in SUPER__1 to be renamed as SUPER__2 and SUPER__17, respectively
echo SUPER__1 1 217270064 | sed 's/ /\t/g' > super2.bed
echo SUPER__1 217270265 273228803 | sed 's/ /\t/g' > super17.bed
bedtools intersect -wa -a Consensus_Peaks_Annotations_Accross_All_Samples.bed -b super2.bed |
  awk -F"\t" '{gsub("SUPER__1", "SUPER__2", $1); print}' OFS='\t'  > peaks_super2.bed 
bedtools intersect -wa -a Consensus_Peaks_Annotations_Accross_All_Samples.bed -b super17.bed | 
  awk -F"\t" '{gsub("SUPER__1", "SUPER__17", $1); print}' OFS='\t' > peaks_super17.bed 
# Remove rows with SUPER__1 from original original peak file:
awk -F"\t" '$1 !~ /SUPER__1$/' Consensus_Peaks_Annotations_Accross_All_Samples.bed OFS='\t' \
  > Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1.bed
# ...and swap out remaining chromosomes using mapping file
awk -F"\t" 'NR==FNR{key_pair[$1]=$2; next} {if ($1 in key_pair) $1=key_pair[$1]} 1' OFS='\t' \
  ../../../mMyoThy_patch_mapping_rev.tsv Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1.bed \
  > Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1_patched.bed
# Stitch together GTFs
cat Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1_patched.bed peaks_super2.bed peaks_super17.bed \
  > Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv
# Make sure all chromosomes are present in patched file:
awk '!seen[$1]++' Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv

# Also patching sample-level peak calls:
cd /Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes/Myotis-Thysanodes
# Make backup of unmodified peak calls
cp All.individual.samples.peak.annotation.txt All.individual.samples.peak.annotation.txt.backup
# Get peak calls into compatible format:
awk -F"\t" '{print $3, $4, $5, $6, $1, $2}' OFS='\t' All.individual.samples.peak.annotation.txt > All.individual.samples.peak.annotation.bed
# Make beds for specific regions in SUPER__1 to be renamed as SUPER__2 and SUPER__17, respectively
echo SUPER__1 1 217270064 | sed 's/ /\t/g' > super2.bed
echo SUPER__1 217270265 273228803 | sed 's/ /\t/g' > super17.bed
bedtools intersect -wa -a All.individual.samples.peak.annotation.bed -b super2.bed |
  awk -F"\t" '{gsub("SUPER__1", "SUPER__2", $1); print}' OFS='\t'  > peaks_super2.bed 
bedtools intersect -wa -a All.individual.samples.peak.annotation.bed -b super17.bed | 
  awk -F"\t" '{gsub("SUPER__1", "SUPER__17", $1); print}' OFS='\t' > peaks_super17.bed 
# Remove rows with SUPER__1 from original original peak file:
awk -F"\t" '$1 !~ /SUPER__1$/' All.individual.samples.peak.annotation.bed OFS='\t' \
  > All.individual.samples.peak.annotation_sans_super1.bed
# ...and swap out remaining chromosomes using mapping file
awk -F"\t" 'NR==FNR{key_pair[$1]=$2; next} {if ($1 in key_pair) $1=key_pair[$1]} 1' OFS='\t' \
  ../../../mMyoThy_patch_mapping_rev.tsv All.individual.samples.peak.annotation_sans_super1.bed \
  > All.individual.samples.peak.annotation_sans_super1_patched.bed
# Stitch together GTFs
cat All.individual.samples.peak.annotation_sans_super1_patched.bed \
  peaks_super2.bed \
  peaks_super17.bed \
  > All.individual.samples.peak.annotation_patched.tsv
# Make sure all chromosomes are present in patched file:
awk '!seen[$1]++' All.individual.samples.peak.annotation_patched.tsv