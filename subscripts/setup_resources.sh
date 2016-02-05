#!/bin/bash

# Convert the TSV dump file from LibraryThing into CSV using a Python script.
python ${DIR}/python/tsv2csv.py < ${DIR}/resources/librarything.tsv > ${DIR}/resources/librarything.csv

# Copy the kmeans.R script from /r_scripts into the /r working directory.
cp ${DIR}/r_scripts/kmeans.R ${DIR}/r/kmeans.R
