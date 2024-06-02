# zdebeer 2021-08-14
# Collection of cuntions that can be used in a template for assiting in transforming values to the required text.

def list_format(items, fmt):
    """format each item in a list"""
    out = []
    for i in items:
        out.append(fmt.format(i))
    return out

# Postgres specific helpers


def pg_type(dbtype):
    """fix tabel definition types like 'serial' to be used in functions, etc."""
    if dbtype == "serial":
        return "int"
    if dbtype == "bigserial":
        return "bigint"
    return dbtype


def pg_table_definition(row):
    """Create a table type definition."""
    allownull = " NOT NULL"
    if row.allownull:
        allownull = ""
    return postgresql_table_type(row.table_type, row.size)+allownull+postgresql_ref(row.ref)


def postgresql_table_type(dbtype, size):
    """Converts a postgresql dbtype and size into create table type definition."""
    if len(size) > 0:
        dbtype = "{0}({1})".format(dbtype, size)
    return dbtype


def postgresql_ref(ref):
    """Converts a string to a postgresql reference create table type definition."""
    if len(ref) > 0:
        tokens = ref.split(".")
        if len(tokens) < 2:
            tokens.append("id")
        return " REFERENCES {0}({1})".format(tokens[0], tokens[1])
    return ""


# elm specific helpers

def elm_to_string(elmtype, value):
    """Converts a type to a String"""
    if elmtype == "Char":
        return "(String.fromChar {0})".format(value)
    if elmtype == "Float":
        return "(String.fromFloat {0})".format(value)
    if elmtype == "Int":
        return "(String.fromInt {0})".format(value)
    if elmtype == "List":
        return "(String.fromList {0})".format(value)
    if elmtype == "String":
        return value
    return "({0}.toString {1})".format(elmtype, value)


def elm_to_default_value(elmtype):
    """Converts a type to a default value"""
    if elmtype == "Float":
        return "0"
    if elmtype == "Int":
        return "0"
    if elmtype == "List":
        return "[]"
    if elmtype == "String":
        return '""'
    return "elmtype.default"
