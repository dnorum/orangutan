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
# 1
# 2
# 3
# 4
# 5
# Eclipse scrollbar...