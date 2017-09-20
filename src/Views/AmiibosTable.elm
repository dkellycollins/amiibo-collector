module Views.AmiibosTable exposing (viewAmiibosTable)

import Date exposing (Date)
import Date.Extra exposing (toFormattedString)
import Html exposing (img, text)
import Html.Attributes exposing (height, src, width)
import Material
import Material.Options exposing (css, onClick, onToggle)
import Material.Table exposing (ascending, descending, sorted, table, tbody, td, th, thead, tr)
import Material.Toggles exposing (..)
import Messages exposing (..)
import Models.Amiibos exposing (Amiibo, AmiiboSeries, Amiibos, SortDirection(..), SortInfo, SortableField(..), sortAmiibos)
import Set exposing (..)


viewAmiibosTable : Material.Model -> Set String -> Amiibos -> SortInfo -> Html.Html Messages.Msg
viewAmiibosTable mdl selectedAmiibos amiibos sortInfo =
    let
        sortedAmiibos =
            sortAmiibos amiibos sortInfo.field sortInfo.dir
    in
    table [ css "width" "100%" ]
        [ thead []
            [ th [] []
            , th [] []
            , viewNameColumnHeader sortInfo.field sortInfo.dir
            , viewSeriesColumnHeader sortInfo.field sortInfo.dir
            , viewReleaseDateColumnHeader sortInfo.field sortInfo.dir
            ]
        , tbody [] (List.indexedMap (viewAmiiboTableRow mdl selectedAmiibos) sortedAmiibos)
        ]


viewNameColumnHeader : SortableField -> SortDirection -> Html.Html Messages.Msg
viewNameColumnHeader sortField sortDir =
    let
        headerText =
            text "Name"
    in
    case ( sortField, sortDir ) of
        ( Name, Asc ) ->
            th
                [ ascending
                , onClick (SortChanged (SortInfo Name Desc))
                ]
                [ headerText ]

        ( Name, Desc ) ->
            th
                [ descending
                , onClick (SortChanged (SortInfo Name Asc))
                ]
                [ headerText ]

        _ ->
            th [ onClick (SortChanged (SortInfo Name Asc)) ] [ headerText ]


viewSeriesColumnHeader : SortableField -> SortDirection -> Html.Html Messages.Msg
viewSeriesColumnHeader sortField sortDir =
    let
        headerText =
            text "Series"
    in
    case ( sortField, sortDir ) of
        ( Series, Asc ) ->
            th
                [ ascending
                , onClick (SortChanged (SortInfo Series Desc))
                ]
                [ headerText ]

        ( Series, Desc ) ->
            th
                [ descending
                , onClick (SortChanged (SortInfo Series Asc))
                ]
                [ headerText ]

        _ ->
            th [ onClick (SortChanged (SortInfo Series Asc)) ] [ headerText ]


viewReleaseDateColumnHeader : SortableField -> SortDirection -> Html.Html Messages.Msg
viewReleaseDateColumnHeader sortField sortDir =
    let
        headerText =
            text "Release Date"
    in
    case ( sortField, sortDir ) of
        ( ReleaseDate, Asc ) ->
            th
                [ ascending
                , onClick (SortChanged (SortInfo ReleaseDate Desc))
                ]
                [ headerText ]

        ( ReleaseDate, Desc ) ->
            th
                [ descending
                , onClick (SortChanged (SortInfo ReleaseDate Asc))
                ]
                [ headerText ]

        _ ->
            th [ onClick (SortChanged (SortInfo ReleaseDate Asc)) ] [ headerText ]


viewAmiiboTableRow : Material.Model -> Set String -> Int -> Amiibo -> Html.Html Messages.Msg
viewAmiiboTableRow mdl selectedAmiibos index amiibo =
    let
        srcUrl =
            "https://storage.googleapis.com/amiibo-collector/" ++ amiibo.name ++ ".png"
    in
    tr []
        [ td []
            [ Material.Toggles.checkbox Mdl
                [ index ]
                mdl
                [ onToggle (ToggleAmiibo amiibo.name)
                , Material.Toggles.value <| Set.member amiibo.name selectedAmiibos
                ]
                []
            ]
        , td [] [ img [ src srcUrl, height 32, width 32 ] [] ]
        , td [] [ text amiibo.displayName ]
        , td [] [ viewAmiiboSeries amiibo.series ]
        , td [] [ viewReleaseDate amiibo.releaseDate ]
        ]


viewReleaseDate : Maybe Date -> Html.Html msg
viewReleaseDate releaseDate =
    case releaseDate of
        Just releaseDate ->
            text (toFormattedString "MMMM ddd, y" releaseDate)

        Nothing ->
            text "N/A"


viewAmiiboSeries : Maybe AmiiboSeries -> Html.Html msg
viewAmiiboSeries amiiboSeries =
    case amiiboSeries of
        Just amiiboSeries ->
            text amiiboSeries.displayName

        Nothing ->
            text "N/A"
