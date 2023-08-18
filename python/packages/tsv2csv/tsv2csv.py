import csv
import sys

# TODO: Add optional output file name != input file - default to same.
# TODO: Add error-checking for TSV file existence.
# TODO: Add error-checking for CSV file existence (w.r.t. overwriting)..
def tsv2csv(tsv_filename):
	with open(tsv_filename, 'r') as tsv_file:
		tsv_in = csv.reader(tsv_file, dialect=csv.excel_tab)
		csv_filename = tsv_filename[:-3] + 'csv'
		with open(csv_filename, 'w') as csv_file:
			csv_out = csv.writer(csv_file, dialect=csv.excel)
			for row in tsv_in:
				csv_out.writerow(row)