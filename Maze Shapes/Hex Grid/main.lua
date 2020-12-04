require "Grid"
require "Cell"

COLUMNS = 10
ROWS = 8
CELL_SIDE = 30
PADDING = 25

WINDOW_WIDTH = 3 * COLUMNS * CELL_SIDE / 2 + CELL_SIDE / 2 + PADDING * 2
WINDOW_HEIGHT = ROWS * (CELL_SIDE * 3 ^ 0.5 / 2) * 2 + CELL_SIDE * 3 ^ 0.5 / 2 + PADDING * 2

function love.load()
  love.window.setTitle("Hex Grid")
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
  love.graphics.translate(PADDING, PADDING)
  grid:render()
end
