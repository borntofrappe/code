ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:new(particles)
  this = {
    ["particles"] = particles,
    ["mouse"] = LVector:new(-50, -50)
  }

  setmetatable(this, self)
  return this
end

function ParticleSystem:update(dt)
  self.mouse = LVector:new(love.mouse:getPosition())

  for i, particle in pairs(self.particles) do
    particle:update(dt)
    particle:applyBehaviors(self.mouse)
  end
end

function ParticleSystem:render()
  love.graphics.setColor(1, 1, 1, 1)
  for i, particle in pairs(self.particles) do
    particle:render()
  end
end
