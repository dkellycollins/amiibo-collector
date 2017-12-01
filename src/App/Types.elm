module App.Types exposing (..)

import Amiibos.Types
import AmiibosTable.Types
import Http
import Material

type alias Flags =
    { apiUrl: String
    }

type alias Model =
    { amiibos : Amiibos.Types.Amiibos
    , amiibosTable : AmiibosTable.Types.Model
    , mdl : Material.Model
    }


type Msg
    = UpdatedAmiibos (Result Http.Error Amiibos.Types.Amiibos)
    | AmiibosTableMsg (AmiibosTable.Types.Msg Msg)
    | Mdl (Material.Msg Msg)
