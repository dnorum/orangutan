import pathlib

from context import orangutan

from orangutan import common
from orangutan import librarything
from orangutan import plotting
from orangutan import postgres
from orangutan import surface

dir = pathlib.Path(__file__).parent.resolve()
configuration = common.load_json_configurations(
    [f"{dir}/config/postgres_dnorum.json",
    f"{dir}/credentials/postgres_dnorum.json"])
database = postgres.Database(configuration["prod"]["database_name"])
schema = postgres.Schema(database, configuration["prod"]["schema_name"])
table = postgres.Table(schema, configuration["prod"]["table_name"])

# Pull out the dimensional data for plotting and fitting.
connection_settings = postgres.extract_connection_settings(configuration["prod"])
export = librarything.export_dimensional_data(connection_settings, table, "discrete")

# Prune - need to push this back upstream...
for bin in export:
    if bin.height >= 100 or bin.height < 2 or bin.width < 1:
        export.remove(bin)

data = librarything.export_to_data(export)

height_min = 100
height_max = 0
width_min = 100
width_max = 0
for datum in data:
    if datum[0] < height_min:
        height_min = datum[0]
    if datum[0] > height_max:
        height_max = datum[0]
    if datum[1] < width_min:
        width_min = datum[1]
    if datum[1] > width_max:
        width_max = datum[1]

print(height_min)
print(height_max)
print(width_min)
print(width_max)

ranges = [surface.Range(min=height_min, max=height_max, inclusive=True, continuous=False, interval=0.0625),
          surface.Range(min=width_min, max=width_max, inclusive=True, continuous=False, interval=0.0625)]
grid = surface.grid_from_ranges(ranges)
interpolated_grid = surface.interpolate_to_grid(data, 2, grid)

interpolated_surface = surface.Surface(ranges=ranges, points=interpolated_grid)
extrema = surface.find_extrema(interpolated_surface)

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