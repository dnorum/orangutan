#!/bin/bash

# Clean up the height into a standard format and Imperial units and record the
# number of non-NULL values that are produced.
psql $database -f ${DIR}/subscripts/sql/clean_and_convert_height.sql > /dev/null 2>&1
n_height_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE height_scrubbed IS NOT NULL")

# Trim whitespace.
n_height_non_null=${n_height_non_null// /}

# Status update.
echo "$n_height_non_null heights converted into numeric, Imperial values."

# Clean up the length into a standard format and Imperial units and record the
# number of non-NULL values that are produced.
psql $database -f ${DIR}/subscripts/sql/clean_and_convert_length.sql > /dev/null 2>&1
n_length_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE length_scrubbed IS NOT NULL")

# Trim whitespace.
n_length_non_null=${n_length_non_null// /}

# Status update.
echo "$n_length_non_null lengths (depths) converted into numeric, Imperial values."

# Clean up the thickness into a standard format and Imperial units and record
# the number of non-NULL values that are produced.
psql $database -f ${DIR}/subscripts/sql/clean_and_convert_thickness.sql > /dev/null 2>&1
n_thickness_non_null=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE thickness_scrubbed IS NOT NULL")

# Trim whitespace.
n_thickness_non_null=${n_thickness_non_null// /}

# Status update.
echo "$n_thickness_non_null thicknesses converted into numeric, Imperial values."

# Standardize the dimensions to have either all or none for each record.
psql $database -f ${DIR}/subscripts/sql/standardize_dimensions.sql > /dev/null 2>&1
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
