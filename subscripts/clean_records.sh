#!/bin/bash


# Clean up the height into a standard format and Imperial units and record the
# number of non-NULL values that are produced.
psql $database -c "$(sed -e "s/\${height_min}/${height_min}/g" -e "s/\${height_max}/${height_max}/g" ${DIR}/subscripts/sql/clean_and_convert_height.sql)" > /dev/null 2>&1
n_height_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE height_scrubbed IS NOT NULL")

# Trim whitespace.
n_height_non_null=${n_height_non_null// /}

# Status update.
echo "$n_height_non_null heights converted into numeric, Imperial values."

# Clean up the length into a standard format and Imperial units and record the
# number of non-NULL values that are produced.
psql $database -c "$(sed -e "s/\${length_min}/${length_min}/g" -e "s/\${length_max}/${length_max}/g" ${DIR}/subscripts/sql/clean_and_convert_length.sql)" > /dev/null 2>&1
n_length_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE length_scrubbed IS NOT NULL")

# Trim whitespace.
n_length_non_null=${n_length_non_null// /}

# Status update.
echo "$n_length_non_null lengths (depths) converted into numeric, Imperial values."

# Clean up the thickness into a standard format and Imperial units and record
# the number of non-NULL values that are produced.
psql $database -c "$(sed -e "s/\${thickness_min}/${thickness_min}/g" -e "s/\${thickness_max}/${thickness_max}/g" ${DIR}/subscripts/sql/clean_and_convert_thickness.sql)" > /dev/null 2>&1
n_thickness_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE thickness_scrubbed IS NOT NULL")

# Trim whitespace.
n_thickness_non_null=${n_thickness_non_null// /}

# Status update.
echo "$n_thickness_non_null thicknesses converted into numeric, Imperial values."

# Standardize the dimensions to have either all or none for each record.
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

# Clean up the weight into a standard format and Imperial units and record the
# number of non-NULL values that are produced.
psql $database -c "$(sed -e "s/\${weight_min}/${weight_min}/g" -e "s/\${weight_max}/${weight_max}/g" ${DIR}/subscripts/sql/clean_and_convert_weight.sql)" > /dev/null 2>&1
n_weight_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE weight_scrubbed IS NOT NULL")

# Trim whitespace.
n_weight_non_null=${n_weight_non_null// /}

# Status update.
echo "$n_weight_non_null weights converted into numeric, Imperial values."

# Record how many records have all of their dimensions as well as weight.
n_dimensions_weight=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE thickness_scrubbed IS NOT NULL AND weight_scrubbed IS NOT NULL")

# Trim whitespace.
n_dimensions_weight=${n_dimensions_weight// /}

# Status update.
echo "${n_dimensions_weight} records with height/length/thickness and weight."
echo
