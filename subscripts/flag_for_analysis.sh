#!/bin/bash

# Run the query to flag books for inclusion in cluster analysis.
psql $database -c "$(sed ${DIR}/sql/select_for_cluster_analysis.sql)" > /dev/null 2>&1

# Record the number of books selected and omitted.
n_selected=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE include_cluster_analysis")
n_omitted=$(psql $database -t -c "SELECT COUNT(*) FROM library WHERE NOT include_cluster_analysis")

# Trim whitespace.
n_selected=${n_selected// /}
n_omitted=${n_omitted// /}

# Status update.
echo "$n_selected books selected for cluster analysis; $n_omitted books omitted from analysis."
