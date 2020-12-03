Grid = {}
Grid.__index = Grid

function Grid:new()
  local columns = COLUMNS
  local rows = ROWS
  local width = WINDOW_WIDTH - PADDING * 2
  local height = WINDOW_HEIGHT - PADDING * 2

  local cellWidth = math.floor(width / columns)
  local cellHeight = math.floor(height / rows)

  local cells = {}

  -- allow each cell to have up to four neighbors
  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      local neighbors = {}
      if row > 1 then
        table.insert(
          neighbors,
          {
            ["column"] = column,
            ["row"] = row - 1,
            ["gates"] = {"up", "down"}
          }
        )
      end

      if row < rows then
        table.insert(
          neighbors,
          {
            ["column"] = column,
            ["row"] = row + 1,
            ["gates"] = {"down", "up"}
          }
        )
      end

      if column < columns then
        table.insert(
          neighbors,
          {
            ["column"] = column + 1,
            ["row"] = row,
            ["gates"] = {"right", "left"}
          }
        )
      end

      if column > 1 then
        table.insert(
          neighbors,
          {
            ["column"] = column - 1,
            ["row"] = row,
            ["gates"] = {"left", "right"}
          }
        )
      end

      cells[column][row] = Cell:new(column, row, neighbors, cellWidth, cellHeight)
    end
  end

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
    ["width"] = width,
    ["height"] = height,
    ["cells"] = cells
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(4)

  for column = 1, self.columns do
    for row = 1, self.rows do
      self.cells[column][row]:render()
    end
  end
end

function Grid:aldousBroder()
  local randomColumn = love.math.random(self.columns)
  local randomRow = love.math.random(self.rows)
  local cell = self.cells[randomColumn][randomRow]
  cell.visited = true

  while true do
    local connection = cell.neighbors[love.math.random(#cell.neighbors)]
    local neighboringCell = self.cells[connection.column][connection.row]
    if not neighboringCell.visited then
      neighboringCell.visited = true
      cell.gates[connection.gates[1]] = nil
      neighboringCell.gates[connection.gates[2]] = nil
    end

    local allVisited = true
    for column = 1, self.columns do
      if allVisited then
        for row = 1, self.rows do
          if not self.cells[column][row].visited then
            allVisited = false
            break
          end
        end
      end
    end

    if allVisited then
      break
    else
      cell = neighboringCell
    end
  end
end
