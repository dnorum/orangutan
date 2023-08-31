import sys

# Set up manual importing of under-development package from within the repo.
sys.path.append("orangutan")
import orangutan
from orangutan import postgres
from orangutan import plotting
import orangutan.librarything.librarything as librarything
import orangutan.surface.surface as surface

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

data = librarything.export_to_data(export)
ranges = [surface.Range(min=0, max=24, inclusive=True, continuous=False, interval=0.0625),
          surface.Range(min=0, max=24, inclusive=True, continuous=False, interval=0.0625)]
grid = surface.grid_from_ranges(ranges)
interpolated_grid = surface.interpolate_to_grid(data, 2, grid)
plot = plotting.create_plot(interpolated_grid, ["height", "width", "thickness"])

plot.draw(show=True)
plot.save("workspace/plot.png")





# Eclipse scrollbar...