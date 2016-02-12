#!/bin/bash

# Create the table in the database to hold the cluster file's data.
psql $database -f ${DIR}/subscripts/sql/create_cluster_table.sql > /dev/null 2>&1

# Status update.
echo "public.library_clusters created in $database."

# Load the cluster analysis output file and record the number of rows imported.
n_records_loaded=$(psql $database -f ${DIR}/subscripts/sql/load_cluster_table.sql)

# Scrub the output of the postgres command to just the number of rows loaded.
n_records_loaded=${n_records_loaded//[a-zA-Z ]/}

# Status update.
echo "${n_records_loaded} records from cluster analysis file loaded into public.library_clusters."
echo
