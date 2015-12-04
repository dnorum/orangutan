#!/bin/bash

# Define the directory location of the script.
DIR=$(dirname "$(readlink -f "$0")")

# Define the name of the database to be used.
database="cluster_analysis"

# Newline to set off script output.
echo

# Drop and recreate the database specified above.
source ./subscripts/create_database.sh

# Create the table public.library and load in the LibraryThing database file.
source ./subscripts/load_librarything.sh

# Clean up the dimensions into a standard format and Imperial units.
source ./subscripts/clean_records.sh

# Record the summary statistics - min, max, average, and standard deviation -
# for each of the book dimensions. These will also be used to create histograms
# summarizing the data.
source ./subscripts/summary_statistics.sh

# Create a /working directory and output the dimensions for plotting and cluster
# analysis.
source ./subscripts/output_dimensions.sh
