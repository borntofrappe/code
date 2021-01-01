Attractor = {}
Attractor.__index = Attractor

function Attractor:create(r, position, color)
  this = {
    ["r"] = r,
    ["position"] = position,
    ["color"] = color or
      {
        ["r"] = 1,
        ["g"] = 1,
        ["b"] = 1
      }
  }

  setmetatable(this, self)
  return this
end

function Attractor:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
