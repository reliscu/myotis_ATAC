# Annotate peaks in reciprocal regions with nearby gene(s) and TEs:

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/01_RBHs/results/data

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

gtf_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/gff_final_curated/final_anno
fa_dir=/Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/repeatMasker

for ea in *peaks.tsv; do
  echo $ea
  spec1=$(echo $ea | sed 's/_vs.*//')
  # Subset GTF to gene biotype
  awk '$3 ~ /gene/' ${gtf_dir}/${spec1}_genes_5000l_padded.gff3 > genes.gff3
  # Intersect RBHs with features
  $bedtools2 intersect -loj -wb -a $ea -b genes.gff3 > $(echo $ea | sed 's/.tsv/_genes_5000l_padded.tsv/')
  $bedtools2 intersect -loj -wb -a $ea -b ${gtf_dir}/${spec1}_genes_exon1_5000l_padded.gff3 \
    > $(echo $ea | sed 's/.tsv/_genes_exon1_5000l_padded.tsv/')
  $bedtools2 intersect -loj -wb -a $ea -b ${fa_dir}/${spec1}_TEs_chrom_subset.bed \
    > $(echo $ea | sed 's/.tsv/_TEs.tsv/')
  rm genes.gff3
done
