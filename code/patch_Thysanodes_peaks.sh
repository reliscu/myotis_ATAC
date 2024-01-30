cd /Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes/Myotis-Thysanodes

# Make backup of unmodified peak calls
cp Consensus_Peaks_Annotations_Accross_All_Samples.csv Consensus_Peaks_Annotations_Accross_All_Samples.csv.backup

# Get peak calls into compatible format:
awk -F"\t" '{temp=$1; for (i=2; i<=5; i++) {if (i<5) printf "%s\t", $i; if (i==5) printf "%s", temp} print ""}' Consensus_Peaks_Annotations_Accross_All_Samples.csv > Consensus_Peaks_Annotations_Accross_All_Samples.bed 

# Make beds for specific regions in SUPER__1 to be renamed as SUPER__2 and SUPER__17, respectively
echo SUPER__1 1 217270064 | sed 's/ /\t/g' > super2.bed
echo SUPER__1 217270265 273228803 | sed 's/ /\t/g' > super17.bed
bedtools intersect -wa -a Consensus_Peaks_Annotations_Accross_All_Samples.bed -b super2.bed | awk -F"\t" '{gsub("SUPER__1", "SUPER__2", $1); print}' > peaks_super2.bed 
bedtools intersect -wa -a Consensus_Peaks_Annotations_Accross_All_Samples.bed -b super17.bed | awk -F"\t" '{gsub("SUPER__1", "SUPER__17", $1); print}' > peaks_super17.bed 

# Remove rows with SUPER__1 from original original peak file:
awk -F"\t" '$1 !~ /SUPER__1$/' Consensus_Peaks_Annotations_Accross_All_Samples.bed > Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1.bed
# ...and swap out remaining chromosomes using mapping file
awk -F"\t" 'NR==FNR{key_pair[$1]=$2; next} {if ($1 in key_pair) $1=key_pair[$1]} 1' ../../../mMyoThy_patch_mapping_rev.tsv Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1.bed > Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1_patched.bed

# Stitch together GTFs
cat Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1_patched.bed peaks_super2.bed peaks_super17.bed > Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv

# Make sure all chromosomes are present in patched file:
awk '!seen[$1]++' Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv

# Repeat for TEs:

cd /Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/TEs/Myotis-Thysanodes

# Make backup of unmodified peak calls
cp Consensus_Peaks_Annotations_Accross_All_Samples.csv Consensus_Peaks_Annotations_Accross_All_Samples.csv.backup

# Get peak calls into compatible format:
awk -F"\t" '{temp=$1; for (i=2; i<=5; i++) {if (i<5) printf "%s\t", $i; if (i==5) printf "%s", temp} print ""}' Consensus_Peaks_Annotations_Accross_All_Samples.csv > Consensus_Peaks_Annotations_Accross_All_Samples.bed 

# Make beds for specific regions in SUPER__1 to be renamed as SUPER__2 and SUPER__17, respectively
echo SUPER__1 1 217270064 | sed 's/ /\t/g' > super2.bed
echo SUPER__1 217270265 273228803 | sed 's/ /\t/g' > super17.bed
bedtools intersect -wa -a Consensus_Peaks_Annotations_Accross_All_Samples.bed -b super2.bed | awk -F"\t" '{gsub("SUPER__1", "SUPER__2", $1); print}' > peaks_super2.bed 
bedtools intersect -wa -a Consensus_Peaks_Annotations_Accross_All_Samples.bed -b super17.bed | awk -F"\t" '{gsub("SUPER__1", "SUPER__17", $1); print}' > peaks_super17.bed 

# Remove rows with SUPER__1 from original original peak file:
awk -F"\t" '$1 !~ /SUPER__1$/' Consensus_Peaks_Annotations_Accross_All_Samples.bed > Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1.bed
# ...and swap out remaining chromosomes using mapping file
awk -F"\t" 'NR==FNR{key_pair[$1]=$2; next} {if ($1 in key_pair) $1=key_pair[$1]} 1' ../../../mMyoThy_patch_mapping_rev.tsv Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1.bed > Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1_patched.bed

# Stitch together GTFs
cat Consensus_Peaks_Annotations_Accross_All_Samples_sans_super1_patched.bed peaks_super2.bed peaks_super17.bed > Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv

# Make sure all chromosomes are present in patched file:
awk '!seen[$1]++' Consensus_Peaks_Annotations_Accross_All_Samples_patched.csv
