Cell = {}
Cell.__index = Cell

function Cell:new(column, row, isUpright, neighbors)
  local side = CELL_SIDE
  local w = side
  local h = side * 3 ^ 0.5 / 2

  local cx = (column - 1) * (w / 2) + w / 2
  local cy = (row - 1) * h + h / 2
  local xWest = cx - w / 2
  local xMid = cx
  local xEast = cx + w / 2

  local yNorth = cy - h / 2
  local ySouth = cy + h / 2

  local gates = {}
  if isUpright then
    gates = {
      ["east"] = {
        ["x1"] = xMid,
        ["y1"] = yNorth,
        ["x2"] = xEast,
        ["y2"] = ySouth
      },
      ["south"] = {
        ["x1"] = xEast,
        ["y1"] = ySouth,
        ["x2"] = xWest,
        ["y2"] = ySouth
      },
      ["west"] = {
        ["x1"] = xWest,
        ["y1"] = ySouth,
        ["x2"] = xMid,
        ["y2"] = yNorth
      }
    }
  else
    gates = {
      ["north"] = {
        ["x1"] = xWest,
        ["y1"] = yNorth,
        ["x2"] = xEast,
        ["y2"] = yNorth
      },
      ["east"] = {
        ["x1"] = xEast,
        ["y1"] = yNorth,
        ["x2"] = xMid,
        ["y2"] = ySouth
      },
      ["west"] = {
        ["x1"] = xMid,
        ["y1"] = ySouth,
        ["x2"] = xWest,
        ["y2"] = yNorth
      }
    }
  end

  this = {
    ["column"] = column,
    ["row"] = row,
    ["neighbors"] = neighbors,
    ["side"] = side,
    ["gates"] = gates,
    ["visited"] = false
  }

  setmetatable(this, self)
  return this
end

function Cell:render()
  for i, gate in pairs(self.gates) do
    love.graphics.line(gate.x1, gate.y1, gate.x2, gate.y2)
  end
end
