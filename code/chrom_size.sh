cd /Users/rebecca/sudmant/analyses/myotis/data

## Make genome files with chromosome length per species (needed for using bedtools to pad feature positions in annotation files):

abbr_names=($(awk -F"," 'NR>1{print $2}' /Users/rebecca/sudmant/analyses/myotis/data/myotis_meta.csv))

for ea in ${abbr_names[@]}; do
  echo $ea
  faidx /Users/rebecca/sudmant/analyses/myotis/data/genomes/bat_genomes/${ea}1.cleaned.hapheader.fa \
    -i chromsizes | sed "s/SCAF/SUPER/" | sed "s/#0#/.0./" | sed "s/${ea}1.0.//g" > ${ea}_chromsizes
done