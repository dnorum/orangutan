"""Oddball, niche, and/or commonly reused (here, at least) numerical functions.

A collection of functions that deal with numbers or numerical data and:
    - Are used in multiple subpackages, or
    - _Might_ realistically be used in multiple subpackages; and
    
    - Are longer than a single, straightforward line of code, or
    - Require some sort of specific error-handling or checking, or
    - Do weird, un-numberly things to numbers, like converting a float into a
        string and then counting digits backwards to figure out how many decimal
        places it has.

Typical usage examples:

    grid_precision = decimals(range.interval)
"""

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
        # docstring API specifies integer or float, but... goofers gonna goof.
        raise TypeError(f"Number ({number}) must be integer or float, not "
                         f"{type(number)}.")
    if isinstance(number, float):
        return str(number)[::-1].find('.')
    # No idea how you might get here, but just in case.
    raise RuntimeError(f"{__name__}.decimals: number seems to be neither an "
                       "int nor a float, AND not-NOT a float.")
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...