module App.State exposing (init, subscriptions, update)

import Amiibos.Rest
import AmiibosTable.State
import App.Types exposing (..)
import Material
import RemoteData


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { amiibos = RemoteData.Loading
            , amiibosTable = AmiibosTable.State.init
            , mdl = Material.model
            }
    in
    ( model, Amiibos.Rest.getAmiibos flags.apiUrl UpdatedAmiibos )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdatedAmiibos data ->
            ( { model | amiibos = data }, Cmd.none )

        AmiibosTableMsg msg_ ->
            AmiibosTable.State.update msg_ model

        Mdl msg_ ->
            Material.update Mdl msg_ model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
