import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/librarything")
sys.path.append("python/packages/plotting")
sys.path.append("python/packages/postgres")
import librarything
import plotting
import postgres

configuration = postgres.load_postgres_configuration(tranches=["config",
                                                          "credentials"])

database = postgres.Database(configuration["prod"]["database_name"])
schema = postgres.Schema(database, configuration["prod"]["schema_name"])
table = postgres.Table(schema, configuration["prod"]["table_name"])

# Log into bootstrapping environment to create production database.
connection_settings = postgres.extract_connection_settings(configuration["bootstrap"])
# Wrapper for idempotent development re-runs.
if not postgres.database_exists(connection_settings, database):
    postgres.create_database(connection_settings, database)

# Switch to production and create the schema.
connection_settings = postgres.extract_connection_settings(configuration["prod"])

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
export_data_frame = plotting.data_to_data_frame(data, ["height", "width", "thickness", "count"])

plot = plotting.create_interpolated_plot(data)





# To force the last line up above the horizontal scrollbar, because Eclipse has
# a decade-plus-old bug w.r.t. this.