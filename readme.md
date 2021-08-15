Software Generator

This project is a simple code guide to quickly generate code using python and jinja. The combination allows full flexibility with a very simple setup.

## Quick use

Clone the report

Requires Python 3

pip install jinja2-stringcase
pip install openpyxl
pip install Jinja2

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

## Example of Usage

See examples

## Build in functions and filters

**list_fmt**

Format each string item in a list.

**Case filters**

Use as a filter for example {{"hello_world"|pascalcase}}

https://github.com/ufranske/jinja2_stringcase

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

