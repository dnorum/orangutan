"""A collection of tools for handling 2.5D surfaces of the form (x, y, f(x, y)).

Shelf sizes (depth, height, total length) depend on book dimensions (width,
height, and total thickness, respectively).
"""

class Range:
    """A minimum and a maximum value for a value or dimension."""
    # TODO: Add ", inclusive=True, continuous=False, interval=0"
    def __init__(self, min, max):
        self.min = min
        self.max = max

