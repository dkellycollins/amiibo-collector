module Amiibos exposing (..)

import Http
import Json.Decode

type alias AmiiboSeries =
  { name: String
  , displayName: String
  }

type alias Amiibo =
  { name: String
  , displayName: String
  , releaseDate: Maybe String
  , series: Maybe AmiiboSeries
  }

type alias AmiiboList = List Amiibo

amiiboSeriesDecoder: Json.Decode AmiiboSeries

amiiboDecoder: Json.Decode Amiibo

amiiboListDecoder: Json.Decode AmiiboList
