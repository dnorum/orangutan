import sys

# Set up manual importing of under-development packages from within the repo.
sys.path.append("python/packages/librarything")
sys.path.append("python/packages/plotting")
sys.path.append("python/packages/postgres")
sys.path.append("python/packages/surface")
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

# Main testing portion.
configuration = postgres.load_postgres_configuration(tranches=["config",
                                                          "credentials"])
database = postgres.Database(configuration["prod"]["database_name"])
schema = postgres.Schema(database, configuration["prod"]["schema_name"])
table = postgres.Table(schema, configuration["prod"]["table_name"])
#create_library_database(configuration, "data/librarything_dnorum.csv")

# Pull out the dimensional data for plotting and fitting.
connection_settings = postgres.extract_connection_settings(configuration["prod"])
export = librarything.export_dimensional_data(connection_settings, table, "discrete")

# Prune - need to push this back upstream...
for bin in export:
    if bin.height >= 100:
        export.remove(bin)

# Plot!
data = librarything.export_to_data(export)

foo = surface.Range(min=0, max=1, inclusive=False, continuous=False, interval=0.1)

print(str(0.1))

print(foo.expand())

#export_data_frame = plotting.data_to_data_frame(data, ["height", "width", "thickness", "count"])

#plot = plotting.create_interpolated_plot(data)





# Eclipse scrollbar...