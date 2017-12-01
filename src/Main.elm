module Main exposing (main)

import App.State
import App.Types
import App.View
import Html


main : Program App.Types.Flags App.Types.Model App.Types.Msg
main =
    Html.programWithFlags
        { init = App.State.init
        , update = App.State.update
        , subscriptions = App.State.subscriptions
        , view = App.View.view
        }
