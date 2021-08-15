#!/usr/bin/env python3
import gencode


meta = gencode.load_from_xlsx('metadata.xlsx')

# Generate Postgrest API Files


template = meta.get_template("postgrest-api.sql")
for table in meta.tables:
    output = template.render(
        table=table,
        fields=table.fields,
        keys=[key for key in table.fields if key.key],
        no_keys=[field for field in table.fields if not field.key])
    gencode.write_file('output/sql/{0}.sql'.format(table.name), output)
