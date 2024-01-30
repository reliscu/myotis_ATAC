cd /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated

# Make backup of unmodified GTF
cp mMyoThy1_finalAnnotation.gff3 mMyoThy1_finalAnnotation.gff3.backup

# Make beds for specific regions in SUPER__1 to be renamed as SUPER__2 and SUPER__17, respectively
echo SUPER__1 1 217270064 | sed 's/ /\t/g' > super2.bed
echo SUPER__1 217270265 273228803 | sed 's/ /\t/g' > super17.bed
bedtools intersect -wa -a mMyoThy1_finalAnnotation.gff3 -b super2.bed | awk -F"\t" '{gsub("SUPER__1", "SUPER__2", $1); print}' OFS='\t' > super2.gff3 
bedtools intersect -wa -a mMyoThy1_finalAnnotation.gff3 -b super17.bed | awk -F"\t" '{gsub("SUPER__1", "SUPER__17", $1); print}' OFS='\t' > super17.gff3 

# Remove rows with SUPER__1 from original GTF...
awk '$1 !~ /SUPER__1$/' mMyoThy1_finalAnnotation.gff3 > mMyoThy1_finalAnnotation_sans_super1.gff3
# ...and replace names out remaining chromosomes using mapping file
awk -F"\t" 'NR==FNR{key_pair[$1]=$2; next} {if ($1 in key_pair) $1=key_pair[$1]} 1' OFS='\t' ../../../mMyoThy_patch_mapping_rev.tsv mMyoThy1_finalAnnotation_sans_super1.gff3 > mMyoThy1_finalAnnotation_sans_super1_patched.gff3 

# Stitch together GTFs
cat mMyoThy1_finalAnnotation_sans_super1_patched.gff3 super2.gff3 super17.gff3 > mMyoThy1_finalAnnotation_patched.gff3 

# Make sure all chromosomes are present in patched file:
awk '!seen[$1]++' mMyoThy1_finalAnnotation_patched.gff3

cp mMyoThy1_finalAnnotation_patched.gff3 final_anno/mMyoThy1_finalAnnotation.gff3

