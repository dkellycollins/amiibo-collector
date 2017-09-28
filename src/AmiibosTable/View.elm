module AmiibosTable.View exposing (view)

import Amiibos.Types
import AmiibosTable.Types exposing (..)
import Date
import Date.Extra
import Html
import Html.Attributes
import List.Extra
import Material.Options
import Material.Table


view : (Msg m -> m) -> Amiibos.Types.Amiibos -> Model -> Html.Html m
view lift amiibos model =
    let
        sortedAmiibos =
            sortAmiibos amiibos model.sortField model.sortDir
    in
    Material.Table.table [ Material.Options.css "width" "100%" ]
        [ Material.Table.thead []
            [ viewEmptyColumnHeader
            , viewNameColumnHeader lift model.sortField model.sortDir
            , viewSeriesColumnHeader lift model.sortField model.sortDir
            , viewReleaseDateColumnHeader lift model.sortField model.sortDir
            ]
        , Material.Table.tbody [] (List.indexedMap viewAmiiboTableRow sortedAmiibos)
        ]


viewEmptyColumnHeader : Html.Html m
viewEmptyColumnHeader =
    Material.Table.th [] []


viewNameColumnHeader : (Msg m -> m) -> SortableField -> SortDirection -> Html.Html m
viewNameColumnHeader lift sortField sortDir =
    let
        headerText =
            Html.text "Name"
    in
    case ( sortField, sortDir ) of
        ( Name, Asc ) ->
            Material.Table.th
                [ Material.Table.ascending
                , Material.Options.onClick (lift (SortChanged ( Name, Desc )))
                ]
                [ headerText ]

        ( Name, Desc ) ->
            Material.Table.th
                [ Material.Table.descending
                , Material.Options.onClick (lift (SortChanged ( Name, Asc )))
                ]
                [ headerText ]

        _ ->
            Material.Table.th [ Material.Options.onClick (lift (SortChanged ( Name, Asc ))) ] [ headerText ]


viewSeriesColumnHeader : (Msg m -> m) -> SortableField -> SortDirection -> Html.Html m
viewSeriesColumnHeader lift sortField sortDir =
    let
        headerText =
            Html.text "Series"
    in
    case ( sortField, sortDir ) of
        ( Series, Asc ) ->
            Material.Table.th
                [ Material.Table.ascending
                , Material.Options.onClick (lift (SortChanged ( Series, Desc )))
                ]
                [ headerText ]

        ( Series, Desc ) ->
            Material.Table.th
                [ Material.Table.descending
                , Material.Options.onClick (lift (SortChanged ( Series, Asc )))
                ]
                [ headerText ]

        _ ->
            Material.Table.th [ Material.Options.onClick (lift (SortChanged ( Series, Asc ))) ] [ headerText ]


viewReleaseDateColumnHeader : (Msg m -> m) -> SortableField -> SortDirection -> Html.Html m
viewReleaseDateColumnHeader lift sortField sortDir =
    let
        headerText =
            Html.text "Release Date"
    in
    case ( sortField, sortDir ) of
        ( ReleaseDate, Asc ) ->
            Material.Table.th
                [ Material.Table.ascending
                , Material.Options.onClick (lift (SortChanged ( ReleaseDate, Desc )))
                ]
                [ headerText ]

        ( ReleaseDate, Desc ) ->
            Material.Table.th
                [ Material.Table.descending
                , Material.Options.onClick (lift (SortChanged ( ReleaseDate, Asc )))
                ]
                [ headerText ]

        _ ->
            Material.Table.th [ Material.Options.onClick (lift (SortChanged ( ReleaseDate, Asc ))) ] [ headerText ]


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


sortAmiibos : Amiibos.Types.Amiibos -> SortableField -> SortDirection -> Amiibos.Types.Amiibos
sortAmiibos amiibos sortedField sortDir =
    let
        sortByName =
            List.Extra.stableSortWith (\amiiboA amiiboB -> compare amiiboA.displayName amiiboB.displayName)

        sortByReleaseDate =
            List.Extra.stableSortWith releaseDateComparison

        sortBySeries =
            List.Extra.stableSortWith seriesComparision
    in
    -- In general, amiibos should be sorted by release date, series, then name.
    case ( sortedField, sortDir ) of
        ( Name, Asc ) ->
            amiibos
                |> sortByReleaseDate
                |> sortBySeries
                |> sortByName

        ( Name, Desc ) ->
            amiibos
                |> sortByReleaseDate
                |> sortBySeries
                |> sortByName
                |> List.reverse

        ( ReleaseDate, Asc ) ->
            amiibos
                |> sortBySeries
                |> sortByName
                |> sortByReleaseDate

        ( ReleaseDate, Desc ) ->
            amiibos
                |> sortBySeries
                |> sortByName
                |> sortByReleaseDate
                |> List.reverse

        ( Series, Asc ) ->
            amiibos
                |> sortByReleaseDate
                |> sortByName
                |> sortBySeries

        ( Series, Desc ) ->
            amiibos
                |> sortByReleaseDate
                |> sortByName
                |> sortBySeries
                |> List.reverse


releaseDateComparison : Amiibos.Types.Amiibo -> Amiibos.Types.Amiibo -> Order
releaseDateComparison amiiboA amiiboB =
    case ( amiiboA.releaseDate, amiiboB.releaseDate ) of
        ( Just valueA, Just valueB ) ->
            Date.Extra.compare valueA valueB

        ( Just valueA, Nothing ) ->
            GT

        ( Nothing, Just valueB ) ->
            LT

        ( Nothing, Nothing ) ->
            EQ


seriesComparision : Amiibos.Types.Amiibo -> Amiibos.Types.Amiibo -> Order
seriesComparision amiiboA amiiboB =
    case ( amiiboA.series, amiiboB.series ) of
        ( Just seriesA, Just seriesB ) ->
            compare seriesA.displayName seriesB.displayName

        ( Just seriesA, Nothing ) ->
            GT

        ( Nothing, Just seriesB ) ->
            LT

        ( Nothing, Nothing ) ->
            EQ
