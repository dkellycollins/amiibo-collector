module App.View exposing (view)

import AmiibosTable.View
import App.Types exposing (..)
import Html
import Html.Attributes
import Material.Layout


view : Model -> Html.Html Msg
view model =
    Material.Layout.render Mdl
        model.mdl
        [ Material.Layout.fixedHeader
        ]
        { header = [ Html.h4 [ Html.Attributes.style [ ( "padding-left", "16px" ) ] ] [ Html.text "Amiibos" ] ]
        , drawer = []
        , tabs = ( [], [] )
        , main = [ AmiibosTable.View.view AmiibosTableMsg model.amiibos model.amiibosTable ]
        }
