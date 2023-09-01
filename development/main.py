import pathlib

from context import orangutan

from orangutan import common
from orangutan import librarything
from orangutan import plotting
from orangutan import postgres
from orangutan import surface

dir = pathlib.Path(__file__).parent.resolve()
configuration = common.load_json_configurations(
    [f"{dir}/config/postgres.json",
    f"{dir}/credentials/postgres.json"])
database = postgres.Database(configuration["prod"]["database_name"])
schema = postgres.Schema(database, configuration["prod"]["schema_name"])
table = postgres.Table(schema, configuration["prod"]["table_name"])

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

extrema = surface.find_extrema(surface.Surface(ranges=ranges,
                                               points=interpolated_grid))

print(extrema)

#plot = plotting.create_plot(interpolated_grid, ["height", "width", "thickness"])

#plot.draw(show=True)
#plot.save("workspace/plot.png")
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...