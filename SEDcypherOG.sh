for i in $(cat UniqueTaxIDs)
do
sed -e 's/SP/'"${i}"'/g' CYPHERoG
done
