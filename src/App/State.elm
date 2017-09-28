module App.State exposing (init, subscriptions, update)

import Amiibos.Rest
import App.Types exposing (..)
import Material


init : ( Model, Cmd Msg )
init =
    let
        model =
            { amiibos = []
            , mdl = Material.model
            }
    in
    ( model, Amiibos.Rest.getAmiibos UpdatedAmiibos )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatedAmiibos (Result.Ok newList) ->
            ( { model | amiibos = newList }, Cmd.none )

        UpdatedAmiibos (Result.Err _) ->
            ( { model | amiibos = [] }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
