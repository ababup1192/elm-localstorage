module Main exposing (..)

import Html exposing (Html, program, div, input, h1, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput, onClick)
import Ports.LocalStorage exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


type alias Model =
    { getKey : Key, setKey : Key, setValue : String, result : String }


initialModel : Model
initialModel =
    { getKey = "", setKey = "", setValue = "", result = "" }


type Msg
    = InputGetKey Key
    | InputSetKey Key
    | InputSetValue String
    | GetStorageItem
    | SetStorageItem
    | StorageGetItemResponse ( Key, Value )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ getKey, setKey, setValue } as model) =
    case msg of
        StorageGetItemResponse ( _, value ) ->
            let
                result =
                    toString <| Decode.decodeValue Decode.string value
            in
                ( { model | result = result }, Cmd.none )

        InputGetKey key ->
            ( { model | getKey = key }, Cmd.none )

        InputSetKey key ->
            ( { model | setKey = key }, Cmd.none )

        InputSetValue value ->
            ( { model | setValue = value }, Cmd.none )

        GetStorageItem ->
            ( model, storageGetItem getKey )

        SetStorageItem ->
            ( model, storageSetItem ( setKey, Encode.string setValue ) )


view : Model -> Html Msg
view { getKey, setKey, setValue, result } =
    div []
        [ div []
            [ input [ placeholder "Key", onInput InputGetKey, value getKey ] []
            , input [ type_ "button", value "Get", onClick GetStorageItem ] []
            ]
        , div []
            [ input [ placeholder "Key", onInput InputSetKey, value setKey ] []
            , input [ placeholder "Value", onInput InputSetValue, value setValue ] []
            , input [ type_ "button", value "Set", onClick SetStorageItem ] []
            ]
        , h1 [] [ text result ]
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ storageGetItemResponse StorageGetItemResponse
        ]



-- Main


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
