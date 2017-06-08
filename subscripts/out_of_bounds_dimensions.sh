#!/bin/bash

###################
### DEFINITIONS ###
###################

# Define the minimum and maximum values considered plausible for each of the
# physical dimensions. (Inches and pounds.) Note that these may need to be
# adjusted as the script is run iteratively.
height_min=4.0
height_max=12.0
width_min=3.0
width_max=10.0
thickness_min=0.0
thickness_max=12.0
weight_min=0.0
weight_max=25.0

for dimension in height width thickness weight
do

	# Clean up the dimension into a standard format and Imperial units. Yes,
	# this is a hideously inefficient invocation inside a loop, but
	# otherwise it's a nested eval echo construct that I've not yet wrapped
	# my head around.
	psql $database -U $user -c "$(sed -e "s/\${height_min}/${height_min}/g" -e "s/\${height_max}/${height_max}/g" -e "s/\${width_min}/${width_min}/g" -e "s/\${width_max}/${width_max}/g" -e "s/\${thickness_min}/${thickness_min}/g" -e "s/\${thickness_max}/${thickness_max}/g" -e "s/\${weight_min}/${weight_min}/g" -e "s/\${weight_max}/${weight_max}/g" ${DIR}/sql/null_out_of_bounds_${dimension}.sql)" > /dev/null 2>&1

	# Record the number of non-NULL values that are left.
	n_dimension_non_null=$(psql $database -U $user -t -c "SELECT COUNT(*) FROM library WHERE ${dimension}_scrubbed IS NOT NULL")

	# Trim whitespace.
	n_dimension_non_null=${n_dimension_non_null// /}

	# Status update.
	echo "$n_dimension_non_null values for ${dimension} remaining after NULLing out-of-bounds values."

done
