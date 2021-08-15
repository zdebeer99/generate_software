/*
Code generated using gnorm.

postgrest api crud functions for table {{table.name}}

{{table.description}}

*/


GRANT ALL ON TABLE public.{{table.name}} TO web_user;
{%-for keyC in keys %}
GRANT USAGE, SELECT ON SEQUENCE public.{{table.name}}_{{keyC.name}}_seq TO web_user;
{%-endfor%}

DROP FUNCTION IF EXISTS api.{{table.name}}_list(int);
DROP FUNCTION IF EXISTS api.{{table.name}}_get({{list_fmt(keys,"{.dbtype}")|join(',')}});
DROP FUNCTION IF EXISTS api.{{table.name}}_page_count();
DROP FUNCTION IF EXISTS api.{{table.name}}_update({{list_fmt(fields,"{.dbtype}")|join(',')}});
DROP FUNCTION IF EXISTS api.{{table.name}}_create({{list_fmt(fields,"{.dbtype}")|join(',')}});
DROP FUNCTION IF EXISTS api.{{table.name}}_delete({{list_fmt(keys,"{.dbtype}")|join(',')}});


/* {{table.name}}_list

List {{table.name}}s

select * from api.{{table.name}}_list(0)

*/
CREATE FUNCTION api.{{table.name}}_list(IN page int)
RETURNS TABLE
    ( {{ list_fmt(fields, "{0.name} {0.dbtype}")|join('\n    , ') }}
    )
AS $$

  SELECT {{ list_fmt(fields, "{0.name}")|join('\n    , ') }}
  FROM public.{{table.name}}
  OFFSET ({{table.name}}_list.page * api.const_page_size()) LIMIT api.const_page_size();

$$ LANGUAGE SQL STABLE;
COMMENT ON FUNCTION api.{{table.name}}_list(int) IS
'Return a list {{table.name}}s by page.';
GRANT EXECUTE ON FUNCTION api.{{table.name}}_list(int) TO web_user;


/* {{table.name}}_page_count

Count the number of pages that {{table.name}}_list will return.

select * from api.{{table.name}}_page_count()

*/
CREATE FUNCTION api.{{table.name}}_page_count()
RETURNS int
AS $$

  SELECT ceil(count(*)::decimal / api.const_page_size())::int AS result FROM public.{{table.name}};

$$ LANGUAGE SQL STABLE;
COMMENT ON FUNCTION api.{{table.name}}_page_count() IS
'Count the number of pages that will be returned by {{table.name}}_list';
GRANT EXECUTE ON FUNCTION api.{{table.name}}_page_count() TO web_user;


/* {{table.name}}_get

List {{table.name}}s

select * from api.{{table.name}}_get(0)

*/
CREATE FUNCTION api.{{table.name}}_get({{list_fmt(keys,"IN {0.name} {0.dbtype}")|join(', ')}})
RETURNS TABLE
  ( {{ list_fmt(fields, "{0.name} {0.dbtype}")|join('\n  , ') }}
  )
AS $$

  SELECT {{ list_fmt(fields, "{0.name}")|join(',\n    ') }}
  FROM public.{{table.name}}
  WHERE {{list_fmt(keys,"{0.name} = {0.table}_get.{0.name}")|join('\n AND ')}};

$$ LANGUAGE SQL STABLE;
COMMENT ON FUNCTION api.{{table.name}}_get({{list_fmt(keys,"{.dbtype}")|join(',')}}) IS
'Return a single {{table.name}} detail';
GRANT EXECUTE ON FUNCTION api.{{table.name}}_get({{list_fmt(keys,"{.dbtype}")|join(',')}}) TO web_user;


/* {{table.name}}_update

update a {{table.name}}

*/
CREATE FUNCTION api.{{table.name}}_update
  ( {{ list_fmt(fields, "{0.name}_arg {0.dbtype}")|join('\n  , ') }}
  ) RETURNS TABLE
  ( {{ list_fmt(fields, "{0.name} {0.dbtype}")|join('\n  , ') }}
  )
AS $$
  DECLARE 
{%-for keyC in keys %}
  {{keyC.name}}_var {{keyC.dbtype}};
{%-endfor%}  
  BEGIN

  UPDATE public.{{table.name}} SET {{ list_fmt(no_keys, "{0.name} = {0.table}_update.{0.name}_arg")|join(',\n    ') }}
  WHERE {{list_fmt(keys,"{0.name} = {0.table}_update.{0.name}_arg")|join('\n    AND ')}}
  RETURNING {{ list_fmt(keys, "{0.name} INTO {0.name}_var")|join('\n  , ') }};

  RETURN QUERY SELECT * FROM api.{{table.name}}_get({{list_fmt(keys, "{0.name}_var")|join(',')}});

  END
$$ LANGUAGE PLPGSQL;
COMMENT ON FUNCTION api.{{table.name}}_update({{list_fmt(fields,"{.dbtype}")|join(',')}}) IS
'update a {{table.name}}';
GRANT EXECUTE ON FUNCTION api.{{table.name}}_update({{list_fmt(fields,"{.dbtype}")|join(',')}}) TO web_user;


/* {{table.name}}_create

create a new {{table.name}} record.

*/
CREATE FUNCTION api.{{table.name}}_create
( {{ list_fmt(fields, "{0.name}_arg {0.dbtype}")|join('\n  , ') }}
) RETURNS TABLE
( {{ list_fmt(fields, "{0.name} {0.dbtype}")|join('\n  , ') }}
)
AS $$
  DECLARE 
{%-for keyC in keys %}
  {{keyC.name}}_var {{keyC.dbtype}};
{%-endfor%}  
  BEGIN

  INSERT INTO public.{{table.name}}
  ( {{ list_fmt(no_keys, "{0.name}")|join('\n  , ') }}
  )
  VALUES
  ( {{ list_fmt(no_keys, "{0.table}_create.{0.name}_arg")|join('\n  , ') }}
  )
  RETURNING {{ list_fmt(keys, "{0.name} INTO {0.name}_var")|join('\n  , ') }};

  RETURN QUERY SELECT * FROM api.{{table.name}}_get({{list_fmt(keys, "{0.name}_var")|join(',')}});
  
  END
$$ LANGUAGE PLPGSQL;
COMMENT ON FUNCTION api.{{table.name}}_create({{list_fmt(fields,"{.dbtype}")|join(',')}}) IS
'create a new {{table.name}} record.';
GRANT EXECUTE ON FUNCTION api.{{table.name}}_create({{list_fmt(fields,"{0.dbtype}")|join(',')}}) TO web_user;


/* {{table.name}}_delete

List {{table.name}}s

select api.{{table.name}}_delete(0)

*/
CREATE FUNCTION api.{{table.name}}_delete({{list_fmt(keys,"IN {0.name} {0.dbtype}")|join(',')}})
RETURNS void AS $$

  DELETE FROM public.{{table.name}}
  WHERE {{list_fmt(keys,"{0.name} = {0.table}_delete.{0.name}")|join('\n    AND ')}};

$$ LANGUAGE SQL;
COMMENT ON FUNCTION api.{{table.name}}_delete({{list_fmt(keys,"{.dbtype}")|join(',')}}) IS
'Delete a {{table.name}}';
GRANT EXECUTE ON FUNCTION api.{{table.name}}_delete({{list_fmt(keys,"{.dbtype}")|join(',')}}) TO web_user;
