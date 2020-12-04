require "Grid"
require "Cell"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
RINGS = 8
RING_CELLS = 6

function love.load()
  love.window.setTitle("Polar Adaptive Grid")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  grid = Grid:new()
  grid:recursiveBacktracker()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    grid = Grid:new()
    grid:recursiveBacktracker()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    grid = Grid:new()
    grid:recursiveBacktracker()
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  grid:render()
end
