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

	# Summarize each cluster - the same statistics as before.
	echo "Summary statistics for cluster ${cluster}:"
	source ./subscripts/summary_cluster_statistics.sh

	# Clear out DIR/subdir (if it exists) for each cluster's data and plots.
	[ -d ${DIR}/working/cluster_${cluster} ] && { rm -rf ${DIR}/working/cluster_${cluster}; echo "Existing /working/cluster_${cluster} directory removed."; }
	[ -d ${DIR}/plots/cluster_${cluster} ] && { rm -rf ${DIR}/plots/cluster_${cluster}; echo "Existing /plots/cluster_${cluster} directory removed."; }

	# Create DIR/subdirs
	mkdir ${DIR}/working/cluster_${cluster}
	echo "Created /working/cluster_${cluster} subdirectory."
	mkdir ${DIR}/plots/cluster_${cluster}
	echo "Created /plots/cluster_${cluster} subdirectory."

	# Allow _all_ users write access for these directories. Note that this
	# is not optimal, but I've not taken the time to find the
	# postgres-specific setting.
	chmod a+w ${DIR}/working/cluster_${cluster}
	chmod a+w ${DIR}/plots/cluster_${cluster}

	# Output the dimensional data for each cluster.
	psql $database -c "$(sed -e "s@\${DIR}@${DIR}@g" -e "s/\${cluster}/${cluster}/g" -e "s/\${max_height}/${max_height}/g" -e "s/\${min_height}/${min_height}/g" -e "s/\${max_width}/${max_width}/g" -e "s/\${min_width}/${min_width}/g" -e "s/\${n_intervals}/${n_intervals}/g" ${DIR}/sql/output_dimensions_for_cluster_summary.sql)"

	# Plot the histograms and heat maps for each cluster.
	source ./subscripts/summary_cluster_plots.sh

	# Set off the next output chunk.
	echo
	echo

	let cluster++
done
