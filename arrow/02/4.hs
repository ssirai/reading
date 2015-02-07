{-# LANGUAGE OverlappingInstances #-}
import Control.Arrow hiding (ArrowApply, ArrowMonad, app)
import qualified Control.Arrow as A

class Arrow arr => ArrowApply arr where
  app :: arr (arr a b, a) b

instance ArrowApply (->) where
  app (f, x) = f x

instance Monad m => ArrowApply (Kleisli m) where
  app = Kleisli (\(Kleisli f, x) -> f x)

newtype ArrowMonad arr a = ArrowMonad (arr () a)

instance ArrowApply a => Monad (ArrowMonad a) where
  return x = ArrowMonad (arr (const x))
  ArrowMonad m >>= f =
    ArrowMonad (m >>>
                arr (\x -> let ArrowMonad h = f x in (h, ())) >>>
                app)


main = undefined
