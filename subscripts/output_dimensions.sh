#!/bin/bash

# Output raw data with book dimensions and record the number of rows exported
# for the cluster analysis.
n_records_dumped=$(psql $database -c "$(sed -e "s@\${DIR}@${DIR}@g" -e "s/\${max_height}/${selection_max_height}/g" -e "s/\${min_height}/${selection_min_height}/g" -e "s/\${max_width}/${selection_max_width}/g" -e "s/\${min_width}/${selection_min_width}/g" -e "s/\${n_intervals}/${n_intervals}/g" ${DIR}/sql/output_dimensions_for_analysis.sql)")

# Scrub the output of the postgres command to just the number of rows dumped.
n_records_dumped=${n_records_dumped//[a-zA-Z ]/}

# Status update.
echo "${n_records_dumped} records from public.library with dimensions dumped for selection plotting and analysis."
echo

# Output raw data with book dimensions and record the number of rows exported
# for the summary plots.
n_records_dumped_summary=$(psql $database -c "$(sed -e "s@\${DIR}@${DIR}@g" -e "s/\${max_height}/${max_height}/g" -e "s/\${min_height}/${min_height}/g" -e "s/\${max_width}/${max_width}/g" -e "s/\${min_width}/${min_width}/g" -e "s/\${n_intervals}/${n_intervals}/g" ${DIR}/sql/output_dimensions_for_analysis.sql)")

# Scrub the output of the postgres command to just the number of rows dumped.
n_records_dumped_summary=${n_records_dumped_summary//[a-zA-Z ]/}

# Status update.
echo "${n_records_dumped_summary} records from public.library with dimensions dumped for summary plotting."
echo
