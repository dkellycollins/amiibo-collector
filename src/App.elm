module Main exposing (..)

import Amiibos exposing (..)
import Html
import Http
import Material
import Material.Table
import Maybe


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
            ( newList, Cmd.none )

        UpdatedAmiibos (Result.Err _) ->
            ( [], Cmd.none )



-- VIEW


view : Amiibos -> Html.Html msg
view amiibos =
    Material.Table.table []
        [ Material.Table.thead []
            [ Material.Table.th [] [ Html.text "Name" ]
            , Material.Table.th [] [ Html.text "Series" ]
            , Material.Table.th [] [ Html.text "Release Date" ]
            ]
        , Material.Table.tbody [] (List.map mapAmiiboToTableRow amiibos)
        ]


mapAmiiboToTableRow : Amiibo -> Html.Html msg
mapAmiiboToTableRow amiibo =
    Html.tr []
        [ Material.Table.td [] [ Html.text amiibo.displayName ]
        , Material.Table.td [] [ Html.text (getAmiiboSeriesView amiibo.series) ]
        , Material.Table.td [] [ Html.text (getReleaseDateView amiibo.releaseDate) ]
        ]


getReleaseDateView : Maybe String -> String
getReleaseDateView releaseDate =
    Maybe.withDefault "N/A" releaseDate


getAmiiboSeriesView : Maybe AmiiboSeries -> String
getAmiiboSeriesView amiiboSeries =
    case amiiboSeries of
        Nothing ->
            "N/A"

        Just amiiboSeries ->
            amiiboSeries.displayName


mapAmiiboToListItem : Amiibo -> Html.Html msg
mapAmiiboToListItem amiibo =
    Html.li [] [ Html.text (toString amiibo) ]



--SUBSCRIPTIONS


subscriptions : Amiibos -> Sub Msg
subscriptions model =
    Sub.none
