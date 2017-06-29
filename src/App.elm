import Html
import Material
import Material.Table
import Maybe

main = view getAmiibos

-- MODELS

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

-- UPDATE

type Msg
  = UpdateModel
  | New AmiiboList

init: (AmiiboList, Cmd Msg)
init =
  ([], UpdateModel)

update: Msg -> AmiiboList -> (AmiiboList, Cmd Msg)
update msg model =
  case msg of
    UpdateModel ->
      (getAmiibos, New)
    New m -> 
      (m, Cmd.none)

-- VIEW

view: List Amiibo -> Html.Html msg
view amiibos = 
  Material.Table.table [] 
    [ Material.Table.thead []
      [ Material.Table.th [] [(Html.text "Name")]
      , Material.Table.th [] [(Html.text "Series")]
      , Material.Table.th [] [(Html.text "Release Date")]      
      ]
    , Material.Table.tbody [] (List.map mapAmiiboToTableRow amiibos)
    ]

mapAmiiboToTableRow: Amiibo -> Html.Html msg
mapAmiiboToTableRow amiibo =
  Html.tr []
    [ Material.Table.td [] [(Html.text amiibo.displayName)]
    , Material.Table.td [] [(Html.text (getAmiiboSeriesView amiibo.series))]    
    , Material.Table.td [] [(Html.text (getReleaseDateView amiibo.releaseDate))]
    ]

getReleaseDateView: Maybe String -> String
getReleaseDateView releaseDate =
  Maybe.withDefault "N/A" releaseDate

getAmiiboSeriesView: Maybe AmiiboSeries -> String
getAmiiboSeriesView amiiboSeries =
  case amiiboSeries of
    Nothing -> 
      "N/A"
    Just amiiboSeries ->
      amiiboSeries.displayName

mapAmiiboToListItem: Amiibo -> Html.Html msg
mapAmiiboToListItem amiibo =
  Html.li [] [(Html.text (toString amiibo))]

-- HTTP

getAmiibos: AmiiboList
getAmiibos =
  [ Amiibo "mario_0" "Mario" (Just "2014-11-21") (Just (AmiiboSeries "super_smash_bros" "Super Smash Bros"))
  , Amiibo "mario_1" "Mario" (Just "2015-03-20") (Just (AmiiboSeries "super_mario" "Super Mario"))
  , Amiibo "donkey_kong_0" "Donkey Kong" (Just "2014-11-21") (Just (AmiiboSeries "super_smash_bros" "Super Smash Bros"))
  , Amiibo "donkey_kong_1" "Donkey Kong" (Just "2016-11-04") (Just (AmiiboSeries "super_mario" "Super Mario"))
  , Amiibo "fox" "Fox" (Just "2014-11-21") (Just (AmiiboSeries "super_smash_bros" "Super Smash Bros"))
  ]