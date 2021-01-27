require "Grid"
WINDOW_WIDTH = 650
WINDOW_HEIGHT = 450

CELL_SIZE = 25
COLUMNS = math.floor(WINDOW_WIDTH / CELL_SIZE)
ROWS = math.floor(WINDOW_HEIGHT / CELL_SIZE)
PADDING = 5
RADIUS = CELL_SIZE / 2 - PADDING
SEGMENTS = 20

function love.load()
  love.window.setTitle("Steering points - Points")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  grid = Grid:new(COLUMNS, ROWS)
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
