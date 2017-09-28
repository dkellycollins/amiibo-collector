module Amiibos.Rest exposing (getAmiibos)

import Amiibos.Types exposing (..)
import Date
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, optional, required)


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
        |> required "releaseDate" (nullable dateDecoder)
        |> required "series" (nullable amiiboSeriesDecoder)


amiiboSeriesDecoder : Decoder AmiiboSeries
amiiboSeriesDecoder =
    decode AmiiboSeries
        |> required "name" string
        |> required "displayName" string


dateDecoder : Decoder Date.Date
dateDecoder =
    let
        convert raw =
            case Date.fromString raw of
                Ok date ->
                    succeed date

                Err error ->
                    fail error
    in
    string |> andThen convert
