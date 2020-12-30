Particle = {}
Particle.__index = Particle

function Particle:create(x, y)
  this = {
    ["x"] = x,
    ["y"] = y
  }

  setmetatable(this, self)
  return this
end

function Particle:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.circle("fill", self.x, self.y, RADIUS_PARTICLE)
end
