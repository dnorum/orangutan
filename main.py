import sys
sys.path.append("python/packages/tsv2csv")

import tsv2csv

# Convert the TSV dump file from LibraryThing into CSV.
tsv2csv.tsv2csv("sample_data/librarything_sample.tsv")