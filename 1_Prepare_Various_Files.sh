#Create a directory with all the rbh files and subset them for only one assembly for each taxon:
ls -1 | cut -f2 -d'-' | sort -u -V > UniqueTaxIDs
for i in $(cat UniqueTaxIDs); do find | grep -w ${i} -m1 ;done > UniqueTaxIDFileNames &
mkdir UNIQUEtaxidRBHS
for i in $(cat UniqueTaxIDFileNames); do mv ${i} UNIQUEtaxidRBHS;done
#Generate a couple of files with the complete set of unique ALGs and OGs by combining all ALGs and OGs from all of the rbh files.
cut -f1,2 *rbh | sed -e 's/\t/_/g' | sort -u -V > ALLuniqueGENEfamilyNAMESunderscored &
cut -f4 -d '_' ALLuniqueGENEfamilyNAMESunderscored > ALLuniqueGENEfamilyNAMESunderscoredCHRS
paste ALLuniqueGENEfamilyNAMESunderscored ALLuniqueGENEfamilyNAMESunderscoredCHRS > ALLuniqueGENEfamilyNAMESunderscoredREADY
cut -f2 ALLuniqueGENEfamilyNAMESunderscoredREADY | sort -u > ALGs
cp ALLuniqueGENEfamilyNAMESunderscoredREADY OGsUNIQUElist
sed -e 's/\t/,/g' OGsUNIQUElist > OGs
#Add header OG,ALG to OGs file and ALG to ALGs file.
#Download the archive containing the file with complete lineage TaxIDs from NCBI and reshape its format so each TaxID of a lineage is separated by dots for easy pattern matching later:
wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz
tar -xvzf new_taxdump.tar.gz
awk -v OFS="\t" '$1=$1' taxidlineage.dmp | sed -e 's/|\t//g' | sed -e 's/\t|//g' | sed -e 's/\t/./g' | sed 's/^/./' | sed 's/$/./' > taxidlineage.dmp.DOTTED
#Extract the lineage TaxIDs of the species in our list.
awk 'BEGIN {FS="."}; NR==FNR{j[$1];next}($2 in j)' UniqueTaxIDs taxidlineage.dmp.DOTTED > UniqueTaxIDs.LINEAGED
