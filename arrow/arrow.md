# Programming with Arrows

## Introduction

### 1.1 Point-free programming

英文の中にある単語がいくつ含まれているか数える関数 `count :: String -> String -> Int` を考える。

```haskell
count w = length . filter (==w) . words
```

このプログラムを変更して、あるテキストファイルの英文を読み出して単語を数え上げ、それを表示するようにしたい。

こんな風に書けたらいいな、と思わないだろうか？

```haskell
count w = print . length . filter (==w) . words . readFile
```

しかし Haskell ではこういう書き方は許されていない。

`readFile` は `String -> IO String`, `print` は `Show a => a -> IO ()` という IO モナドによって副作用を表現された関数だからだ。

これを関数合成風のスタイルで正しく表現するには次のように書く必要がある。

```haskell
count w = (>>= print) . liftM (length . filter (==w) . words) . readFile
```

しかしこの書き方は分かりづらい。より関数合成らしさを温存した記述を模索したい。

モナド `m` 上のクライスリ圏の射 `type Kleisli m a b = a -> m b` として表現された関数。

```haskell
readFile :: String -> IO String
readFile :: Kleisli IO String String
```

`a` を `b` にうつすクライスリ射 `Kleisli m a b` と `b` を `c` にうつす `Kleisli m b c` があったとき、その合成を考えることができる。

```haskell
(>>>) :: Monad m => Kleisli m a b -> Kleisli m b c -> Kleisli m a c
(f >>> g) a = do b <- f a
                 g b
```

### 1.2 Arrow class

`(->)` と `Kleisli m` が Arrow のインスタンスにできる。Arrow の構造に一般性があることが分かる。

### 1.3 Arrow as computation

モナドは出力に対してパラメトライズされている。Arrow は入力と出力の両方に対してパラメトライズされているのでより柔軟（特殊度が低いので使いづらいのは確か）。

どうでもいいが accomodate は accommodate のミススペル。

### 1.4 Arrow laws
