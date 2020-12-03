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

function Grid:wilson()
  --[[
    unvisited is a table collecting the column and row for unvisited cells
    
    {
      column,
      row
    }
  ]]
  local unvisited = {}
  for column = 1, self.columns do
    for row = 1, self.rows do
      table.insert(
        unvisited,
        {
          ["column"] = column,
          ["row"] = row
        }
      )
    end
  end

  local randomUnvisited = table.remove(unvisited, love.math.random(#unvisited))
  self.cells[randomUnvisited.column][randomUnvisited.row].visited = true

  while #unvisited > 0 do
    local randomUnvisited = unvisited[love.math.random(#unvisited)]

    --[[
    randomWalk is a table collecting the column, row and gates for the cells picked in the random walk
    
    {
      column,
      row,
      gates
    }
  ]]
    local randomWalk = {
      {
        ["column"] = randomUnvisited.column,
        ["row"] = randomUnvisited.row,
        ["gates"] = {}
      }
    }

    while true do
      local lastWalked = randomWalk[#randomWalk]
      local cell = self.cells[lastWalked.column][lastWalked.row]
      local connection = cell.neighbors[love.math.random(#cell.neighbors)]
      local neighboringCell = self.cells[connection.column][connection.row]

      table.insert(lastWalked.gates, connection.gates[1])

      table.insert(
        randomWalk,
        {
          ["column"] = neighboringCell.column,
          ["row"] = neighboringCell.row,
          ["gates"] = {connection.gates[2]}
        }
      )

      -- do not consider the last table as it refers to the neighboring cell
      for i = 1, #randomWalk - 1 do
        local walked = randomWalk[i]
        if walked.column == neighboringCell.column and walked.row == neighboringCell.row then
          lastWalked.gates = {}
          randomWalk = {
            {
              ["column"] = neighboringCell.column,
              ["row"] = neighboringCell.row,
              ["gates"] = {}
            }
          }
          break
        end
      end

      if neighboringCell.visited then
        break
      end
    end

    for i, walked in ipairs(randomWalk) do
      self.cells[walked.column][walked.row].visited = true
      for j, gate in ipairs(walked.gates) do
        self.cells[walked.column][walked.row].gates[gate] = nil
      end

      for j = #unvisited, 1, -1 do
        if walked.column == unvisited[j].column and walked.row == unvisited[j].row then
          table.remove(unvisited, j)
        end
      end
    end
  end
end
