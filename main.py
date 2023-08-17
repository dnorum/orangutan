import json
import psycopg
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/database")
sys.path.append("python/packages/libraryThingDatabase")
# TODO: At some point, publish this - or find a previously-published replacement.
sys.path.append("python/packages/tsv2csv")
import database
import libraryThingDatabase
import tsv2csv

with open("config/postgres.json") as jsonFile:
    postgresConfig = json.load(jsonFile)
with open("credentials/postgres.json") as jsonFile:
    postgresCredentials = json.load(jsonFile)

connectionSettings = {**postgresConfig["bootstrap"], **postgresCredentials["bootstrap"]}

dbname = postgresConfig["prod"]["dbname"]
# schema = postgresConfig["prod"]["schema"]
# table = postgresConfig["prod"]["table"]
database.createDatabase(connectionSettings, dbname)
# database.createSchema(connectionSettings, schema)
# database.createTable(connectionSettings, table)

# Convert the TSV dump file from LibraryThing into CSV.
#tsv2csv.tsv2csv("sample_data/librarything_sample.tsv")