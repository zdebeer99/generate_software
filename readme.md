# Software Generator

2021-08-14

This project is a simple code guide to quickly generate code using python and jinja. The combination allows full flexibility with a very simple setup.

## Quick use

Clone the report

Requires Python 3

pip install Jinja2
pip install jinja2-stringcase
pip install openpyxl

python3 example1.py

python3 gen-app.py

## Variable structure available for templates 

The meta data can be set in excel or a csv file. By default the there is a tables sheet and a fields sheet.

**Tables Sheet**

* name
* description

**Fields Sheet**

* table  - Table Name
* name - Field Name
* dbtype - Database Type
* size - Database Type Size
* required - bool true/false
* key - bool true/false
* elmtype - type in client app

## Available Templates

**elm**

Generates an elm application that use postgrest to call on the database.

**sql**

generates tables and postgrest functions for postgresql.


## Variables available in template

variables are set in the rendering step, this can be custimezed as required.

## Build in functions and filters

**list_fmt**

Format each string item in a list.

**today**

todays date

**pg_table_definition**

Creates a field type, relation and conditions for a create table sql function

**pg_type**

Converts serial postgresql type to an int

**elm_to_string**

Converts a elm type value to a string for example a elm type Int will return String.fromInt

**elm_to_default_value**

Genrates a default values for example and elm type Int will return 0


**Case filters**

Use as a filter for example;

```jinja2
 {{"hello_world"|pascalcase}}
```

* camelcase 
* capitalcase 
* constcase 
* lowercase 
* pascalcase 
* pathcase 
* sentencecase 
* snakecase 
* spinalcase 
* titlecase 
* trimcase 
* uppercase 
* alphanumcase 

https://github.com/ufranske/jinja2_stringcase

**Custom functions**

Custom functions can be added using the following code.

```python

meta = gencode.load_from_xlsx('metadata.xlsx')
meta.jinja2.globals["custom_function"] = custom_function

```

## Resources

**Template Library Jinja**

https://jinja.palletsprojects.com/en/2.11.x/


**Loading Meta Data**

**Excel Documents**

pip install openpyxl

https://openpyxl.readthedocs.io/en/stable/usage.html


**csv files**

https://realpython.com/python-csv/

```python
import csv

with open('employee_birthday.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            print(f'Column names are {", ".join(row)}')
            line_count += 1
        else:
            print(f'\t{row[0]} works in the {row[1]} department, and was born in {row[2]}.')
            line_count += 1
    print(f'Processed {line_count} lines.')

```

