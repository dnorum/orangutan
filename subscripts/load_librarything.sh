#!/bin/bash

# Create the table in the database to hold the LibraryThing dump file's data.
psql $database -f ${DIR}/subscripts/sql/create_table.sql > /dev/null 2>&1

# Status update.
echo "public.library created in $database."

# Load the LibraryThing dump file (converted to CSV) into the database and
# record the number of rows imported.
n_records_loaded=$(psql $database -f ${DIR}/subscripts/sql/load_table.sql)

# Scrub the output of the postgres command to just the number of rows loaded.
n_records_loaded=${n_records_loaded//[a-zA-Z ]/}

# Status update.
echo "${n_records_loaded} records from LibraryThing dump file loaded into public.library."
echo
