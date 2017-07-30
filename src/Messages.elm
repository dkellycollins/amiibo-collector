module Messages exposing (..)

import Http
import Models.Amiibos exposing (Amiibos, SortInfo)


type Msg
    = UpdatedAmiibos (Result Http.Error Amiibos)
    | SortChanged SortInfo
