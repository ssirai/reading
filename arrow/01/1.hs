import System.Directory (getHomeDirectory)

(>>>) :: Monad m => Kleisli m a b -> Kleisli m b c -> Kleisli m a c
(f >>> g) a = do b <- f a
                 g b

type Kleisli m a b = a -> m b
arr f = return . f

printFile = readFile >>> putStrLn

count w = readFile >>> arr words >>> arr (filter (== w)) >>> arr length >>> print

main = do
  home <- getHomeDirectory
  printFile $ home ++ "/dev/reading/arrow/arrow.md"
 
