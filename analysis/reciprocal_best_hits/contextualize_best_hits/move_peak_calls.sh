cd /Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/genes

rsync -ravm --exclude='/*/BAM' --exclude='/*/BIGWIG' \
   reliscu@dtn.brc.berkeley.edu:/global/home/users/reliscu/scratch/rotation/data/bat/processed_data/ATAC/2023-04-14_ATAC_Myotis_Pilot/Analysis-Results/ .

cd /Users/rebecca/sudmant/analyses/myotis/data/ATAC-seq/TEs

rsync -ravm --exclude='*/BAM' --exclude='*/BIGWIG' \
   reliscu@dtn.brc.berkeley.edu:/global/home/users/reliscu/scratch/rotation/data/bat/processed_data/ATAC/2023-04-14_ATAC_Myotis_Pilot_TEs/ .