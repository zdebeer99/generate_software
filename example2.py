#!/usr/bin/env python3
import gencode
import stringcase

meta = gencode.load_from_xlsx('metadata.xlsx')

# Generate Postgrest API Files

# a custom object can be used for app wide variables.
app = {"name": "Example 2",
       "description": "",
       "version": "1",
       "baseUrl": "example2"}

"""Generate postgrest functions"""
template = meta.get_template("sql/postgrest-api.sql.jinja")
for table in meta.tables:
    output = template.render(
        table=table,
        fields=table.fields,
        keys=[key for key in table.fields if key.key],
        no_keys=[field for field in table.fields if not field.key])
    gencode.write_file('output/sql/{0}.sql'.format(table.name), output)


"""Set programming lang specific names on the field to make access to them easier. This example is for the elm langauge."""
for field in meta.fields:
    field.elm_type_func = stringcase.camelcase(field.elm_type)
    field.elm_name = stringcase.camelcase(field.name)
    field.elm_pascal = stringcase.pascalcase(field.name)
    field.elm_title = stringcase.titlecase(field.name)
    field.table_pascal_case = stringcase.pascalcase(field.table)


"""Generate elm model function and encoders"""
template = meta.get_template("elm-example2/Model.elm.jinja")
for table in meta.tables:
    output = template.render(
        table=table,
        model=stringcase.pascalcase(table.name),
        fields=table.fields,
        keys=[key for key in table.fields if key.key],
        no_keys=[field for field in table.fields if not field.key])
    gencode.write_file('output/elm/Model/{0}.elm'.format(table.name), output)


"""Generate elm model function and encoders"""
template = meta.get_template("elm-example2/View.elm.jinja")
for table in meta.tables:
    output = template.render(
        table=table,
        model=stringcase.pascalcase(table.name),
        fields=table.fields,
        keys=[key for key in table.fields if key.key],
        no_keys=[field for field in table.fields if not field.key])
    gencode.write_file('output/elm/Page/{0}.elm'.format(table.name), output)
