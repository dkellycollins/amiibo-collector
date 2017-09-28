module AmiibosTable.View exposing (view)

import Amiibos.Types
import Date
import Date.Extra
import Html
import Html.Attributes
import Material.Options
import Material.Table


view : Amiibos.Types.Amiibos -> Html.Html m
view amiibos =
    Material.Table.table [ Material.Options.css "width" "100%" ]
        [ Material.Table.thead []
            [ Material.Table.th [] []
            , Material.Table.th [] [ Html.text "Name" ]
            , Material.Table.th [] [ Html.text "Series" ]
            , Material.Table.th [] [ Html.text "Release Date" ]
            ]
        , Material.Table.tbody [] (List.indexedMap viewAmiiboTableRow amiibos)
        ]


viewAmiiboTableRow : Int -> Amiibos.Types.Amiibo -> Html.Html m
viewAmiiboTableRow index amiibo =
    Material.Table.tr []
        [ Material.Table.td [] [ viewImage amiibo ]
        , Material.Table.td [] [ Html.text amiibo.displayName ]
        , Material.Table.td [] [ viewAmiiboSeries amiibo.series ]
        , Material.Table.td [] [ viewReleaseDate amiibo.releaseDate ]
        ]


viewImage : Amiibos.Types.Amiibo -> Html.Html msg
viewImage amiibo =
    Html.img
        [ Html.Attributes.src ("https://storage.googleapis.com/amiibo-collector/" ++ amiibo.name ++ ".png")
        , Html.Attributes.height 32
        , Html.Attributes.width 32
        ]
        []


viewReleaseDate : Maybe Date.Date -> Html.Html m
viewReleaseDate releaseDate =
    case releaseDate of
        Just releaseDate ->
            Html.text (Date.Extra.toFormattedString "MMMM ddd, y" releaseDate)

        Nothing ->
            Html.text "N/A"


viewAmiiboSeries : Maybe Amiibos.Types.AmiiboSeries -> Html.Html m
viewAmiiboSeries amiiboSeries =
    case amiiboSeries of
        Just amiiboSeries ->
            Html.text amiiboSeries.displayName

        Nothing ->
            Html.text "N/A"
