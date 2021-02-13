Point = {}
Point.__index = Point

function Point:new(x, y)
  this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Point:render()
  love.graphics.circle("fill", self.x, self.y, self.r, SEGMENTS)
end
