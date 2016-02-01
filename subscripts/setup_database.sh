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
n_records_loaded=$(psql $database -c "$(sed -e "s/\${DIR}/${DIR}/g" ${DIR}/sql/load_library.sql)")

# Scrub the output of the postgres command to just the number of rows loaded.
n_records_loaded=${n_records_loaded//[a-zA-Z ]/}

# Status update.
echo "${n_records_loaded} records from LibraryThing dump file loaded into public.library."
echo

# Clean up each dimension into a standard format and Imperial units.
for dimension in height length thickness
do

	# Clean up the dimension into a standard format and Imperial units and
	# record the number of non-NULL values that are produced. Yes, this is
	# a hideously inefficient invocation inside a loop, but otherwise it's
	# a nested eval echo construct that I've not yet wrapped my head around.
	psql $database -c "$(sed -e "s/\${height_min}/${height_min}/g" -e "s/\${height_max}/${height_max}/g" -e "s/\${length_min}/${length_min}/g" -e "s/\${length_max}/${length_max}/g" -e "s/\${thickness_min}/${thickness_min}/g" -e "s/\${thickness_max}/${thickness_max}/g" -e "s/\${weight_min}/${weight_min}/g" -e "s/\${weight_max}/${weight_max}/g" ${DIR}/subscripts/sql/clean_and_convert_${dimension}.sql)" > /dev/null 2>&1
n_dimension_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE ${dimension}_scrubbed IS NOT NULL")

	# Trim whitespace.
	n_dimension_non_null=${n_dimension_non_null// /}

	# Status update.
	echo "$n_dimension_non_null values for ${dimension} converted into numeric, Imperial values."

done

# Standardize the dimensions to have either all or none for each record. Note
# that weight is treated differently because a book could very well have its
# height-length-thickness recorded and no weight, or vice versa, but it doesn't
# make nearly as much sense to have a book that has, say, thickness and length
# but no width.
psql $database -c ${DIR}/subscripts/sql/standardize_dimensions.sql > /dev/null 2>&1
echo "Dimensions standardized to all or nothing (height-length-thickness)."

# Record how many records have all of their dimensions, no dimensions.
n_dimensions=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE thickness_scrubbed IS NOT NULL")
n_no_dimensions=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE thickness_scrubbed IS NULL")

# Trim whitespace.
n_dimensions=${n_dimensions// /}
n_no_dimensions=${n_no_dimensions// /}

# Status update.
echo "${n_dimensions} records with height/length/thickness, ${n_no_dimensions} records without."
echo

# Record how many records have all of their dimensions as well as weight.
n_dimensions_weight=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE thickness_scrubbed IS NOT NULL AND weight_scrubbed IS NOT NULL")

# Trim whitespace.
n_dimensions_weight=${n_dimensions_weight// /}

# Status update.
echo "${n_dimensions_weight} records with height/length/thickness and weight."
echo
