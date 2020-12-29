Boundary = {}
Boundary.__index = Boundary

function Boundary:create(x1, y1, x2, y2)
  this = {
    ["x1"] = x1,
    ["x2"] = x2,
    ["y1"] = y1,
    ["y2"] = y2
  }

  setmetatable(this, self)
  return this
end

function Boundary:render()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setLineWidth(5)
  love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end
