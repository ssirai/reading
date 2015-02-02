module Circuit where
import Control.Arrow hiding (ArrowLoop, loop)
import qualified Control.Category as C

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
          combine []            _      = []
 
delay :: b -> SF b b
delay x = SF (init . (x:))

edge :: SF Bool Bool
edge = arr id &&& delay False >>> arr detect
  where detect (a, b) = a && not b
 
class Arrow arr => ArrowLoop arr where
  loop :: arr (a, c) (b, c) -> arr a b

instance ArrowLoop (->) where
  loop f a = b
    where (b, c) = f (a, c)

instance ArrowLoop SF where
  loop (SF f) = SF $ \as ->
                  let (bs, cs) = unzip (f (zip as (stream cs))) in bs
                    where stream ~(x:xs) = x:stream xs

nor :: SF (Bool, Bool) Bool
nor = arr (not . uncurry (||))

flipflop =
  loop (arr (\((reset, set), ~(c, d)) -> ((set, d), (reset, c))) >>>
        nor *** nor >>>
        delay (False, True) >>>
        arr id &&& arr id)

