module Amiibos exposing (..)

import Http
import Json.Decode exposing (..)


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


type alias AmiiboList =
    List Amiibo


getAmiiboList : (Result Http.Error AmiiboList -> msg) -> Cmd msg
getAmiiboList msg =
    let
        url =
            "https://amiibos-api.herokuapp.com/amiibos"

        request =
            Http.get url decodeAmiiboList
    in
    Http.send msg request


decodeAmiiboList : Decoder AmiiboList
decodeAmiiboList =
    list decodeAmiibo


decodeAmiibo : Decoder Amiibo
decodeAmiibo =
    map4 Amiibo (field "name" string) (field "displayName" string) (field "releaseDate" (nullable string)) (field "series" (nullable decodeAmiiboSeries))


decodeAmiiboSeries : Decoder AmiiboSeries
decodeAmiiboSeries =
    map2 AmiiboSeries (field "name" string) (field "displayName" string)
