import sys
sys.path.append("../common")
import common

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
            precision = common.decimals(self.interval)
            count = 1
            value = self.min + count*self.interval
            value = round(value, precision)
            while value < self.max:
                values.append(value)
                value += self.interval
                value = round(value, precision)
            # Mildly inelegant, but clearer than potentially running into
            # [].insert(-1,value).
            if self.inclusive:
                values.append(self.max)
        return values

class Surface:
    def __init__(self, ranges, points):
        self.ranges = ranges
        self.points = points
        self.dimensions = len(self.ranges)
    
    def _coordinates(self):
        coordinates = []
        for point in self.points:
            coordinates.append(point[:self.dimensions])
        return coordinates
    
    def adjacent(self, point):
        coordinates = self._coordinates()
        adjacent_points = [point]
        for range_dimension, range in enumerate(self.ranges):
            jacent_points = common.copy(adjacent_points)
            for jacent_point in jacent_points:
                for shift in [-1, 1]:
                    adjacent_point = common.copy(jacent_point)
                    adjacent_point[range_dimension] += shift * range.interval 
                    adjacent_points.append(adjacent_point)
        points = common.copy(adjacent_points)
        for adjacent_point in points:
            if adjacent_point[:self.dimensions] not in coordinates:
                adjacent_points.remove(adjacent_point)       
        adjacent_points.remove(point)
        return adjacent_points
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...