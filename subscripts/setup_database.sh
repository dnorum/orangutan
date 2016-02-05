#!/bin/bash

# Drop (if it exists) and recreate the database specified in the main
# cluster_shelving.sh script.
if psql $database -c '\q' 2>&1; then
	sudo -u $USER dropdb --if-exists $database
	sudo -u $USER createdb $database
	echo "$database dropped and recreated."
else
	sudo -u $USER createdb $database
	echo "$database created."
fi
echo

# Create the table (public.library) to hold the LibraryThing dump file's data.
psql $database -f ${DIR}/sql/create_table.sql > /dev/null 2>&1

# Status update.
echo "public.library created in $database."

# Load the LibraryThing dump file into the database and record the number of
# rows imported.
n_records_loaded=$(psql $database -c "$(sed -e "s@\${DIR}@${DIR}@g" ${DIR}/sql/load_library.sql)")

# Scrub the output of the postgres command to just the number of rows loaded.
n_records_loaded=${n_records_loaded//[a-zA-Z ]/}

# Status update.
echo "${n_records_loaded} records from LibraryThing dump file loaded into public.library."
echo

# Clean up each dimension into a standard format and Imperial units.
for dimension in height width thickness
do

	# Clean up the dimension into a standard format and Imperial units. Yes,
	# this is a hideously inefficient invocation inside a loop, but
	# otherwise it's a nested eval echo construct that I've not yet wrapped
	# my head around.
	psql $database -c "$(sed -e "s/\${height_min}/${height_min}/g" -e "s/\${height_max}/${height_max}/g" -e "s/\${width_min}/${width_min}/g" -e "s/\${width_max}/${width_max}/g" -e "s/\${thickness_min}/${thickness_min}/g" -e "s/\${thickness_max}/${thickness_max}/g" -e "s/\${weight_min}/${weight_min}/g" -e "s/\${weight_max}/${weight_max}/g" ${DIR}/sql/clean_and_convert_${dimension}.sql)" > /dev/null 2>&1

	# Record the number of non-NULL values that are produced.
	n_dimension_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE ${dimension}_scrubbed IS NOT NULL")

	# Trim whitespace.
	n_dimension_non_null=${n_dimension_non_null// /}

	# Status update.
	echo "$n_dimension_non_null values for ${dimension} converted into numeric, Imperial values."

done

# Record how many records have all of their dimensions, some dimensions, no
# dimensions. (Excluding weight.)
n_all_dimensions=$(psql $database -t -c "$(sed -e "s@\${DIR}@${DIR}@g" ${DIR}/sql/count_all_dimensions.sql)")
n_some_dimensions=$(psql $database -t -c "$(sed -e "s@\${DIR}@${DIR}@g" ${DIR}/sql/count_some_dimensions.sql)")
n_no_dimensions=$(psql $database -t -c "$(sed -e "s@\${DIR}@${DIR}@g" ${DIR}/sql/count_no_dimensions.sql)")

# Trim whitespace.
n_all_dimensions=${n_all_dimensions// /}
n_some_dimensions=${n_some_dimensions// /}
n_no_dimensions=${n_no_dimensions// /}

# Status update.
echo "${n_all_dimensions} records with height/width/thickness, ${n_some_dimensions} records with at least one but not all, and ${n_no_dimensions} records without."
echo

# Record how many records have all of their dimensions as well as weight.
n_all_dimensions_plus_weight=$(psql $database -t -c "$(sed -e "s@\${DIR}@${DIR}@g" ${DIR}/sql/count_all_dimensions_plus_weight.sql)")

# Trim whitespace.
n_all_dimensions_plus_weight=${n_all_dimensions_plus_weight// /}

# Status update.
echo "${n_all_dimensions_plus_weight} records with height/width/thickness and weight."
echo
