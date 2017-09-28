module Main exposing (main)

import App.State
import App.Types
import App.View
import Html


main : Program Never App.Types.Model App.Types.Msg
main =
    Html.program
        { init = App.State.init
        , update = App.State.update
        , subscriptions = App.State.subscriptions
        , view = App.View.view
        }
