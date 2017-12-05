module App.Types exposing (..)

import Amiibos.Types
import AmiibosTable.Types
import Material
import RemoteData

type alias Flags =
    { apiUrl: String
    }

type alias Model =
    { amiibos : RemoteData.WebData Amiibos.Types.Amiibos
    , amiibosTable : AmiibosTable.Types.Model
    , mdl : Material.Model
    }


type Msg
    = UpdatedAmiibos (RemoteData.WebData Amiibos.Types.Amiibos)
    | AmiibosTableMsg (AmiibosTable.Types.Msg Msg)
    | Mdl (Material.Msg Msg)
