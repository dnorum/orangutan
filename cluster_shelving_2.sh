#!/bin/bash

# Define the directory location of the script.
DIR=$(dirname "$(readlink -f "$0")")

# Define the name of the database to be used.
database="cluster_analysis"

# Define the settings for the summary histograms.
n_intervals=100

# Newline to set off script output.
echo

# Create the table public.library_clusters and load in the R cluster file.
source ./subscripts/load_clusters.sh

# Add the clusters to the main library table.
psql $database -f ${DIR}/sql/add_clusters.sql > /dev/null 2>&1
echo "Clusters added to the main library table."

# Get the number of clusters over which to loop. (Scrub the Postgres output
# before printing it out.
max_cluster=$(psql $database -t -c "SELECT max("cluster"::INT) FROM library")
max_cluster=${max_cluster//[a-zA-Z ]/}
echo "Looping over clusters 1 to ${max_cluster}."
echo

# Now, loop over the clusters.
typeset -i cluster max_cluster
let cluster=1
while ((cluster<=max_cluster)); do

	echo "Summary statistics for cluster ${cluster}:"

	let cluster++
done

# Summarize each cluster - the same statistics as before, but including the
# total thickness (shelf-length) of the cluster.

# Output the dimensional data for each cluster.

# Plot the histograms and heat maps for each cluster.

# Clean things up and zip output folders for convenience.
