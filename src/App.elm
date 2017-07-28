module Main exposing (..)

import Html
import Http
import Material.Grid
import Material.Progress
import Models.Amiibos exposing (..)
import Views.AmiibosTable exposing (..)


main : Program Never Amiibos Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MESSAGES


type Msg
    = UpdatedAmiibos (Result Http.Error Amiibos)



-- INIT


init : ( Amiibos, Cmd Msg )
init =
    ( [], getAmiibos UpdatedAmiibos )



-- UPDATE


update : Msg -> Amiibos -> ( Amiibos, Cmd Msg )
update msg model =
    case msg of
        UpdatedAmiibos (Result.Ok newList) ->
            ( List.sortBy .name newList, Cmd.none )

        UpdatedAmiibos (Result.Err _) ->
            ( [], Cmd.none )



-- VIEW


view : Amiibos -> Html.Html msg
view amiibos =
    Material.Grid.grid []
        [ Material.Grid.cell [ Material.Grid.size Material.Grid.All 12 ] [ viewAmiibosTable amiibos ] ]



--SUBSCRIPTIONS


subscriptions : Amiibos -> Sub Msg
subscriptions model =
    Sub.none
