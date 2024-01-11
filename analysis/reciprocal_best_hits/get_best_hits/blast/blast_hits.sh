## Make reference DB

makeblastdb -in /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
    -parse_seqids \
    -dbtype nucl \
    -out mMyoCai_baby_seq

## Make query sequence (BED -> FASTA):

# dat <- fread("/Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/results/mMyoAui_vs_mMyoCai_reciprocal_best_hits.csv", data.table = FALSE)
# dat <- dat[1, c(1, 3:4)]
# write.table(dat, file = "mMyoAui_mMyoAui_vs_mMyoCai_hits.bed", sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits

$bedtools2 getfasta \
  -fi /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -bed /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/mMyoAui_mMyoAui_vs_mMyoCai_hits.bed > mMyoAui_seq.fasta

## Make ref sequence (BED -> FASTA):

# dat <- fread("/Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/results/mMyoAui_vs_mMyoCai_reciprocal_best_hits.csv", data.table = FALSE)
# dat <- dat[1, c(6, 8:9)]
# write.table(dat, file = "mMyoCai_mMyoAui_vs_mMyoCai_hits.bed", sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits

$bedtools2 getfasta \
  -fi /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
  -bed /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/mMyoCai_mMyoAui_vs_mMyoCai_hits.bed > mMyoCai_seq.fasta


## Make ref sequence (BED -> FASTA)

## Blast query against reference:

# cd /Users/rebecca/blastdb

blastn \
  -query /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/get_best_hits/mMyoAui_seq.fasta \
  -db mMyoCai_baby_seq \
  -out mMyoAui_vs_mMyoCai_baby_seq.txt \
  -num_threads 4 \
  -outfmt 6

####################

blastn \
  -query /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -subject /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
  -query_loc 231190000-234005000 \
  -outfmt 6 \
  -out mMyoAui_query_vs_mMyoCai_subject.txt 

blastn \
  -query /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoAui1.cleaned.hapheader.fa \
  -subject /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/mMyoCai1.cleaned.hapheader.fa \
  -subject_loc 40112-2853759 \
  -num_threads 4 \
  -outfmt 6 \
  -out mMyoAui_query_vs_mMyoCai_subject.txt 