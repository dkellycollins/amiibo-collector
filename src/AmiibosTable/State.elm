module AmiibosTable.State exposing (..)

import AmiibosTable.Types exposing (..)


init : Model
init =
    { sortField = Name
    , sortDir = Asc
    }


update : Msg m -> Container c -> ( Container c, Cmd m )
update msg container =
    case msg of
        SortChanged ( field, dir ) ->
            ( { container | amiibosTable = updateSortInfo field dir container.amiibosTable }, Cmd.none )


updateSortInfo : SortableField -> SortDirection -> Model -> Model
updateSortInfo sortField sortDir model =
    { model | sortField = sortField, sortDir = sortDir }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
