# From GitHub nsonnad/tsv2csv.py, https://gist.github.com/nsonnad/7598574
import sys
import csv

# TODO: Add optional output file name != input file - default to same.
# TODO: Add error-checking for TSV file existence.
# TODO: Add error-checking for CSV file existence (w.r.t. overwriting)..
def tsv2csv(tsvFilename):
	with open(tsvFilename, 'r') as tsvFile:
		tsvIn = csv.reader(tsvFile, dialect=csv.excel_tab)
		csvFilename = tsvFilename[:-3] + 'csv'
		with open(csvFilename, 'w') as csvFile:
			csvOut = csv.writer(csvFile, dialect=csv.excel)
			for row in tsvIn:
				csvOut.writerow(row)