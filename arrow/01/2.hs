import Control.Monad ((>=>))
import System.Directory (getTemporaryDirectory)
import System.Environment (getProgName)

class Arrow arr where
  arr :: (a -> b) -> arr a b
  (>>>) :: arr a b -> arr b c -> arr a c

instance Arrow (->) where
  arr = id
  (>>>) = flip (.)

newtype Kleisli m a b = Kleisli { runKleisli :: a -> m b }

instance Monad m => Arrow (Kleisli m) where
  arr f = Kleisli $ return . f
  f >>> g = Kleisli $ runKleisli f >=> runKleisli g

count :: String -> Kleisli IO String ()
count w = Kleisli readFile >>>
          arr words >>> arr (filter (==w)) >>> arr length >>>
          Kleisli print

newtype SF a b = SF { runSF :: [a] -> [b] }

instance Arrow SF where
  arr f = SF (map f)
  SF f >>> SF g = SF (f >>> g)

delay x = SF (x:)

main :: IO ()
main = do
  path <- getTemporaryDirectory
  filename <- getProgName
  runKleisli (count "Monad") $ path ++ filename
  print $ runSF (delay 0) [1..5]
  
