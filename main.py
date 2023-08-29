import json
import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/librarything")
sys.path.append("python/packages/postgres")
sys.path.append("python/packages/vermeer")
import librarything
import postgres
import vermeer

postgres = {}

for tranche in ("config", "credentials"):
    with open(f"{tranche}/postgres.json") as json_file:
        json_data = json.load(json_file)
    for stage in json_data:
        if stage not in postgres:
            postgres[stage] = {}
        postgres[stage] = {**postgres[stage], **json_data[stage]}

database = postgres.Database(postgres["prod"]["database_name"])
schema = postgres.Schema(database, postgres["prod"]["schema_name"])
table = postgres.Table(schema, postgres["prod"]["table_name"])

# Log into bootstrapping environment to create production database.
connection_settings = postgres.extract_connection_settings(postgres["bootstrap"])
# Wrapper for idempotent development re-runs.
if not postgres.database_exists(connection_settings, database):
    postgres.create_database(connection_settings, database)

# Switch to production and create the schema.
connection_settings = postgres.extract_connection_settings(postgres["prod"])

# Ensure that there's no cruft left over from previous development runs.
postgres.drop_schema_if_exists(connection_settings, schema)

# Wrapper for idempotent development re-runs.
if not postgres.schema_exists(connection_settings, schema):
    postgres.create_schema(connection_settings, schema)

# Create the table in the library schema.
# Wrapper for idempotent development re-runs.
if not postgres.table_exists(connection_settings, table):
    librarything.create_empty_bookstack(connection_settings, table)

# Load the data into the table.
librarything.import_bookstack(connection_settings, "data/librarything_dnorum.csv", table)

# Convert the length measurement fields.
librarything.convert_measure_fields(connection_settings, table, ["height", "thickness", "width"], "inch", "_str")

# Pull out the dimensional data for plotting and fitting.
export = librarything.export_dimensional_data(connection_settings, table, "discrete")

# Prune - need to push this back upstream...
for bin in export:
    if bin.height >= 100:
        export.remove(bin)

# Plot!
data = librarything.export_to_data(export)
export_data_frame = vermeer.data_to_data_frame(data, ["height", "width", "thickness", "count"])

plot = vermeer.create_interpolated_plot(data)


# To force the last line up above the horizontal scrollbar, because Eclipse has
# a decade-plus-old bug w.r.t. this.