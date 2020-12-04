Grid = {}
Grid.__index = Grid

function Grid:new()
  local mask =
    [[xoooooooox
    ooooxxoooo
    oooxxxxooo
    ooooxxoooo
    xoooooooox
    xoooooooox
    ooooxxoooo
    oooxxxxooo
    ooooxxoooo
    xoooooooox
  ]]
  mask = mask:gsub("[^xo]", "")

  local columns = math.floor((#mask) ^ 0.5)
  local rows = math.floor((#mask) ^ 0.5)
  local width = WINDOW_WIDTH - PADDING * 2
  local height = WINDOW_HEIGHT - PADDING * 2

  local cellWidth = math.floor(width / columns)
  local cellHeight = math.floor(height / rows)

  local cells = {}

  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      local index = column + (row - 1) * columns
      -- add a cell only for 'o' characters
      if mask:sub(index, index) == "o" then
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
      else
        cells[column][row] = nil
      end
    end
  end

  -- remove nil neighbors from non-nil cells
  for column = 1, columns do
    for row = 1, rows do
      local cell = cells[column][row]
      if cell then
        for i = #cell.neighbors, 1, -1 do
          local neighbor = cell.neighbors[i]
          local neighboringCell = cells[neighbor.column][neighbor.row]
          if not neighboringCell then
            table.remove(cell.neighbors, i)
          end
        end
      end
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
  love.graphics.setLineWidth(5)

  for column = 1, self.columns do
    for row = 1, self.rows do
      if self.cells[column][row] then
        self.cells[column][row]:render()
      end
    end
  end
end

function Grid:recursiveBacktracker()
  -- pick a valid cell as a starting point
  local randomCell = nil
  while not randomCell do
    local randomColumn = love.math.random(self.columns)
    local randomRow = love.math.random(self.rows)
    randomCell = self.cells[randomColumn][randomRow]
  end

  randomCell.visited = true

  local stack = {randomCell}

  while #stack > 0 do
    local cell = stack[#stack]
    local connection = cell.neighbors[love.math.random(#cell.neighbors)]
    local neighboringCell = self.cells[connection.column][connection.row]

    if not neighboringCell.visited then
      neighboringCell.gates[connection.gates[2]] = nil
      cell.gates[connection.gates[1]] = nil
      neighboringCell.visited = true
      table.insert(stack, neighboringCell)
    else
      while #stack > 0 do
        local candidate = table.remove(stack)
        local connections = candidate.neighbors
        local candidateConnections = {}
        for i, candidateConnection in ipairs(connections) do
          if not self.cells[candidateConnection.column][candidateConnection.row].visited then
            table.insert(candidateConnections, candidateConnection)
          end
        end

        if #candidateConnections > 0 then
          local candidateConnection = candidateConnections[love.math.random(#candidateConnections)]
          local candidateNeighbor = self.cells[candidateConnection.column][candidateConnection.row]

          candidate.gates[candidateConnection.gates[1]] = nil
          candidateNeighbor.gates[candidateConnection.gates[2]] = nil
          candidateNeighbor.visited = true
          table.insert(stack, candidate)
          table.insert(stack, candidateNeighbor)
        end
      end
    end
  end
end
