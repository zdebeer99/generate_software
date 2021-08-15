#!/usr/bin/env python3
# zdebeer 2021-08-14 Starting script that generates the projects files
import gencode

meta = gencode.load_from_xlsx('metadata.xlsx')

for table in meta.tables:
    print("Table: "+table.name)
    for field in table.fields:
        print(" - "+field.name)
