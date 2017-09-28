module Amiibos.Types exposing (..)

import Date


type alias AmiiboSeries =
    { name : String
    , displayName : String
    }


type alias Amiibo =
    { name : String
    , displayName : String
    , releaseDate : Maybe Date.Date
    , series : Maybe AmiiboSeries
    }


type alias Amiibos =
    List Amiibo
