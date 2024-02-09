cd /Users/rebecca/sudmant/analyses/myotis/data/pafs

rustybam=/Users/rebecca/programs/rustybam-x86_64-apple-darwin/rustybam

## Note: I don't end up using these trimmed PAFs... I want to maximize the potential for finding RBHs in the following steps

for ea in *paf; do
  echo $ea
  if ! [ -f trimmed/$(echo $ea | sed 's/.paf/_trimmed.paf/') ]; then 
    $rustybam trim-paf $ea \
    > /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/01_RBHs/resources/pafs/$(echo $ea | sed 's/.paf/_trimmed.paf/')
  fi
done
