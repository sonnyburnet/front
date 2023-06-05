module App.Page.About ( component ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import App.Data.Route
import Routing.Duplex (print)
import Data.Maybe
import Effect.Aff (try)
import Affjax.Web as AX
import Affjax.ResponseFormat (string)
import Data.Either
import Affjax
import App.Data.Route as R
import App.Capability.Navigate
import Affjax.StatusCode
import Effect.Ref as Ref
import Affjax (Response)
import Effect.Console

import Undefined

type State = { body :: String }

data Action = Initialise


component errorRef =
  H.mkComponent
    { initialState: const { body: mempty  }
    , render: render
    , eval: H.mkEval H.defaultEval 
      { handleAction = handleAction
      , initialize = Just Initialise
      }
    }
  where 
     handleAction Initialise = do 
       let url = "https://raw.githubusercontent.com/fclaw/pitch/main/expectations.txt"
       res <- H.liftAff $ AX.get string url
       case res of 
         Right r -> 
           case _.status r of 
             StatusCode 200 -> H.modify_ \s -> s { body = _.body r }
             _ -> do
               H.liftEffect $ Ref.write (Just r) errorRef
               navigate R.Error
         Left _ -> navigate R.Error

mkClass = HP.class_ <<< HH.ClassName

safeHref = HP.href <<< append "#" <<< print routeCodec

render { body}  = 
  HH.div_ 
  [
    HH.nav [mkClass "nav nav--border-top"] 
    [
      HH.span [mkClass "nav__logo"] [HH.a [mkClass "link--background-grey", safeHref R.Home] [HH.text "Sergey Yakovlev"]]
    ]
  , HH.div [mkClass "content withMargin"] 
    [
      HH.div [mkClass "error-centered"]
      [ HH.text body
      ]
    ]
  ]