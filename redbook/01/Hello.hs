import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT

main :: IO ()
main = do
  _ <- getArgsAndInitialize
  initialDisplayMode $= [SingleBuffered, RGBMode]
  initialWindowSize $= Size 250 250
  initialWindowPosition $= Position 100 100
  _ <- createWindow "Hello, world"
  clearColor $= Color4 0 0 1 0
  displayCallback $= do
    clear [ColorBuffer]
    color $ Color3 1.0 1.0 (1.0 :: GLfloat)
    ortho 0.0 1.0 0 1 (-1) 1.0
    renderPrimitive Polygon $ mapM_ (vertex :: Vertex3 GLfloat -> IO ())
      [ Vertex3 0.25 0.25 0.0,
        Vertex3 0.75 0.25 0.0,
        Vertex3 0.75 0.75 0.0,
        Vertex3 0.25 0.75 0.0 ]
    flush
  mainLoop

 

