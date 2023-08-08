import json
import psycopg
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/tsv2csv")
# TODO: At some point, publish this - or find a previously-published replacement.
import tsv2csv

# TODO: Clean up how credentials are handled.
with open("config/credentials.json") as jsonFile:
    credentials = json.load(jsonFile)

dbConnection = psycopg.connect( dbname=credentials['postgres']['bootstrapDbName']
                            ,   user=credentials['postgres']['user']
                            ,   host=credentials['postgres']['host']
                            ,   password=credentials['postgres']['password'] )

# Convert the TSV dump file from LibraryThing into CSV.
#tsv2csv.tsv2csv("sample_data/librarything_sample.tsv")