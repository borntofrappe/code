Particle = {}
Particle.__index = Particle

function Particle:create(r, position, velocity, acceleration, color)
  this = {
    ["r"] = r,
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["history"] = {position.x, position.y},
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

  table.insert(self.history, self.position.x)
  table.insert(self.history, self.position.y)

  if #self.history > HISTORY_MAX then
    table.remove(self.history, 1)
    table.remove(self.history, 1)
  end
end

function Particle:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)

  love.graphics.setColor(self.color.r, self.color.g, self.color.b, OPACITY_TRAIL)
  love.graphics.setLineWidth(LINE_WIDTH_PARTICLE)
  love.graphics.line(self.history)
end

function Particle:attract(target)
  local force = {}
  force.x = target.position.x - self.position.x
  force.y = target.position.y - self.position.y

  local magnitude = (force.x ^ 2 + force.y ^ 2) ^ 0.5

  local distanceSquared = magnitude ^ 2
  distanceSquared = math.min(DISTANCE_MAX, math.max(DISTANCE_MIN, distanceSquared))
  local g = GRAVITATIONAL_CONSTANT

  local strength = g / distanceSquared

  force.x = force.x * strength / magnitude
  force.y = force.y * strength / magnitude

  self.acceleration.x = force.x
  self.acceleration.y = force.y
end
