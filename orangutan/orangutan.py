# Set up manual importing of under-development sub-packages from within the repo.
import sys
sys.path.append("common")
sys.path.append("librarything")
sys.path.append("plotting")
sys.path.append("postgres")
sys.path.append("surface")
import common
import librarything
import plotting
import postgres
import surface

def create_library_database(configuration, file):
    schema = postgres.Schema(database, configuration["prod"]["schema_name"])
    table = postgres.Table(schema, configuration["prod"]["table_name"])
    # Log into bootstrapping environment to create production database.
    connection_settings = postgres.extract_connection_settings(configuration["bootstrap"])
    postgres.create_database(connection_settings, database)
    # Switch to production and create the schema.
    connection_settings = postgres.extract_connection_settings(configuration["prod"])
    postgres.create_schema(connection_settings, schema)
    # Create the table in the library schema.
    librarything.create_empty_bookstack(connection_settings, table)
    # Load the data into the table.
    librarything.import_bookstack(connection_settings, file, table)
    # Convert the length measurement fields.
    librarything.convert_measure_fields(connection_settings, table, ["height", "thickness", "width"], "inch", "_str")
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...