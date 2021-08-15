
# Excel document Helper Functions

def default(row, index) -> str:
    """If a index out of range occurs return a empty string."""
    if len(row) > index:
        return row[index]
    return ''
