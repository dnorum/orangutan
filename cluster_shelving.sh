#!/bin/sh

# Define the name of the database to be used. Note that the first postgres
# commands will drop and recreate this database.
database="cluster_analysis"

# Set up an empty database with the name above.
sudo -u $USER dropdb --if-exists $database
sudo -u $USER createdb $database
echo "$database dropped and (re)created."

# Load the LibraryThing dump file (converted to CSV) into the database.
psql $database -f create_and_load_table.sql > /dev/null 2>&1
echo "LibraryThing dump file loaded into $database."

# Clean up the dimensional fields into standard format and Imperial units.
psql $database -f clean_and_convert_height.sql > /dev/null 2>&1
echo Height converted into numeric, Imperial values.
psql $database -f clean_and_convert_length.sql > /dev/null 2>&1
echo "Length (depth) converted into numeric, Imperial values."
psql $database -f clean_and_convert_thickness.sql > /dev/null 2>&1
echo Thickness converted into numeric, Imperial values.
