## Make reference DB

for ea in *fa; do
   makeblastdb -in /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
    -parse_seqids \
    -dbtype nucl \
    -out mMyoCai
done

## Make query sequence (BED -> FASTA):

dat <- fread("results/mMyoAui_vs_mMyoCai_reciprocal_best_hits.csv", data.table = FALSE)
dat <- dat[1, c(1, 3:4)]
write.table(dat, file = "mMyoAui_vs_mMyoCai_hits.bed", sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/

$bedtools2 getfasta \
  -fi /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -bed /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/mMyoAui_vs_mMyoCai_hits.bed > mMyoAui_seq.fasta

cd /Users/rebecca/blastdb

blastn -query /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/mMyoAui_seq.fasta \
  -db mMyoCai \
  -out mMyoAui_vs_mMyoCai.txt \
  -num_threads 4