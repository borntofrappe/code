Grid = {}
Grid.__index = Grid

function Grid:new()
  local columns = COLUMNS
  local rows = ROWS

  local cells = {}

  for column = 1, columns do
    cells[column] = {}
    for row = 1, rows do
      local isUpright = (column + row) % 2 == 0
      local neighbors = {}

      if row > 1 then
        if not isUpright then
          table.insert(
            neighbors,
            {
              ["column"] = column,
              ["row"] = row - 1,
              ["gates"] = {"north", "south"}
            }
          )
        end
      end

      if row < rows then
        if isUpright then
          table.insert(
            neighbors,
            {
              ["column"] = column,
              ["row"] = row + 1,
              ["gates"] = {"south", "north"}
            }
          )
        end
      end

      if column > 1 then
        table.insert(
          neighbors,
          {
            ["column"] = column - 1,
            ["row"] = row,
            ["gates"] = {"west", "east"}
          }
        )
      end

      if column < columns then
        table.insert(
          neighbors,
          {
            ["column"] = column + 1,
            ["row"] = row,
            ["gates"] = {"east", "west"}
          }
        )
      end

      cells[column][row] = Cell:new(column, row, isUpright, neighbors)
    end
  end

  this = {
    ["columns"] = columns,
    ["rows"] = rows,
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
      self.cells[column][row]:render()
    end
  end
end

function Grid:recursiveBacktracker()
  local randomColumn = love.math.random(self.columns)
  local randomRows = love.math.random(self.rows)

  local randomCell = self.cells[randomColumn][randomRows]
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
