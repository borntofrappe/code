Cell = {}
Cell.__index = Cell

function Cell:new(column, row, neighbors)
  local side = CELL_SIDE
  local a = side / 2
  local b = side * 3 ^ 0.5 / 2
  local cx = (column - 1) * (side + a) + side
  local cy = column % 2 == 0 and (row - 1) * b * 2 + b + b or (row - 1) * b * 2 + b
  local xFarWest = cx - side
  local xNearWest = cx - a
  local xNearEast = cx + a
  local xFarEast = cx + side

  local yNorth = cy - b
  local yMid = cy
  local ySouth = cy + b

  -- local width = side * 2
  -- local height = b * 2

  this = {
    ["column"] = column,
    ["row"] = row,
    ["neighbors"] = neighbors,
    ["side"] = side,
    ["gates"] = {
      ["north"] = {
        ["x1"] = xNearWest,
        ["y1"] = yNorth,
        ["x2"] = xNearEast,
        ["y2"] = yNorth
      },
      ["north-east"] = {
        ["x1"] = xNearEast,
        ["y1"] = yNorth,
        ["x2"] = xFarEast,
        ["y2"] = yMid
      },
      ["south-east"] = {
        ["x1"] = xFarEast,
        ["y1"] = yMid,
        ["x2"] = xNearEast,
        ["y2"] = ySouth
      },
      ["south"] = {
        ["x1"] = xNearEast,
        ["y1"] = ySouth,
        ["x2"] = xNearWest,
        ["y2"] = ySouth
      },
      ["south-west"] = {
        ["x1"] = xNearWest,
        ["y1"] = ySouth,
        ["x2"] = xFarWest,
        ["y2"] = yMid
      },
      ["north-west"] = {
        ["x1"] = xFarWest,
        ["y1"] = yMid,
        ["x2"] = xNearWest,
        ["y2"] = yNorth
      }
    },
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
