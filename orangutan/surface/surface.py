"""A collection of tools for handling 2.5D surfaces of the form (x, y, f(x, y)).

Shelf sizes (depth, height, total length) depend on book dimensions (width,
height, and total thickness, respectively).
"""

import fractions
import math
import numbers
#import numpy
import scipy.interpolate

class Range:
    """The allowable or observed values for a variable.
    
    Attributes:
        min:
            The smallest value allowable or observed. Must be strictly less
            than max, unless inclusive=True, in which case it may equal max. 
        max:
            The largest value allowable or observed. Must be strictly greater
            than min, unless inclusive=True, in which case it may equal min.
        inclusive:
            Boolean indicating whether or not the variable may be equal to min
            or max, or strictly greater or less than (respectively). Defaults
            to False.
        continuous:
            Boolean indicating whether or not the variable is continuous. If
            continuous=False, then the following conditions must hold: (1)
            interval is positive, (2) (min-max) % interval == 0. Defaults to
            False.
        interval:
            The quantum of measurement for the variable. If continuous=True,
            then interval should be ignored. (Currently required to be 0 in
            these cases.) Defaults to 0 (cf. continuous=False). 
    """
    
    def __init__(self, min, max, inclusive=True, continuous=False, interval=0):
        """Initializes the range based on the min and max supplied.
        
        Args:
            min: The smallest value allowable or observed.
            max: The largest value allowable or observed.
            inclusive: Defines if the instance is inclusive or exclusive.
            continuous: Defines if the instance is continuous or discrete.
            interval: Defines the quantum for discrete instances.  
        """
        self.min = min
        self.max = max
        self.inclusive = inclusive
        self.continuous = continuous
        self.interval = interval
        
        # Check for internal consistency.
        if self.min > self.max:
            raise ValueError(f"Maximum ({self.max}) must be greater than "
                             f"minimum ({self.min}).")
        if self.min == self.max and not inclusive:
            raise ValueError(f"Maximum ({self.max}) and minimum ({self.min}) "
                             "may only be equal when inclusive=True.")
        if continuous:
            if interval != 0:
                raise ValueError(f"Non-zero ({self.interval}) interval is "
                                 "prohibited for continuous ranges.")
        elif not continuous:
            if interval <= 0:
                raise ValueError("Discrete ranges require a positive "
                                 f"interval; {self.interval} specified.")
            n = (self.max - self.min) / interval
            if not n.is_integer():
                raise ValueError("max-min must be an integer multiple of "
                                 f"interval for discrete ranges: ({self.max} - "
                                 f"{self.min}) / {self.interval} = {n}")
    
    def __str__(self):
        return (f"min={self.min}, max={self.max}, inclusive={self.inclusive}, "
                f"continuous={self.continuous}, interval={self.interval}")
    
    def expand(self):
        """For a discrete range, returns the possible values from min to max.
        
        Returns:
            An array of values evenly spaced by the interval of the range, from
            min to max in order. If inclusive=True, then the first element will
            be min and the last max; if inclusive=False, then the first element
            will be min+interval and the last will be max-interval.
            
            (If inclusive=False and either min=max or min+interval=max, an
            empty array will be returned.)
            
            For example, with min=0, max=3, inclusive=True, and interval=1:
            [0, 1, 2, 3]
            
            With inclusive=False:
            [1, 2]
        """
        if self.continuous:
            raise ValueError("Cannot expand continuous range.")
        if not self.continuous:
            if self.inclusive:
                values = [self.min]
            else:
                values = []
            # Iterated addition of floating points can lead to weirdness, so
            # we extract the number of decimal points from the interval and use
            # it to round off the points as they're calculated..
            precision = decimals(self.interval)
            count = 1
            value = self.min + count*self.interval
            value = round(value, precision)
            while value < self.max:
                values.append(value)
                value += self.interval
                value = round(value, precision)
            if self.inclusive:
                values.append(self.max)
        return values

class Surface:
    def __init__(self, ranges, points):
        self.ranges = ranges
        self.points = points
    
    def adjacent(self, point):
        pass

def decimals(number):
    """Given a number, return the number of decimal places it has.
    
    Args:
        number: An integer or floating point number.
    
    Returns:
        0 for an integer or the number of digits after the decimal point for a
        floating point number.
    """
    if isinstance(number, int):
        return 0
    if not isinstance(number, float):
        raise ValueError(f"Number ({number}) must be integer or float, not "
                         f"{type(number)}.")
    if isinstance(number, float):
        return str(number)[::-1].find('.')

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
        interval_possible = interval_possible.numerator / interval_possible.denominator
        result = Range(min=min, max=max, inclusive=True, continuous=False,
                       interval=interval_possible)
        if strict:
            rederived_values = result.expand()
            for value in values:
                if value not in rederived_values:
                    return Range(min=min, max=max, inclusive=True, continuous=True)
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
    interp = scipy.interpolate.LinearNDInterpolator(grist["points"], grist["values"])
    interpolated_grid = []
    for point in grid:
        values = interp(point)[0]
        for value in values:
            point.append(value)
        interpolated_grid.append(point)
    return interpolated_grid

def find_extrema(surface):
    pass





# Eclipse scrollbar...