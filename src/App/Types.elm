module App.Types exposing (..)

import Amiibos.Types
import Http
import Material


type alias Model =
    { amiibos : Amiibos.Types.Amiibos
    , mdl : Material.Model
    }


type Msg
    = UpdatedAmiibos (Result Http.Error Amiibos.Types.Amiibos)
    | Mdl (Material.Msg Msg)
