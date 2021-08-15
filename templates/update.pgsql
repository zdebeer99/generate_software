/*
update script for generated code.
psql -U postgres -h localhost -f update.pgsql -q
*/


\qecho 'postgrest crud functions'
\qecho '---'

{% for table in tables %}

\qecho 'Table {{table.name}} postgrest crud functions.'
\i ./sql/api/{{table.name}}.sql
{%- endfor %}
