Grid = {}
Grid.__index = Grid

function Grid:new()
  local points = {}

  this = {
    ["columns"] = COLUMNS,
    ["rows"] = ROWS,
    ["points"] = points,
    ["showGridLines"] = false
  }

  setmetatable(this, self)
  return this
end

function Grid:makeKey(column, row)
  return "c" .. column .. "r" .. row
end

function Grid:hasPoint(column, row)
  return self.points[self:makeKey(column, row)]
end

function Grid:toggleGridLines()
  self.showGridLines = not self.showGridLines
end

function Grid:addPoint(column, row)
  local x = (column - 1) * CELL_SIZE + CELL_SIZE / 2
  local y = (row - 1) * CELL_SIZE + CELL_SIZE / 2
  self.points[self:makeKey(column, row)] = Point:new(x, y)
end

function Grid:removePoint(column, row)
  self.points[self:makeKey(column, row)] = nil
end

function Grid:removePoints()
  self.points = {}
end

function Grid:render()
  love.graphics.setColor(1, 1, 1, 1)

  if self.showGridLines then
    love.graphics.setLineWidth(1)
    for column = 1, self.columns do
      love.graphics.line((column - 1) * CELL_SIZE, 0, (column - 1) * CELL_SIZE, WINDOW_HEIGHT)
    end
    for row = 1, self.rows do
      love.graphics.line(0, (row - 1) * CELL_SIZE, WINDOW_WIDTH, (row - 1) * CELL_SIZE)
    end
  end

  for i, point in pairs(self.points) do
    point:render()
  end
end
