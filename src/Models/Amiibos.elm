module Models.Amiibos exposing (Amiibo, AmiiboSeries, Amiibos, SortDirection(..), SortInfo, SortableField(..), getAmiibos, sortAmiibos)

import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, optional, required)
import List exposing (reverse, sortBy, sortWith)
import List.Extra exposing (stableSortWith)


type alias AmiiboSeries =
    { name : String
    , displayName : String
    }


type alias Amiibo =
    { name : String
    , displayName : String
    , releaseDate : Maybe String
    , series : Maybe AmiiboSeries
    }


type alias Amiibos =
    List Amiibo


type SortableField
    = Name
    | ReleaseDate
    | Series


type SortDirection
    = Asc
    | Desc


type alias SortInfo =
    { field : SortableField
    , dir : SortDirection
    }


getAmiibos : (Result Http.Error Amiibos -> msg) -> Cmd msg
getAmiibos msg =
    let
        url =
            "/api/amiibos"

        request =
            Http.get url amiibosDecoder
    in
    Http.send msg request


sortAmiibos : Amiibos -> SortableField -> SortDirection -> Amiibos
sortAmiibos amiibos sortedField sortDir =
    let
        sortByName =
            stableSortWith (\amiiboA amiiboB -> compare amiiboA.name amiiboB.name)

        sortByReleaseDate =
            stableSortWith releaseDateComparison

        sortBySeries =
            stableSortWith seriesComparision
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
                |> reverse

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
                |> reverse

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
                |> reverse


releaseDateComparison : Amiibo -> Amiibo -> Order
releaseDateComparison amiiboA amiiboB =
    case ( amiiboA.releaseDate, amiiboB.releaseDate ) of
        ( Just valueA, Just valueB ) ->
            compare valueA valueB

        ( Just valueA, Nothing ) ->
            GT

        ( Nothing, Just valueB ) ->
            LT

        ( Nothing, Nothing ) ->
            EQ


seriesComparision : Amiibo -> Amiibo -> Order
seriesComparision amiiboA amiiboB =
    case ( amiiboA.series, amiiboB.series ) of
        ( Just seriesA, Just seriesB ) ->
            compare seriesA.name seriesB.name

        ( Just seriesA, Nothing ) ->
            GT

        ( Nothing, Just seriesB ) ->
            LT

        ( Nothing, Nothing ) ->
            EQ


amiibosDecoder : Decoder Amiibos
amiibosDecoder =
    list amiiboDecoder


amiiboDecoder : Decoder Amiibo
amiiboDecoder =
    decode Amiibo
        |> required "name" string
        |> required "displayName" string
        |> required "releaseDate" (nullable string)
        |> required "series" (nullable amiiboSeriesDecoder)


amiiboSeriesDecoder : Decoder AmiiboSeries
amiiboSeriesDecoder =
    decode AmiiboSeries
        |> required "name" string
        |> required "displayName" string
