require "Grid"
require "Cell"
Timer = require "Timer"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 25
COLUMNS = 10
ROWS = 10
DELAY = 0.1

function love.load()
  love.window.setTitle("Algorithms — Simplified Dijkstra")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.17, 0.17, 0.17)

  grid = Grid:new()
  grid:sidewinder()

  -- starting point for dijkstra
  cell = {
    ["column"] = 1,
    ["row"] = 1,
    ["width"] = grid.cells[1][1].width,
    ["height"] = grid.cells[1][1].height
  }
end

function love.update(dt)
  Timer:update(dt)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    Timer:reset()

    grid = Grid:new()
    grid:sidewinder()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end

  if key == "r" then
    Timer:reset()

    grid = Grid:new()
    grid:sidewinder()
  end

  if key == "up" then
    cell.row = math.max(1, cell.row - 1)
  elseif key == "right" then
    cell.column = math.min(grid.columns, cell.column + 1)
  elseif key == "down" then
    cell.row = math.min(grid.rows, cell.row + 1)
  elseif key == "left" then
    cell.column = math.max(1, cell.column - 1)
  end

  if key == "return" then
    for r = 1, grid.rows do
      for c = 1, grid.columns do
        grid.cells[r][c].distance = nil
      end
    end

    Timer:reset()

    dijkstra(grid.cells[cell.column][cell.row], 0)
  end
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)
  grid:render()

  love.graphics.setColor(1, 1, 1, 0.2)
  love.graphics.rectangle("fill", (cell.column - 1) * cell.width, (cell.row - 1) * cell.height, cell.width, cell.height)
end

function dijkstra(cell, distance)
  grid.cells[cell.column][cell.row].distance = distance
  local neighbors = {
    {
      ["gate"] = "up",
      ["dr"] = -1,
      ["dc"] = 0
    },
    {
      ["gate"] = "right",
      ["dr"] = 0,
      ["dc"] = 1
    },
    {
      ["gate"] = "down",
      ["dr"] = 1,
      ["dc"] = 0
    },
    {
      ["gate"] = "left",
      ["dr"] = 0,
      ["dc"] = -1
    }
  }
  for i = #neighbors, 1, -1 do
    local neighbor = neighbors[i]
    if
      not grid.cells[cell.column + neighbor.dc] or not grid.cells[cell.column + neighbor.dc][cell.row + neighbor.dr] or
        grid.cells[cell.column + neighbor.dc][cell.row + neighbor.dr].distance or
        cell.gates[neighbor.gate]
     then
      table.remove(neighbors, i)
    end
  end

  for i, neighbor in ipairs(neighbors) do
    local neighboringCell = grid.cells[cell.column + neighbor.dc][cell.row + neighbor.dr]
    Timer:after(
      DELAY,
      function()
        dijkstra(neighboringCell, distance + 1)
      end
    )
  end
end
