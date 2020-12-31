Particle = {}
Particle.__index = Particle

function Particle:create(r, position, velocity, acceleration, color)
  this = {
    ["r"] = r,
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
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

function Particle:update(dt)
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt

  self.velocity.x = self.velocity.x + self.acceleration.x * dt
  self.velocity.y = self.velocity.y + self.acceleration.y * dt

  -- self.acceleration.x = 0
  -- self.acceleration.y = 0
end

function Particle:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Particle:attract(target)
  local force = {}
  force.x = target.position.x - self.position.x
  force.y = target.position.y - self.position.y

  local magnitude = (force.x ^ 2 + force.y ^ 2) ^ 0.5

  local distanceSquared = magnitude ^ 2
  distanceSquared = math.min(500, math.max(50, distanceSquared))
  local g = GRAVITATIONAL_CONSTANT

  local strength = g / distanceSquared

  force.x = force.x * strength / magnitude
  force.y = force.y * strength / magnitude

  self.acceleration.x = force.x
  self.acceleration.y = force.y
end
