import json
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/librarything")
sys.path.append("python/packages/squirrel")
import librarything
import squirrel

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

database = squirrel.Database(postgres["prod"]["database_name"])
schema = squirrel.Schema(database, postgres["prod"]["schema_name"])
table = squirrel.Table(schema, postgres["prod"]["table_name"])

# Log into bootstrapping environment to create production database.
connection_settings = squirrel.extract_connection_settings(postgres["bootstrap"])
# Wrapper for idempotent development re-runs.
if not squirrel.database_exists(connection_settings, database):
    squirrel.create_database(connection_settings, database)

# Switch to production and create the schema.
connection_settings = squirrel.extract_connection_settings(postgres["prod"])
# Wrapper for idempotent development re-runs.
if not squirrel.schema_exists(connection_settings, schema):
    squirrel.create_schema(connection_settings, schema)

# Create the table in the library schema.
# Wrapper for idempotent development re-runs.
if not squirrel.table_exists(connection_settings, table):
    librarything.create_empty_bookstack(connection_settings, schema)

# Load the data into the table.
librarything.import_bookstack(connection_settings, "data/librarything_dnorum.csv", table)


# To force the last line up above the horizontal scrollbar, because Eclipse has
# a decade-plus-old bug w.r.t. this.