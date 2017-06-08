#!/bin/bash

###################
### DEFINITIONS ###
###################

# Define the directory location of the script.
DIR=$(dirname "$(readlink -f "$0")")

# Define the name of the database to be used.
database="cluster_analysis"

#Define the user
user="JRANDOM"

# Define the settings for the summary histograms.
n_intervals=100


########################
### Start of scripts ###
########################

# Newline to set off script output.
echo

# Create the directory structure (within DIR) needed for creating, copying, and
# storing various files.
source ./subscripts/setup_directories.sh

# Create the various resource files needed.
source ./subscripts/setup_resources.sh

# Setup the database to use for the analysis and load in the LibraryThing data.
source ./subscripts/setup_database.sh

# If you want to NULL out-of-bounds dimensions, include this subscript.
source ./subscripts/out_of_bounds_dimensions.sh

# Create the flag on each record to indicate whether or not to include it in the
# cluster analysis.
source ./subscripts/flag_for_analysis.sh

# Record the summary statistics - min, max, average, and standard deviation -
# for each of the book dimensions. These will also be used to create histograms
# summarizing the data.
source ./subscripts/summary_statistics.sh

# Record the statistics for the books to undergo cluster analysis.
source ./subscripts/selection_statistics.sh

# Output the dimensions of the selected books for plotting and cluster analysis.
source ./subscripts/output_dimensions.sh

# Output the first sets of plots summarizing the dimensions - one overall and
# one for the cluster_analysis sample.
source ./subscripts/summary_plots.sh
