#!/bin/bash

# Define the directory location of the script.
DIR=$(dirname "$(readlink -f "$0")")

# Define the name of the database to be used.
database="cluster_analysis"

# Define the minimum and maximum values considered plausible for each of the
# physical dimensions. (Inches and pounds.) Note that these may need to be
# adjusted as the script is run iteratively.
height_min=4
height_max=12 # N/A
width_min=3
width_max=10 # N/A
thickness_min=0.0
thickness_max=12 # N/A
weight_min=0.0
weight_max=25

# Define the settings for the summary histograms.
n_intervals=100

# Newline to set off script output.
echo

# Create the table public.library_clusters and load in the R cluster file.
source ./subscripts/load_clusters.sh
