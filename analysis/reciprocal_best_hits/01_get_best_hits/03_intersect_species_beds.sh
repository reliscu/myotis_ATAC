cd /Users/rebecca/sudmant/analyses/myotis/analysis/reciprocal_best_hits/01_get_best_hits/resources/beds

species=($(awk -F"," 'NR>1 {print $2}' ../../../../../data/myotis_meta.csv)) 

bedtools2=/Users/rebecca/programs/bedtools2/bin/bedtools

for spec1 in ${species[@]}; do

    for spec2 in ${species[@]}; do
        if [ $spec1 != $spec2 ]; then

            echo $spec1 vs. $spec2

            $bedtools2 intersect -wb \
                -a ${spec1}_vs_${spec2}_positions_target.bed \
                -b ${spec1}_vs_${spec2}_positions_query.bed > \
                ${spec1}_vs_${spec2}_positions_intersect.bed

        fi

    done

done
