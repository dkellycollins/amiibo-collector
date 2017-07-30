module Main exposing (..)

import Html
import Http
import Material.Grid
import Material.Progress
import Messages exposing (..)
import Models.Amiibos exposing (..)
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
    , sortInfo : SortInfo
    }



-- INIT


init : ( AppState, Cmd Msg )
init =
    let
        appState =
            { amiibos = []
            , sortInfo = SortInfo Name Asc
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

        SortChanged info ->
            ( { appState | sortInfo = info }, Cmd.none )



-- VIEW


view : AppState -> Html.Html Msg
view appState =
    Material.Grid.grid []
        [ Material.Grid.cell [ Material.Grid.size Material.Grid.All 12 ]
            [ viewAmiibosTable appState.amiibos appState.sortInfo
            ]
        ]


viewLoadingBar : Amiibos -> Html.Html msg
viewLoadingBar amiibos =
    case amiibos of
        _ ->
            Material.Progress.indeterminate



--SUBSCRIPTIONS


subscriptions : AppState -> Sub Msg
subscriptions model =
    Sub.none
