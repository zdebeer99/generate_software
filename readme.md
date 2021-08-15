Software Generator

This project is a simple code guide to quickly generate code using python and jinja. The combination allows full flexibility with a very simple setup.

## Variable structure available for templates 

**Tables**

* name
* description

**Fields**

* table  - Table Name
* name - Field Name
* dbtype - Database Type
* size - Database Type Size
* required - bool true/false
* key - bool true/false
* elmtype - type in client app

## Exanmple of Usage

Generate a file per table;



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

## Python Dependencies

pip install openpyxl
pip install Jinja2