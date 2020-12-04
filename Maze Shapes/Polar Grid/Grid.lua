Grid = {}
Grid.__index = Grid

function Grid:new()
  local rings = RINGS
  local ringCells = RING_CELLS

  local radius = math.floor((math.min(WINDOW_WIDTH, WINDOW_HEIGHT) - PADDING * 2) / 2)
  local angle = 2 * math.pi / ringCells

  local cells = {}

  for ring = 1, rings do
    cells[ring] = {}

    local innerRadius = (ring - 1) * radius / rings
    local outerRadius = ring * radius / rings

    for ringCell = 1, ringCells do
      local angleStart = (ringCell - 1) * angle
      local angleEnd = ringCell * angle

      local neighbors = {}
      if ring > 1 then
        table.insert(
          neighbors,
          {
            ["ring"] = ring - 1,
            ["ringCell"] = ringCell,
            ["gates"] = {"down", "up"}
          }
        )
      end
      if ring < rings then
        table.insert(
          neighbors,
          {
            ["ring"] = ring + 1,
            ["ringCell"] = ringCell,
            ["gates"] = {"up", "down"}
          }
        )
      end

      table.insert(
        neighbors,
        {
          ["ring"] = ring,
          ["ringCell"] = ringCell + 1 > ringCells and 1 or ringCell + 1,
          ["gates"] = {"right", "left"}
        }
      )

      table.insert(
        neighbors,
        {
          ["ring"] = ring,
          ["ringCell"] = ringCell - 1 < 1 and ringCells or ringCell - 1,
          ["gates"] = {"left", "right"}
        }
      )

      cells[ring][ringCell] = Cell:new(ring, ringCell, neighbors, innerRadius, outerRadius, angleStart, angleEnd)
    end
  end

  this = {
    ["rings"] = rings,
    ["ringCells"] = ringCells,
    ["radius"] = radius,
    ["cells"] = cells
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(5)

  for ring = 1, self.rings do
    for ringCell = 1, self.ringCells do
      self.cells[ring][ringCell]:render()
    end
  end
end

function Grid:recursiveBacktracker()
  -- pick a valid cell as a starting point
  local randomRing = love.math.random(self.rings)
  local randomRingCell = love.math.random(self.ringCells)

  local randomCell = self.cells[randomRing][randomRingCell]
  randomCell.visited = true

  local stack = {randomCell}

  while #stack > 0 do
    local cell = stack[#stack]
    local connection = cell.neighbors[love.math.random(#cell.neighbors)]
    local neighboringCell = self.cells[connection.ring][connection.ringCell]

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
          if not self.cells[candidateConnection.ring][candidateConnection.ringCell].visited then
            table.insert(candidateConnections, candidateConnection)
          end
        end

        if #candidateConnections > 0 then
          local candidateConnection = candidateConnections[love.math.random(#candidateConnections)]
          local candidateNeighbor = self.cells[candidateConnection.ring][candidateConnection.ringCell]

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
