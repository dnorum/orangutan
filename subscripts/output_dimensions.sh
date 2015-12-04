#!/bin/bash

# Clear out the working file directory if it exists.
[ -d ${DIR}/working ] && { rm -rf ${DIR}/working; echo "Existing /working directory removed."; }

# Create the /working directory.
mkdir ${DIR}/working

# Allow _all_ users write access. Note that this is not optimum, but I've not
# taken the time to find the postgres-specific setting.
chmod a+w ${DIR}/working

# Status update.
echo "Created /working directory."

# Output raw data with book dimensions and record the number of rows imported.
# sed is used to make the directory substitution in the SQL source file - the
# bash regex replace is used so that the /s in the directory path don't break
# the sed regex.
n_records_dumped=$(psql $database -c "$(sed -e "s/\${DIR}/${DIR//\//\\\/}/g" ${DIR}/subscripts/sql/output_dimensions.sql)")

# Scrub the output of the postgres command to just the number of rows dumped.
n_records_dumped=${n_records_dumped//[a-zA-Z ]/}

# Status update.
echo "${n_records_dumped} records from public.library with dimensions dumped for plotting and analysis."
echo
