import scipy.interpolate

def split_for_interpolation(data, dimensions):
    """Split a list of tuples (x1, ..., xn, f(x1, ..., xn)) into X and f(X).
    """
    points = []
    values = []
    for datum in data:
        points.append(datum[:dimensions])
        values.append(datum[dimensions:])
    return {"points": points, "values": values}

def interpolate_to_grid(data, dimensions, grid):
    grist = split_for_interpolation(data, dimensions)
    interp = scipy.interpolate.LinearNDInterpolator(grist["points"],
                                                    grist["values"])
    interpolated_grid = []
    for point in grid:
        values = interp(point)[0]
        for value in values:
            point.append(value)
        interpolated_grid.append(point)
    return interpolated_grid
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...