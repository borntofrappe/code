Particle = {}
Particle.__index = Particle

function Particle:new(x, y)
  local target = LVector:new(x, y)
  local position =
    LVector:new(math.random(CELL_SIZE, WINDOW_WIDTH - CELL_SIZE), math.random(CELL_SIZE, WINDOW_HEIGHT - CELL_SIZE))

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
    ["r"] = (CELL_SIZE - CELL_PADDING) / 2
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

function Particle:applyBehaviors()
  local steeringForce = self:steer(self.target)
  self:applyForce(steeringForce)

  local frictionForce = self:getFriction()
  self:applyForce(frictionForce)

  local repelForce = self:repelMouse()
  if repelForce then
    self:applyForce(repelForce)
  end
end

function Particle:steer(target)
  local force = LVector:subtract(target, self.position)
  local d = force:getMagnitude()
  force:normalize()
  force:multiply(d * STEERING_MULTIPLIER)

  return force
end

function Particle:getFriction()
  local force = LVector:copy(self.velocity)
  local d = force:getMagnitude()

  force:normalize()
  force:multiply(d * FRICTION_MULTIPLIER * -1)

  return force
end

function Particle:repelMouse()
  local x, y = love.mouse:getPosition()
  local position = LVector:new(x, y)
  local force = LVector:subtract(position, self.position)
  local d = force:getMagnitude()

  if d < 10 then
    force:normalize()
    force:multiply(d * REPULSION_MULTIPLIER * -1)
    return force
  end
end
