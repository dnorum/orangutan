#!/bin/bash

# Define the directory location of the script.
DIR=$(dirname "$(readlink -f "$0")")

# Define the name of the database to be used.
database="cluster_analysis"

# Define the minimum and maximum values considered plausible for each of the
# physical dimensions. (Inches and pounds.) Note that these may need to be
# adjusted as the script is run iteratively.
height_min=0.0
height_max=1000 # N/A
length_min=0.0
length_max=1000 # N/A
thickness_min=0.0
thickness_max=1000 # N/A
weight_min=0.0
weight_max=10000

# Define the settings for the summary histograms.
n_intervals=100

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

# Output the first set of plots summarizing the dimensions.
source ./subscripts/summary_plots.sh


