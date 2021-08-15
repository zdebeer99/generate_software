module Page.{{table|pascalcase}} exposing (view, update, init, Model, Msg)

import Html exposing (Html, div, span, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Model.{{table|pascalcase}} as {{table|pascalcase}} exposing ({{table|pascalcase}})
import Postgrest.Client as P
import Shared.Indicator exposing (Indicator(..), isBusy, isLoading, setBusy, setIndicatorOff, setLoading)
import UIBootstrap.Buttons as Button
import UIBootstrap.Edit as Edit
import UIBootstrap.Notification as Notification
import UIBootstrap.TableView as TableView
import Util.Http exposing (httpErrorToText)
import Config exposing (Config)


--# View Table

view : Model -> Html Msg
view model =
    div []
        [ viewBusy model
        , viewLoading model
            (case model.edit of
                Just editItem ->
                    viewEdit editItem
                        |> Html.map MsgEdit
                Nothing ->
                    viewTable model
            )
        , viewDialog model.dialog
        ]

viewTable : Model -> Html Msg
viewTable model =
    div []
        [ text "{{table|titlecase}}"
        , Button.btn [] CreateItem "add"
        , TableView.tableView [] tableConfig model.data
        ]

tableConfig : TableView.Config {{table|pascalcase}} Msg
tableConfig =
    TableView.defaultConfig
        [ {{ list_fmt(fields, '("{0.elm_title}", TableView.cell{0.elm_type} .{0.elm_name} )')|join('\n        , ') }}
        ]
        |> TableView.setRowAttributes (\rowData -> [ onClick (ActionOpenItem rowData), style "cursor" "pointer" ])


viewLoading : Model -> Html Msg -> Html Msg
viewLoading model view1 =
    if isLoading model then
        div [] [ text "Loading.." ]

    else
        view1


viewBusy : Model -> Html Msg
viewBusy model =
    if isBusy model then
        span [] [ text "Busy.." ]

    else
        text ""


viewDialog : Dialog -> Html Msg
viewDialog dialog =
    case dialog of
        DialogNone ->
            text ""

        DialogNotification model_ ->
            Notification.view DialogClose model_




--# Update

update : Config -> Msg -> Model -> ( Model, Cmd Msg )
update cfg msg model =
    case msg of
        NoAction ->
            ( model, Cmd.none )

        {{table|pascalcase}}Result (Ok data) ->
            ( setData data model |> setIndicatorOff, Cmd.none )

        DialogClose ->
            ( closeDialog model, Cmd.none )

        MsgEdit msg_ ->
            case model.edit of
                Just model_ ->
                    updateEdit cfg msg_ model_ model

                Nothing ->
                    ( model, Cmd.none )

        ActionOpenItem item ->
            ( setEdit{{table|pascalcase}} (createModel item) model, Cmd.none )

        CreateItem ->
            ( setLoading model, Cmd.none )

        DeleteItem itemId ->
            ( setBusy model, {{table|pascalcase}}.rpcDelete cfg.jwt DeleteItemResult itemId )

        CancelItem item ->
            ( setEditDone model, Cmd.none )

        UpdateItem item ->
            ( setBusy model, {{table|pascalcase}}.rpcUpdate cfg.jwt UpdateItemResult item )

        CreateItemResult (Ok item1) ->
            ( addItem item1 model
                |> setEdit{{table|pascalcase}} (createModel item1)
                |> setIndicatorOff
            , Cmd.none
            )

        DeleteItemResult (Ok itemId) ->
            ( setEditDone model
                |> deleteItem itemId
                |> setIndicatorOff
            , Cmd.none
            )

        UpdateItemResult (Ok item1) ->
            ( setEditDone model
                |> updateItem item1
                |> setIndicatorOff
            , Cmd.none
            )

        {{table|pascalcase}}Result (Err err1) ->
            networkE "Load Failed" err1 model

        CreateItemResult (Err err1) ->
            networkE "Create Failed" err1 model

        DeleteItemResult (Err err1) ->
            networkE "Delete Failed" err1 model

        UpdateItemResult (Err err1) ->
            networkE "Update Failed" err1 model


init : Config -> ( Model, Cmd Msg )
init cfg =
    ( default |> setLoading
    , {{table|pascalcase}}.rpcList cfg.jwt {{table|pascalcase}}Result 0
    )


-- update functions


updateEdit : Config -> MsgEdit -> ModelEdit -> Model -> ( Model, Cmd Msg )
updateEdit cfg msg editModel model =
    case updateEditForm msg editModel of
        Active model_ ->
            ( setEdit{{table|pascalcase}} (Active model_) model, Cmd.none )

        Cancelled ->
            ( setEditDone model, Cmd.none )

        Confirmed model_ ->
            ( setEditDone model, {{table|pascalcase}}.rpcUpdate cfg.jwt UpdateItemResult model_ )



--helpers


networkE : String -> P.Error -> Model -> ( Model, Cmd Msg )
networkE title1 err1 model =
    ( model
        |> notificationE title1 (httpErrorToText (P.toHttpError err1))
        |> setIndicatorOff
    , Cmd.none
    )


notificationE : String -> String -> Model -> Model
notificationE title1 message1 model =
    { model | dialog = DialogNotification (Notification.notification title1 message1) }


setEdit{{table|pascalcase}}F : Model -> ModelEdit -> Model
setEdit{{table|pascalcase}}F model item1 =
    setEdit{{table|pascalcase}} item1 model

 

--# Model


type Msg
    = NoAction
    | {{table|pascalcase}}Result (Result P.Error (List {{table|pascalcase}}))
    | DialogClose
    | MsgEdit MsgEdit
    | CreateItem
    | DeleteItem Int
    | CancelItem {{table|pascalcase}}
    | UpdateItem {{table|pascalcase}}
    | CreateItemResult (Result P.Error {{table|pascalcase}})
    | DeleteItemResult (Result P.Error Int)
    | UpdateItemResult (Result P.Error {{table|pascalcase}})
    | ActionOpenItem {{table|pascalcase}}


type alias Model =
    { data : List {{table|pascalcase}}
    , dialog : Dialog
    , edit : Maybe ModelEdit
    , indicator : Indicator
    }


default : Model
default =
    { data = []
    , dialog = DialogNone
    , edit = Nothing
    , indicator = Loading
    }


type Dialog
    = DialogNone
    | DialogNotification Notification.Model



--## Model Properties


setEdit{{table|pascalcase}} : ModelEdit -> Model -> Model
setEdit{{table|pascalcase}} item1 model =
    { model | edit = Just item1 }


setEditDone : Model -> Model
setEditDone model =
    { model | edit = Nothing }


closeDialog : Model -> Model
closeDialog model =
    { model | dialog = DialogNone }


setData : List {{table|pascalcase}} -> Model -> Model
setData data1 model =
    { model | data = data1 }


addItem : {{table|pascalcase}} -> Model -> Model
addItem {{table|camelcase}}View model =
    { model | data = {{table|camelcase}}View :: model.data }


updateItem : {{table|pascalcase}} -> Model -> Model
updateItem {{table|camelcase}}View model =
    { model
        | data =
            List.map
                (\a1 ->
                    if a1.id == {{table|camelcase}}View.id then
                        {{table|camelcase}}View

                    else
                        a1
                )
                model.data
    }


deleteItem : Int -> Model -> Model
deleteItem {{table|camelcase}}ViewId model =
    { model
        | data = List.filter (.id >> (/=) {{table|camelcase}}ViewId) model.data
    }




--# View Edit

viewEdit : ModelEdit -> Html MsgEdit
viewEdit model =
    case model of
        Active model_ ->
            viewEditForm model_

        Confirmed model_ ->
            div [] [ text "Updating..." ]

        Cancelled ->
            div [] [ text "Change cancelled." ]


viewEditForm : ModelEditForm -> Html MsgEdit
viewEditForm model =
    div []
        [ text "{{table|titlecase}}"
        , Edit.fieldset [ style "max-width" "600px", style "margin" "auto" ]
            [ {{list_fmt(keys, 'Edit.readonly [] "{0.elm_title}" model.{0.elm_name}')|join('\n            , ') }}
            , {{list_fmt(no_keys, 'Edit.input [] Update{0.elm_pascal} "{0.elm_title}" model.{0.elm_name}')|join('\n            , ') }}
            , Button.btn [] Cancel "Cancel"
            , Button.btn [ Button.stylePrimary ] Confirm "Update"
            ]
        ]

--# Update Edit

updateEditForm : MsgEdit -> ModelEdit -> ModelEdit
updateEditForm msg model =
    case model of
        Active model_ ->
            updateEditForm_ msg model_

        Cancelled ->
            Cancelled

        Confirmed model_ ->
            Confirmed model_


updateEditForm_ : MsgEdit -> ModelEditForm -> ModelEdit
updateEditForm_ msg model =
    case msg of
        Cancel ->
            Cancelled

        Confirm ->
             Confirmed (get{{table|pascalcase}} model_)

        {% for field in no_keys%}
        Update{{field.elm_pascal}} msg_ ->
            { model_ | {{field.elm_name}} = Edit.update msg_ model_.{{field.elm_name}} }
        {% endfor %}


-- # Model Edit

type ModelEdit
    = Active ModelEditForm
    | Confirmed {{table|pascalcase}}
    | Cancelled


type alias ModelEditForm =
    { {{list_fmt(keys, '{0.elm_name} : {0.elm_type}')|join('\n    , ') }}
    , {{list_fmt(no_keys, '{0.elm_name} : Edit.Model {0.elm_type}')|join('\n    , ') }}
    }


type MsgEdit
    = Cancel
    | Confirm
    | {{list_fmt(no_keys, 'Update{0.elm_pascal} Edit.Msg')|join('\n    | ') }}


get{{table|pascalcase}} : ModelEditForm -> {{table|pascalcase}}
get{{table|pascalcase}} viewModel =
    { {{list_fmt(keys, '{0.elm_name} = viewModel.{0.elm_name}')|join('\n        , ') }}
    , {{list_fmt(no_keys, '{0.elm_name} = Edit.getValue viewModel.{0.elm_name}')|join('\n        , ') }}
    }    


create{{table|pascalcase}} : ModelEdit -> Maybe {{table|pascalcase}}
create{{table|pascalcase}} model =
    case model of
        Active model_ ->
            Just (get{{table|pascalcase}} model_)

        Confirmed model_ ->
            Just model_

        Cancelled ->
            Nothing


createModel : {{table|pascalcase}} -> ModelEdit
createModel model =
    Active
        { {{list_fmt(keys, '{0.elm_name} = model.{0.elm_name}')|join('\n        , ') }}
        , {{list_fmt(no_keys, '{0.elm_name} = Edit.init{0.elm_type} model.{0.elm_name}')|join('\n        , ') }}
        }     