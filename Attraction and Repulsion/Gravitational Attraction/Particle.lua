Particle = {}
Particle.__index = Particle

function Particle:create(r, position, velocity, acceleration, color)
  this = {
    ["r"] = r,
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["trail"] = {position.x, position.y},
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
  self.position.x = self.position.x + self.velocity.x * dt * UPDATE_SPEED
  self.position.y = self.position.y + self.velocity.y * dt * UPDATE_SPEED

  self.velocity.x = self.velocity.x + self.acceleration.x * dt * UPDATE_SPEED
  self.velocity.y = self.velocity.y + self.acceleration.y * dt * UPDATE_SPEED

  local velocityMagnitude = (self.velocity.x ^ 2 + self.velocity.y ^ 2) ^ 0.5

  if velocityMagnitude > VELOCITY_MAGNITUDE_LIMIT then
    self.velocity.x = self.velocity.x / velocityMagnitude * VELOCITY_MAGNITUDE_LIMIT
    self.velocity.y = self.velocity.y / velocityMagnitude * VELOCITY_MAGNITUDE_LIMIT
  end

  table.insert(self.trail, self.position.x)
  table.insert(self.trail, self.position.y)
  if #self.trail > TRAIL_MAX then
    table.remove(self.trail, 1)
    table.remove(self.trail, 1)
  end
end

function Particle:render()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)

  love.graphics.setColor(self.color.r, self.color.g, self.color.b, OPACITY_TRAIL)
  love.graphics.setLineWidth(LINE_WIDTH_PARTICLE)
  love.graphics.line(self.trail)
end

function Particle:attract(target)
  local force = {
    ["x"] = target.position.x - self.position.x,
    ["y"] = target.position.y - self.position.y
  }

  local magnitude = (force.x ^ 2 + force.y ^ 2) ^ 0.5
  local distance = magnitude

  distance = math.min(DISTANCE_MAX, math.max(DISTANCE_MIN, distance))
  local G = GRAVITATIONAL_CONSTANT

  local strength = G / (distance ^ 2)

  force.x = force.x * strength / magnitude
  force.y = force.y * strength / magnitude

  self.acceleration.x = force.x
  self.acceleration.y = force.y
end
