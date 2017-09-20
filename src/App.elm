module Main exposing (..)

import Html
import Html.Attributes
import Material
import Material.Layout
import Material.Progress
import Messages exposing (..)
import Models.Amiibos exposing (..)
import Set exposing (..)
import Views.AmiibosTable exposing (..)


main : Program Never AppState Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODELS


type alias AppState =
    { amiibos : Amiibos
    , selectedAmiibos : Set String
    , sortInfo : SortInfo
    , mdl : Material.Model
    }



-- INIT


init : ( AppState, Cmd Msg )
init =
    let
        appState =
            { amiibos = []
            , selectedAmiibos = Set.empty
            , sortInfo = SortInfo Name Asc
            , mdl = Material.model
            }
    in
    ( appState, getAmiibos UpdatedAmiibos )



-- UPDATE


update : Msg -> AppState -> ( AppState, Cmd Msg )
update msg appState =
    case msg of
        UpdatedAmiibos (Result.Ok newList) ->
            ( { appState | amiibos = newList }, Cmd.none )

        UpdatedAmiibos (Result.Err _) ->
            ( { appState | amiibos = [] }, Cmd.none )

        ToggleAmiibo amiiboName ->
            let
                newSet =
                    if Set.member amiiboName appState.selectedAmiibos then
                        Set.remove amiiboName appState.selectedAmiibos
                    else
                        Set.insert amiiboName appState.selectedAmiibos
            in
            ( { appState | selectedAmiibos = newSet }, Cmd.none )

        SortChanged info ->
            ( { appState | sortInfo = info }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ appState



-- VIEW


view : AppState -> Html.Html Msg
view appState =
    Material.Layout.render Mdl
        appState.mdl
        [ Material.Layout.fixedHeader
        ]
        { header = [ Html.h4 [ Html.Attributes.style [ ( "padding", "8px" ) ] ] [ Html.text "Amiibos" ] ]
        , drawer = []
        , tabs = ( [], [] )
        , main = [ viewAmiibosTable appState.mdl appState.selectedAmiibos appState.amiibos appState.sortInfo ]
        }


viewLoadingBar : Amiibos -> Html.Html msg
viewLoadingBar amiibos =
    case amiibos of
        _ ->
            Material.Progress.indeterminate



--SUBSCRIPTIONS


subscriptions : AppState -> Sub Msg
subscriptions model =
    Sub.none
