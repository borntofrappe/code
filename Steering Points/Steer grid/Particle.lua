Particle = {}
Particle.__index = Particle

function Particle:new(x, y)
  local position = LVector:new(x, y)
  local target = LVector:copy(position)

  local vx = math.random(VELOCITY_MIN, VELOCITY_MAX)
  local vy = math.random(VELOCITY_MIN, VELOCITY_MAX)
  if math.random() > 0.5 then
    vx = vx * -1
  end
  if math.random() > 0.5 then
    vy = vy * -1
  end
  local velocity = LVector:new(vx, vy)
  local acceleration = LVector:new(0, 0)
  this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["target"] = target,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Particle:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))

  self.velocity:limit(VELOCITY_LIMIT)
  self.acceleration:multiply(0)
end

function Particle:render()
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Particle:applyForce(force)
  self.acceleration:add(force)
end

function Particle:attract(target)
  local force = LVector:subtract(target, self.position)
  local d = force:getMagnitude()
  force:normalize()
  force:multiply(d)

  return force
end

function Particle:getFriction()
  local force = LVector:copy(self.velocity)
  local d = force:getMagnitude()

  force:normalize()
  force:divide(2)
  force:multiply(d * -1)

  return force
end

function Particle:repelMouse()
  local x, y = love.mouse:getPosition()
  local position = LVector:new(x, y)
  local force = LVector:subtract(position, self.position)
  local d = force:getMagnitude()

  if d < RADIUS * 4 then
    force:normalize()
    force:multiply(d * 4 * -1)
    return force
  end
end
