Grid = {}
Grid.__index = Grid

function Grid:new(points)
  this = {
    ["points"] = points
  }

  setmetatable(this, self)
  return this
end

function Grid:render()
  love.graphics.setColor(1, 1, 1, 1)
  for i, point in pairs(self.points) do
    point:render()
  end
end
