#!/bin/sh

# Define the name of the database to be used. Note that the first postgres
# commands will drop and recreate this database.
database="cluster_analysis"

# Set up an empty database with the name above.
sudo -u $USER dropdb --if-exists $database
sudo -u $USER createdb $database

# Load the LibraryThing dump file (converted to CSV) into the database.
psql $database -f create_and_load_table.sql

# Clean up the dimensional fields into standard format and Imperial units.
psql $database -f clean_and_convert_dimensions.sql
