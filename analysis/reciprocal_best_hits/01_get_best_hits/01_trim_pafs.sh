cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/01_get_best_hits/resources/pafs

rustybam=/Users/rebecca/programs/rustybam-x86_64-apple-darwin/rustybam

for ea in *paf; do
  echo $ea
  if ! [ -f trimmed/$(echo $ea | sed 's/.paf/_trimmed.paf/') ]; then 
    $rustybam trim-paf $ea > trimmed/$(echo $ea | sed 's/.paf/_trimmed.paf/')
  fi
done
