import Control.Arrow
import qualified Control.Category as C

listcase [] = Left ()
listcase (x:xs) = Right (x, xs)
 
filterA :: ArrowChoice arr => arr a Bool -> arr [a] [a]
filterA = undefined

main = undefined
