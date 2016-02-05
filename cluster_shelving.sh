#!/bin/bash

###################
### DEFINITIONS ###
###################

# Define the directory location of the script.
DIR=$(dirname "$(readlink -f "$0")")

# Define the name of the database to be used.
database="cluster_analysis"

# Define the minimum and maximum values considered plausible for each of the
# physical dimensions. (Inches and pounds.) Note that these may need to be
# adjusted as the script is run iteratively.

# If one of the height / length / thickness values is invalid, all three will
# be NULLed out.
height_min=4.0
height_max=12.0
length_min=3.0
length_max=10.0
thickness_min=0.0
thickness_max=12.0

# These limits only affect the weight - invalid weights will not affect the
# height / length / thickness and vice versa.
weight_min=0.0
weight_max=25.0

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








# Record the summary statistics - min, max, average, and standard deviation -
# for each of the book dimensions. These will also be used to create histograms
# summarizing the data.
source ./subscripts/summary_statistics.sh

# Create a /working directory and output the dimensions for plotting and cluster
# analysis.
source ./subscripts/output_dimensions.sh

# Output the first set of plots summarizing the dimensions.
source ./subscripts/summary_plots.sh


