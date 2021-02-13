Particle = {}
Particle.__index = Particle

function Particle:new(position, target, r)
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
    ["r"] = r,
    ["forceRadius"] = r * FORCE_RADIUS_MULTIPLIER,
    ["mouseRadius"] = r * MOUSE_RADIUS_MULTIPLIER
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

function Particle:updateTarget(target)
  self.target = target
  self:scatter()
end

function Particle:render()
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Particle:applyForce(force)
  self.acceleration:add(force)
end

function Particle:applyBehaviors(mouse)
  local dirTarget = LVector:subtract(self.target, self.position)
  local distanceTarget = dirTarget:getMagnitude()
  if distanceTarget > self.forceRadius then
    self:applyForce(self:steer(dirTarget, distanceTarget))
    self:applyForce(self:getFriction())
  end

  local dirMouse = LVector:subtract(mouse, self.position)
  local distanceMouse = dirMouse:getMagnitude()
  if distanceMouse < self.mouseRadius then
    self:applyForce(self:repelMouse(dirMouse, distanceMouse))
  end
end

function Particle:steer(force, distance)
  force:normalize()
  local randomNoise = LVector:new(math.random() - 0.5, math.random() - 0.5)
  randomNoise:multiply(NOISE_MULTIPLIER)
  force:add(randomNoise)
  force:multiply(distance * STEERING_MULTIPLIER)
  return force
end

function Particle:getFriction()
  local force = LVector:copy(self.velocity)
  force:multiply(FRICTION_MULTIPLIER * -1)
  return force
end

function Particle:repelMouse(force, distance)
  force:normalize()
  force:multiply(distance * REPULSION_MULTIPLIER * -1)
  return force
end

function Particle:scatter()
  local vx = math.random(SCATTER_VELOCITY_MIN, SCATTER_VELOCITY_MAX)
  local vy = math.random(SCATTER_VELOCITY_MIN, SCATTER_VELOCITY_MAX)
  if math.random() > 0.5 then
    vx = vx * -1
  end
  if math.random() > 0.5 then
    vy = vy * -1
  end

  local velocity = LVector:new(vx, vy)
  self.velocity = velocity
end
