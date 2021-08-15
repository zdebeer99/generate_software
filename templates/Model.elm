module Model.{{table|pascalcase}} exposing
    ( {{table|pascalcase}}
    , rpcCreate
    , rpcDelete
    , rpcGet
    , rpcList
    , rpcUpdate
    )

{- Generated file for use with postgrest sql api functions.

# Model for sql table {{table}}

{{table_meta.description}}

## type

@docs {{table|pascalcase}}

## api calls

@docs rpcCreate, rpcDelete, rpcGet, rpcList, rpcUpdate

 -}

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (required)
import Json.Encode as E
import Postgrest.Client as P
import Server as S
import Time exposing (Posix)
import Util.Date exposing (decodePosix, encodePosix)


type alias {{table|pascalcase}} =
    { {{ list_fmt(fields, "{0.elm_name} : {0.elm_type}")|join('\n    , ') }}
    }

--# Api


{-| rpcList jwt result aPage

Return a list of rows from table {{table}}.

Arguments;

* jwt - Auhtorisation token
* result - a Msg that will return a list of records if the api call was successful
* aPage - The page number of the list of items to load. Each page should contain about 50 items.

Example:
    rpcList jwt TableResult 0

-}
rpcList : P.JWT -> (Result P.Error (List {{table|pascalcase}}) -> msg) -> Int -> Cmd msg
rpcList jwt result aPage =
    S.pgGet jwt "{{table}}_list" result decode{{table|pascalcase}}View [ ( "page", P.int aPage ) ]


{-| rpcGet jwt result {{list_fmt(keys, "a{0.elm_pascal}")|join(' ') }}

get a single item from the database.

Arguments;

* jwt - Auhtorisation token
* result - a Msg that will return a list of records if the api call was successful
* {identification} - primary key to identify the record.

Example:
    rpcGet jwt RowResult 1

-}
rpcGet : P.JWT -> (Result P.Error {{table|pascalcase}} -> msg) -> {{list_fmt(keys, "{0.elm_type}")|join(' -> ') }} -> Cmd msg
rpcGet jwt result {{list_fmt(keys, "a{0.elm_pascal}")|join(' ') }} =
    S.pgGetOne jwt "{{table}}_get" result decode{{table|pascalcase}}View [ {{list_fmt(keys, '( "{0.name}", P.{0.elm_type_func} a{0.elm_pascal})')|join('\n    , ') }} ]


{-| rpcUpdate jwt result a{{table|pascalcase}}

Update a single record

-}
rpcUpdate : P.JWT -> (Result P.Error {{table|pascalcase}} -> msg) -> {{table|pascalcase}} -> Cmd msg
rpcUpdate jwt result a{{table|pascalcase}} =
    S.pgPostOne jwt "{{table}}_update" result decode{{table|pascalcase}}View (encode{{table|pascalcase}}View a{{table|pascalcase}})


{-| rpcCreate jwt result a{{table|pascalcase}}

Create a new record

-}
rpcCreate : P.JWT -> (Result P.Error {{table|pascalcase}} -> msg) -> {{table|pascalcase}} -> Cmd msg
rpcCreate jwt result a{{table|pascalcase}} =
    S.pgPostOne jwt "{{table}}_create" result decode{{table|pascalcase}}View (encode{{table|pascalcase}}View a{{table|pascalcase}})


{-| rpcDelete jwt result {{list_fmt(keys, "a{0.elm_pascal}")|join(' ') }}

Delete a record

-}
rpcDelete : P.JWT -> (Result P.Error Int -> msg) -> {{list_fmt(keys, "{0.elm_type}")|join(' -> ') }} -> Cmd msg
rpcDelete jwt result {{list_fmt(keys, "a{0.elm_pascal}")|join(' ') }} =
    S.pgPostOne jwt "{{table}}_delete" result D.int (E.object [ {{list_fmt(keys, '( "{0.name}", E.{0.elm_type_func} a{0.elm_pascal})')|join('\n    , ') }} ])

{-|
encode a {{table|pascalcase}} record for use in a {{table}}_create and {{table}}_update sql function.
-}
encode{{table|pascalcase}}View : {{table|pascalcase}} -> E.Value
encode{{table|pascalcase}}View r1 =
    E.object
        [ {{ list_fmt(fields, '("{0.name}_arg", E.{0.elm_type_func} r1.{0.elm_name} )')|join('\n        , ') }}
        ]


decode{{table|pascalcase}}View : Decoder {{table|pascalcase}}
decode{{table|pascalcase}}View =
    D.succeed {{table|pascalcase}}
        {{ list_fmt(fields, '|> required "{0.name}" D.{0.elm_type_func}')|join('\n        ') }}
