Particle = {}
Particle.__index = Particle

function Particle:create(r, position, velocity, acceleration)
  this = {
    ["r"] = r,
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration
  }

  setmetatable(this, self)
  return this
end

function Particle:applyForce(force)
  self.acceleration.x = self.acceleration.x + force.x
  self.acceleration.y = self.acceleration.y + force.y
end

function Particle:update(dt)
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt

  self.velocity.x = self.velocity.x + self.acceleration.x * dt
  self.velocity.y = self.velocity.y + self.acceleration.y * dt
end

function Particle:render()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
