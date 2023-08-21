import json
import psycopg
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/database")
sys.path.append("python/packages/library_thing_database")
import database as db
import library_thing_database as lt

postgres = {}

with open("config/postgres.json") as json_file:
    postgres_config = json.load(json_file)
for stage in postgres_config:
    if stage not in postgres:
        postgres[stage] = {}
    postgres[stage] = {**postgres[stage], **postgres_config[stage]}

with open("credentials/postgres.json") as json_file:
    postgres_credentials = json.load(json_file)
for stage in postgres_credentials:
    if stage not in postgres:
        postgres[stage] = {}
    postgres[stage] = {**postgres[stage], **postgres_credentials[stage]}

database = db.Database(postgres["prod"]["database_name"])
schema = db.Schema(database, postgres["prod"]["schema_name"])

# Log into bootstrapping environment to create production database.
connection_settings = db.extract_connection_settings(postgres["bootstrap"])
# Wrapper for idempotent development re-runs.
if not db.database_exists(connection_settings, database):
    db.create_database(connection_settings, database)

# Switch to production and create the schema.
connection_settings = db.extract_connection_settings(postgres["prod"])
# Wrapper for idempotent development re-runs.
if not db.schema_exists(connection_settings, schema):
    db.create_schema(connection_settings, schema)

# Create the table in the library schema.
lt.create_empty_bookstack(connection_settings, schema)

# Load the data into the table.