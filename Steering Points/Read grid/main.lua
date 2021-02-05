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

function love.load()
  local columns = STRING:find("\n") - 1
  local string, rows = STRING:gsub("\n", "")
  rows = rows + 1

  CELL_SIZE = 15
  PADDING = 2
  RADIUS = CELL_SIZE / 2 - PADDING

  WINDOW_WIDTH = CELL_SIZE * columns
  WINDOW_HEIGHT = CELL_SIZE * rows

  love.window.setTitle("Steering points - Read grid")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  grid = Grid:new(columns, rows)

  for i = 1, #string do
    if string:sub(i, i) == "o" then
      local column = ((i - 1) % columns) + 1
      local row = math.floor(i / columns) + 1
      grid:addPoint(column, row)
    end
  end
end

function love.keypressed(key)
  local key = key:lower()
  if key == "e" then
    grid:removePoints()
  elseif key == "g" then
    grid:toggleGridLines()
  elseif key == "t" then
    local characters = {}
    for i = 1, COLUMNS * ROWS do
      characters[#characters + 1] = "x"
    end

    for i, point in pairs(grid.points) do
      local column = math.floor(point.x / CELL_SIZE) + 1
      local row = math.floor(point.y / CELL_SIZE) + 1

      local index = column + (row - 1) * COLUMNS
      characters[index] = "o"
    end

    for r = 1, ROWS - 1 do
      local index = (COLUMNS + 1) * r
      table.insert(characters, index, "\n")
    end

    local string = table.concat(characters)
    love.filesystem.setIdentity("Points")
    love.filesystem.write("points.txt", string)
  elseif key == "p" then
    love.filesystem.setIdentity("Points")
    love.graphics.captureScreenshot("points.png")
  elseif key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    local column = math.floor(x / CELL_SIZE) + 1
    local row = math.floor(y / CELL_SIZE) + 1

    if not grid:hasPoint(column, row) then
      grid:addPoint(column, row)
    end
  end

  if love.mouse.isDown(2) then
    local x, y = love.mouse:getPosition()
    local column = math.floor(x / CELL_SIZE) + 1
    local row = math.floor(y / CELL_SIZE) + 1

    if grid:hasPoint(column, row) then
      grid:removePoint(column, row)
    end
  end
end

function love.draw()
  grid:render()
end