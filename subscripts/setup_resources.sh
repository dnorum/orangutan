#!/bin/bash

# Convert the TSV dump file from LibraryThing into CSV using a Python script.
python ${DIR}/python/tsv2csv.py < ${DIR}/resources/librarything.tsv > ${DIR}/resources/librarything.csv
