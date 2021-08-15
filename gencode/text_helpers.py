# zdebeer 2021-08-14
# Collection of cuntions that can be used in a template for assiting in transforming values to the required text.

def list_format(items, fmt):
    """format each item in a list"""
    out = []
    for i in items:
        out.append(fmt.format(i))
    return out
