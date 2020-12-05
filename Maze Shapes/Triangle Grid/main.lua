require "Grid"
require "Cell"

COLUMNS = 21
ROWS = 10
CELL_SIDE = 50
PADDING = 25

WINDOW_WIDTH =
  COLUMNS % 2 == 1 and math.ceil(COLUMNS / 2) * CELL_SIDE + PADDING * 2 or
  math.ceil(COLUMNS / 2) * CELL_SIDE + PADDING * 2 + CELL_SIDE / 2
WINDOW_HEIGHT = ROWS * CELL_SIDE * 3 ^ 0.5 / 2 + PADDING * 2

function love.load()
  love.window.setTitle("Triangle Grid")
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
