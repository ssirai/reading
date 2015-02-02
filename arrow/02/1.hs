import Control.Arrow hiding ((+++))
import qualified Control.Category as C

addA :: Arrow arr => arr a Int -> arr a Int -> arr a Int
addA f g = (f &&& g) >>> arr (uncurry (+))

mulA f g = (f *** g)

f = succ
g = (*2)

listcase [] = Left ()
listcase (x:xs) = Right (x, xs)

mapA f = arr listcase >>>
         arr (const []) ||| (f *** mapA f >>> arr (uncurry (:)))

newtype SF a b = SF {runSF :: [a] -> [b]}

instance C.Category SF where
  id = C.id
  SF f . SF g = SF (f C.. g)

instance Arrow SF where
  arr f = SF (map f)
  first (SF f) = SF (unzip >>> first f >>> uncurry zip)

instance ArrowChoice SF where
  left (SF f) = SF (\xs -> combine xs (f [y | Left y <- xs]))
    where combine (Left y:xs)   (z:zs) = Left z: combine xs zs
          combine (Right y:xs)  zs     = Right y: combine xs zs
          combine []            zs     = []

left' f (Left a) = Left (f a)
right' f (Right a) = Right (f a)

(+++) :: ((->) a b) -> ((->) c d) -> ((->) (Either a c) (Either b d))
f +++ g = left' f >>> right' g

delay x = SF (init . (x:))

delaysA = arr listcase >>>
          arr (const []) |||
          (arr id  *** (delaysA >>> delay []) >>>
          arr (uncurry (:)))

main = do
  print $ (addA f g) 2
  print $ (mulA f g) (1, 2)
  print $ first f (1, 2)
  print $ mapA (arr succ) [1..10]
  runKleisli (mapA (Kleisli print) >>> Kleisli print) [1..5]
  print $ runSF (mapA (delay 0)) [[1,2,3,16],[4,5,9],[6],[7,8],[9,10,11],[12,13,14,15]]


