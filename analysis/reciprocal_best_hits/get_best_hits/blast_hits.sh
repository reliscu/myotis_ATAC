## Make reference DB

for ea in *fa; do
   makeblastdb -in /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
    -parse_seqids \
    -dbtype nucl \
    -out mMyoCai
done

## Make query sequence (BED -> FASTA):

dat <- fread("/Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/results/mMyoAui_vs_mMyoCai_reciprocal_best_hits.csv", data.table = FALSE)
dat <- dat[1, c(1, 3:4)]
write.table(dat, file = "mMyoAui_mMyoAui_vs_mMyoCai_hits.bed", sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits

$bedtools2 getfasta \
  -fi /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -bed /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/mMyoAui_mMyoAui_vs_mMyoCai_hits.bed > mMyoAui_seq.fasta

## Blast query against reference:

cd /Users/rebecca/blastdb

blastn \
  -query /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/mMyoAui_seq.fasta \
  -db mMyoCai \
  -out mMyoAui_vs_mMyoCai.txt \
  -num_threads 4

####################

blastn \
  -query /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -subject /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
  -query_loc 231190000-234005000 \
  -outfmt 6 \
  -out mMyoAui_query_vs_mMyoCai_subject.txt 

blastn \
  -query /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -subject /Users/rebecca/sudmant/data/myotis/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
  -subject_loc 40112-2853759 \
  -outfmt 6 \
  -out mMyoAui_query_vs_mMyoCai_subject.txt 