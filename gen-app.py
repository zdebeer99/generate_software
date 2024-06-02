#!/usr/bin/env python3
import gencode
from gencode import write_file
import stringcase

meta = gencode.load_from_xlsx('metadata.xlsx')

# Generate Postgrest API Files

# a custom object can be used for app wide variables.
app = {"name": "Example App",
       "description": "",
       "version": "1",
       "baseUrl": "app"}

print('Generate SQL api files')
# gen tables

template = meta.get_template('sql/postgrest-table.sql.jinja')

for table in meta.tables:
    output = template.render(
        table=table.name,
        fields=table.fields,
        keys=[key for key in table.fields if key.key],
        no_keys=[field for field in table.fields if not field.key],
        table_meta=table)
    write_file('output/sql/schema/'+table.name+'.sql', output)

# gen schema updater

template = meta.get_template('sql/update_schema.pgsql.jinja')

output = template.render(tables=meta.tables)
write_file('output/sql/schema/update.pgsql', output)

# gen api models

template = meta.get_template('sql/postgrest-api.sql.jinja')

for table in meta.tables:
    output = template.render(
        table=table.name,
        fields=table.fields,
        keys=[key for key in table.fields if key.key],
        no_keys=[field for field in table.fields if not field.key],
        table_meta=table)
    write_file('output/sql/api/'+table.name+'.sql', output)

# gen api updater

template = meta.get_template('sql/update_api.pgsql.jinja')

output = template.render(tables=meta.tables)
write_file('output/sql/api/update.pgsql', output)


#
# Generate Elm files
#

print('Generate Elm files')

# Set programming lang specific names on the field to make access to them easier. This example is for the elm langauge.
for field in meta.fields:
    field.elm_type_func = stringcase.camelcase(field.elm_type)
    field.elm_name = stringcase.camelcase(field.name)
    field.elm_pascal = stringcase.pascalcase(field.name)
    field.elm_title = stringcase.titlecase(field.name)
    field.table_pascal_case = stringcase.pascalcase(field.table)


# helper function to create a elm file per table
def gen_elm_file_by_table(templatefile, outputpath):
    """helper function to create a elm file per table"""

    template = meta.get_template('elm/{0}.elm.jinja'.format(templatefile))

    for table in meta.tables:
        keys = [key for key in table.fields if key.key]
        output = template.render(
            table=table.name,
            fields=table.fields,
            keys=keys,
            no_keys=[field for field in table.fields if not field.key],
            table_meta=table,
            has_keys=len(keys) > 0)
        write_file(
            ('output/elm/'+outputpath).format(stringcase.pascalcase(table.name)), output)


gen_elm_file_by_table("Model", "Model/{0}.elm")
gen_elm_file_by_table("Page/Types", "Page/{0}/Types.elm")
gen_elm_file_by_table("Page/Update", "Page/{0}/Update.elm")
gen_elm_file_by_table("Page/View", "Page/{0}/View.elm")


# Write the routing file

names = []
for table in meta.tables:
    names.append(stringcase.pascalcase(table.name))

template = meta.get_template('elm/App/Route.elm.jinja')
output = template.render(app=app, tables=meta.tables, names=names)
write_file('output/elm/App/Route.elm', output)

template = meta.get_template('elm/App/Types.elm.jinja')
output = template.render(app=app, tables=meta.tables, names=names)
write_file('output/elm/App/Types.elm', output)

template = meta.get_template('elm/App/Update.elm.jinja')
output = template.render(app=app, tables=meta.tables, names=names)
write_file('output/elm/App/Update.elm', output)

template = meta.get_template('elm/App/View.elm.jinja')
output = template.render(app=app, tables=meta.tables, names=names)
write_file('output/elm/App/View.elm', output)


# Write the routing file
template = meta.get_template('elm/Main.elm.jinja')
output = template.render(app=app, tables=meta.tables, names=names)
write_file('output/elm/Main.elm', output)

# Write the config file
template = meta.get_template('elm/Shared.elm.jinja')
output = template.render(app=app)
write_file('output/elm/Shared.elm', output)

# Write the Server file
template = meta.get_template('elm/Postgrest.elm.jinja')
output = template.render(app=app)
write_file('output/elm/Postgrest.elm', output)

# Write the Server file
template = meta.get_template('elm/index.html.jinja')
output = template.render(app=app)
write_file('output/elm/index.html', output)


print('done')
