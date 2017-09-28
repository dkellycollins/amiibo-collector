module AmiibosTable.Types exposing (..)


type alias Model =
    { sortField : SortableField
    , sortDir : SortDirection
    }


type alias Container c =
    { c | amiibosTable : Model }


type Msg m
    = SortChanged ( SortableField, SortDirection )


type SortableField
    = Name
    | ReleaseDate
    | Series


type SortDirection
    = Asc
    | Desc
