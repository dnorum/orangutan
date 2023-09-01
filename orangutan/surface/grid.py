import fractions
import math

def range(data_1d, discretize=False, max_denominator=None, strict=False):
    """Given a one-dimensional array of numbers, return the range.
    
    """
    # Check for data_1d.
    values = sorted(data_1d)
    min = values[0]
    max = values[-1]
    if not discretize:
        return Range(min=min, max=max, inclusive=True, continuous=True)
    if discretize:
        interval_possible = fractions.Fraction(max - min)
        for value in values[1:]:
            delta = fractions.Fraction(value - min)
            # Put the current possible interval and the offset from the min into
            # the same denominator, then find the GCD of their new numerators.
            denominator = interval_possible.denominator * delta.denominator
            numerator = math.gcd(
                interval_possible.numerator * delta.denominator, 
                delta.numerator * interval_possible.denominator)
            cancellation = math.gcd(denominator, numerator)
            numerator = numerator / cancellation
            denominator = denominator / cancellation
            if max_denominator != None and denominator > max_denominator:
                return Range(min=min, max=max, inclusive=True, continuous=True)
            interval_possible = fractions.Fraction(str(int(numerator)) + '/' +
                                                   str(int(denominator)))
        interval = interval_possible.numerator / interval_possible.denominator
        result = Range(min=min, max=max, inclusive=True, continuous=False,
                       interval=interval)
        if strict:
            rederived_values = result.expand()
            for value in values:
                if value not in rederived_values:
                    return Range(min=min, max=max, inclusive=True,
                                 continuous=True)
        return result
            
def grid_from_ranges(ranges):
    grid = []
    if len(ranges) == 1:
        grid = ranges[0].expand()
        return grid
    if len(ranges) > 1:
        axis = ranges[0].expand()
        subspace = grid_from_ranges(ranges[1:])
        for coordinate in axis:
            for coordinates in subspace:
                if hasattr(coordinates, "__len__"):
                    point = [coordinate].append(coordinates)
                else:
                    point = [coordinate, coordinates]
                grid.append(point)
        return grid

def find_extrema(surface):
    extrema = []
    return extrema
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...