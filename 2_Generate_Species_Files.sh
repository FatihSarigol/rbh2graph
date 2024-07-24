for i in *rbh
do
SP1=$(echo "${i}" | cut -f1 -d'_')
SP2=$(echo "${i}" | cut -f2 -d'_')
ID=$(echo "${i}" | cut -f2 -d'-')
SPNAME=$(echo "${i}" | cut -f2 -d'_' | cut -f1 -d'-')
ASSEMBLY=$(echo "${i}" | cut -f2 -d'_' | cut -f3 -d'-')
TAXLINEAGE=$(awk -v Id="${ID}" 'BEGIN {FS="."}; $2==Id' UniqueTaxIDs.LINEAGED)
cat SpeciesHeader <(awk -v Sp1="${SP1}" -v Sp2="${SP2}" -v Id="${ID}" 'NR==1 {for (j=1; j<=NF; j++) {f[$j] = j}} {print $(f[Sp1"_gene"]) "\t" $(f[Sp2"_gene"]) "\t" $(f[Sp1"_scaf"]) "\t" $(f[Sp2"_scaf"]) "\t" $(f[Sp2"_pos"]) "\t" $(f["whole_FET"])}' <(awk 'BEGIN { FS = OFS = "\t" } { for(k=1; k<=NF; k++) if($k ~ /^ *$/) $k="UnknowN"};1' ${i}) | awk -v Id="${ID}" -v SPname="${SPNAME}" -v Assembly="${ASSEMBLY}" -v TaxLineage="${TAXLINEAGE}" '{print SPname "\t" $2 "." Id "\t" $4 "\t" $5 "\t" Id "\t" Assembly "\t" TaxLineage }' | sed '1d' | sed -e 's/\t/,/g' ) > ${ID}.species
done
