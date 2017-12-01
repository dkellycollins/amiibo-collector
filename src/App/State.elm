module App.State exposing (init, subscriptions, update)

import Amiibos.Rest
import AmiibosTable.State
import App.Types exposing (..)
import Material


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { amiibos = []
            , amiibosTable = AmiibosTable.State.init
            , mdl = Material.model
            }
    in
    ( model, Amiibos.Rest.getAmiibos flags.apiUrl UpdatedAmiibos )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatedAmiibos (Result.Ok newList) ->
            ( { model | amiibos = newList }, Cmd.none )

        UpdatedAmiibos (Result.Err _) ->
            ( { model | amiibos = [] }, Cmd.none )

        AmiibosTableMsg msg_ ->
            AmiibosTable.State.update msg_ model

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
