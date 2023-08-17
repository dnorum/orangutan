import json
import psycopg
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/database")
sys.path.append("python/packages/libraryThingDatabase")
sys.path.append("python/packages/tsv2csv")
# TODO: At some point, publish this - or find a previously-published replacement.
import database
import libraryThingDatabase
import tsv2csv

# TODO: Clean up how credentials are handled.
with open("config/credentials.json") as jsonFile:
    credentials = json.load(jsonFile)

with psycopg.connect(   dbname=credentials['postgres']['bootstrapDbName']
                    ,   user=credentials['postgres']['user']
                    ,   host=credentials['postgres']['host']
                    ,   password=credentials['postgres']['password'] ) as connection:
    connection.autocommit = True
    with connection.cursor() as cursor:
        # TODO: Find a workaround to avoid injection, but apparently PostgreSQL
        # allow for parameterization of CREATE DATABASE...
        dbName = credentials['postgres']['dbName']
        if not database.databaseExists(connection, dbName):
            query = "CREATE DATABASE " + dbName + ";"
            cursor.execute(query)
        else:
            print("Database {dbName} already exists.".format(**{'dbName': dbName}))
       

# Convert the TSV dump file from LibraryThing into CSV.
#tsv2csv.tsv2csv("sample_data/librarything_sample.tsv")