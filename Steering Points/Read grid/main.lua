require "Point"
require "Grid"

SEGMENTS = 20
STRING =
  [[xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxoooxxxoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxoooooxooooxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxooooooooooxxxxxxxxoxxxxxoxxxxxxxxxxxxxxx
xxxxxxxxxxxxoooooooooooxxxxooxxxxxxxxooxxxxxxxxxxxxxx
xxxxxxxxxxoxxxoxoooooooxxxxoxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxooxxooooooooooxxxxxxxxxooxxxxooxxxxxxxxxxxxx
xxxxxxxxoooxoooxxxooooxxxxxxxxxxoxxxooooxxxooxxxxxxxx
xxxxxxxxoooooooxxxooooxxxxxxxxxxoxxoooooooxooxxxxxxxx
xxxoooxxxxooxoooxxoooxxxxxxxxoxxxxooooooooooooooooxxx
xxxooooooooooooxxxoooxxoxxxoooooxoooooooooooooooooxxx
xxxxooooooooooxxxxooxxooxoooooooooooooooooooooooxxxxx
xxxooooooooooxxoxxoxxxxxxoooxoooooooooooooooooooxxxxx
xxxooxxoooooooxooxxxxxxxoxxxoooooooooooooooooooxxxxxx
xxxxxxxxooooooooooxxxxxxxoooooooooooooooooooxooxxxxxx
xxxxxxxxooooooooooxxxxxxxoooooooooooooooooooxooxxxxxx
xxxxxxxxoooooooooxxxxxxxooxooxoxoooooooooooxoxoxxxxxx
xxxxxxxxxooooooxxxxxxxxxoxxoooooooooooooooxooxxxxxxxx
xxxxxxxxxxoooooxxxxxxxxoooooxxoxoooooooooxooxxxxxxxxx
xxxxxxxxxxxooxxooxxxxxoooooooooooxoooooooxxxxxxxxxxxx
xxxxxxxxxxxoooxxxxxxxxooooooooooxxxooxooxxxxxxxxxxxxx
xxxxxxxxxxxxxxooooxxxxxoooooooooxxxoxxxxxoxxxxxxxxxxx
xxxxxxxxxxxxxxoooooxxxxxxxooooooxxxxxooxoxxoxxxxxxxxx
xxxxxxxxxxxxxxooooooxxxxxxoooooxxxxxxxoooxxooxxxxxxxx
xxxxxxxxxxxxxxooooooxxxxxxooooxxxxxxxxxxxxooxxxxxxxxx
xxxxxxxxxxxxxxxooooxxxxxxxooooxoxxxxxxxxxooooxxxxxxxx
xxxxxxxxxxxxxxxooooxxxxxxxxooxxoxxxxxxxxooooooxxxxxxx
xxxxxxxxxxxxxxxoooxxxxxxxxxxoxxxxxxxxxxxooooooxxxxxxx
xxxxxxxxxxxxxxxoooxxxxxxxxxxxxxxxxxxxxxxoxxooxxxoxxxx
xxxxxxxxxxxxxxxooxxxxxxxxxxxxxxxxxoxxxxxxxxxxxxoxxxxx
xxxxxxxxxxxxxxxoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx]]

CELL_SIZE = 15
PADDING = 2
RADIUS = CELL_SIZE / 2 - PADDING

function love.load()
  local columns = STRING:find("\n") - 1
  local string, rows = STRING:gsub("\n", "")
  rows = rows + 1

  WINDOW_WIDTH = CELL_SIZE * columns
  WINDOW_HEIGHT = CELL_SIZE * rows

  love.window.setTitle("Steering points - Read grid")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  local points = {}
  for i = 1, #string do
    if string:sub(i, i) == "o" then
      local column = ((i - 1) % columns) + 1
      local row = math.floor(i / columns) + 1

      local x = (column - 1) * CELL_SIZE + CELL_SIZE / 2
      local y = (row - 1) * CELL_SIZE + CELL_SIZE / 2

      local key = "c" .. column .. "r" .. row
      points[key] = Point:new(x, y)
    end
  end

  grid = Grid:new(points)
end

function love.draw()
  grid:render()
end
