module Views.AmiibosTable exposing (viewAmiibosTable)

import Html exposing (text)
import Material.Icon exposing (i)
import Material.Options exposing (css, onClick)
import Material.Table exposing (ascending, descending, sorted, table, tbody, td, th, thead)
import Messages exposing (..)
import Models.Amiibos exposing (Amiibo, AmiiboSeries, Amiibos, SortDirection(..), SortInfo, SortableField(..), sortAmiibos)


viewAmiibosTable : Amiibos -> SortInfo -> Html.Html Msg
viewAmiibosTable amiibos sortInfo =
    let
        sortedAmiibos =
            sortAmiibos amiibos sortInfo.field sortInfo.dir
    in
    table [ css "width" "100%" ]
        [ thead []
            [ th [] []
            , viewNameColumnHeader sortInfo.field sortInfo.dir
            , th [] [ text "Series" ]
            , viewReleaseDateColumnHeader sortInfo.field sortInfo.dir
            ]
        , tbody [] (List.map viewAmiiboTableRow sortedAmiibos)
        ]


viewNameColumnHeader : SortableField -> SortDirection -> Html.Html Msg
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


viewReleaseDateColumnHeader : SortableField -> SortDirection -> Html.Html Msg
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
