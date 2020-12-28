require "Boundary"
require "Ray"
WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("2D Ray Casting")
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  boundary = Boundary:create(WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT / 4, WINDOW_WIDTH * 3 / 4, WINDOW_HEIGHT * 3 / 4)
  ray = Ray:create(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function love.update()
end

function love.draw()
  boundary:render()
  ray:render()
end
