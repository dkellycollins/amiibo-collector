module Views.AmiibosTable exposing (viewAmiibosTable)

import Html exposing (text)
import Material.Icon exposing (i)
import Material.Options exposing (css)
import Material.Table exposing (ascending, descending, sorted, table, tbody, td, th, thead)
import Models.Amiibos exposing (Amiibo, AmiiboSeries, Amiibos)


viewAmiibosTable : Amiibos -> Html.Html msg
viewAmiibosTable amiibos =
    table [ css "width" "100%" ]
        [ thead []
            [ th [] []
            , th [ sorted Material.Table.Ascending ] [ text "Name" ]
            , th [] [ text "Series" ]
            , th [] [ text "Release Date" ]
            ]
        , tbody [] (List.map viewAmiiboTableRow amiibos)
        ]


viewAmiiboTableRow : Amiibo -> Html.Html msg
viewAmiiboTableRow amiibo =
    Html.tr []
        [ td [] [ i "check_box_outline_blank" ]
        , td [] [ text amiibo.displayName ]
        , td [] [ text (viewAmiiboSeries amiibo.series) ]
        , td [] [ text (viewReleaseDate amiibo.releaseDate) ]
        ]


viewReleaseDate : Maybe String -> String
viewReleaseDate releaseDate =
    Maybe.withDefault "N/A" releaseDate


viewAmiiboSeries : Maybe AmiiboSeries -> String
viewAmiiboSeries amiiboSeries =
    case amiiboSeries of
        Nothing ->
            "N/A"

        Just amiiboSeries ->
            amiiboSeries.displayName
