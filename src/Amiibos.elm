module Amiibos exposing (..)

import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, optional, required)


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


getAmiibos : (Result Http.Error Amiibos -> msg) -> Cmd msg
getAmiibos msg =
    let
        url =
            "/api/amiibos"

        request =
            Http.get url amiibosDecoder
    in
    Http.send msg request


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
