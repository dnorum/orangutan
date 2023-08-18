import json
import psycopg
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/database")
sys.path.append("python/packages/library_thing_database")
# TODO: At some point, publish this - or find a previously-published replacement.
sys.path.append("python/packages/tsv2csv")
import database
import library_thing_database
import tsv2csv

# TODO: Combine into a single object.
with open("config/postgres.json") as json_file:
    postgres_config = json.load(json_file)
with open("credentials/postgres.json") as json_file:
    postgres_credentials = json.load(json_file)

connection_settings = {**postgres_config["bootstrap"], **postgres_credentials["bootstrap"]}

# Rename "database_name" to "dbName" for psycopg compatibility.
connection_settings["dbname"] = connection_settings["database_name"]
del connection_settings["database_name"]

database_name = postgres_config["prod"]["database_name"]
database.create_database(connection_settings, database_name)

# Convert the TSV dump file from LibraryThing into CSV.
#tsv2csv.tsv2csv("sample_data/librarything_sample.tsv")