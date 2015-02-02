import Control.Arrow hiding (ArrowApply)

class Arrow arr => ArrowApply arr where
  app :: arr (arr a b, a) b

instance ArrowApply (->) where
  app (f, x) = f x

instance Monad m => ArrowApply (Kleisli m) where
  app = Kleisli (\(Kleisli f, x) -> f x)

main = undefined
