require "Particle"

Firework = {}
Firework.__index = Firework

function Firework:create()
  --[[ firework body
    initialize a particle moving upwards from the bottom of the window
  ]]
  local r = RADIUS_FIREWORK

  local color = {
    ["r"] = love.math.random(COLOR_MIN, COLOR_MAX) / COLOR_MAX,
    ["g"] = love.math.random(COLOR_MIN, COLOR_MAX) / COLOR_MAX,
    ["b"] = love.math.random(COLOR_MIN, COLOR_MAX) / COLOR_MAX
  }

  local position = {
    ["x"] = love.math.random(WINDOW_WIDTH),
    ["y"] = WINDOW_HEIGHT
  }

  local velocity = {
    ["x"] = 0,
    ["y"] = love.math.random(VELOCITY_MIN, VELOCITY_MAX) * -1
  }

  local acceleration = {
    ["x"] = 0,
    ["y"] = GRAVITY
  }

  local particle = Particle:create(r, position, velocity, acceleration, color)

  -- table storing the particles radiating from the explosion
  local particles = {}

  --[[ controlling booleans
  - hasExploded, to show/update the particles
  - hasExpired, to remove the firework as the particles disappear
  - isHeartShaped, to change the vector describing the velocity
  ]]
  local hasExploded = false
  local hasExpired = false
  local isHeartShaped = love.math.random(ODDS_HEART_SHAPE) == 1

  this = {
    ["particle"] = particle,
    ["particles"] = particles,
    ["hasExploded"] = hasExploded,
    ["hasExpired"] = hasExpired,
    ["isHeartShaped"] = isHeartShaped
  }

  setmetatable(this, self)
  return this
end

function Firework:update(dt)
  if not self.hasExploded then
    self.particle:update(dt)

    -- explosion when the body of the firework reaches the tallest point
    if self.particle.velocity.y > 0 then
      self.hasExploded = true
      self.particle.velocity.y = 0
      self.particle.acceleration.y = 0

      for i = 1, PARTICLES do
        --[[ particles
          initialize a particle from the position of the exploding entity
        ]]
        local r = RADIUS_PARTICLE

        local position = {
          ["x"] = self.particle.position.x,
          ["y"] = self.particle.position.y
        }

        local vx, vy

        if self.isHeartShaped then
          local t = i / PARTICLES * math.pi * 2
          vx = 16 * math.sin(t) ^ 3
          vy = (13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t))

          vx = vx * MULTIPLIER_HEART_SHAPE + love.math.random(OFFSET_HEART_SHAPE_MAX)
          vy = vy * MULTIPLIER_HEART_SHAPE * -1 + love.math.random(OFFSET_HEART_SHAPE_MAX)
        else
          local angle = math.rad(love.math.random(360))
          local radius = love.math.random(VELOCITY_PARTICLE)
          vx = math.cos(angle) * radius
          vy = math.sin(angle) * radius
        end

        local velocity = {
          ["x"] = vx,
          ["y"] = vy
        }

        local acceleration = {
          ["x"] = 0,
          ["y"] = GRAVITY_PARTICLE
        }

        local color = {
          ["r"] = self.particle.color.r,
          ["g"] = self.particle.color.g,
          ["b"] = self.particle.color.b
        }

        table.insert(self.particles, Particle:create(r, position, velocity, acceleration, color))
      end
    end
  else
    -- reduce the radius of the particles and remove the items from the table as they are removed from sight (0 radius)
    for i = #self.particles, 1, -1 do
      local particle = self.particles[i]
      particle:update(dt)
      particle.r = math.max(0, particle.r - dt)
      if particle.r == 0 then
        table.remove(self.particles, i)
      end
    end

    if #self.particles == 0 then
      self.hasExpired = true
    end
  end
end

function Firework:render()
  if not self.hasExploded then
    self.particle:render()
  else
    if not self.hasExpired then
      for i, particle in ipairs(self.particles) do
        particle:render()
      end
    end
  end
end
