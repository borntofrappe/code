Particle = {}
Particle.__index = Particle

function Particle:create(x, y)
  local rays = {}
  for i = 1, 360 do
    local angle = math.rad(i)
    table.insert(rays, Ray:create(x, y, angle))
  end

  this = {
    ["x"] = x,
    ["y"] = y,
    ["rays"] = rays
  }

  setmetatable(this, self)
  return this
end

function Particle:render()
  love.graphics.setColor(1, 1, 1, OPACITY_PARTICLE)
  love.graphics.circle("fill", self.x, self.y, RADIUS_PARTICLE)
  -- -- render the lines describing the rays from the particle (the points casted against the boundaries draw above these lines)
  -- for i, ray in ipairs(self.rays) do
  --   ray:render()
  -- end
end

function Particle:cast(boundaries)
  local points = {}
  for i, ray in ipairs(self.rays) do
    local closestPoint = nil
    local closestDistance = nil
    for j, boundary in ipairs(boundaries) do
      local point = ray:cast(boundary)
      if point then
        local distance = ((point.x - self.x) ^ 2 + (point.y - self.y) ^ 2) ^ 0.5
        if not closestDistance or distance < closestDistance then
          closestDistance = distance
          closestPoint = point
        end
      end
    end
    if closestPoint then
      table.insert(points, closestPoint)
    end
  end

  return points
end

function Particle:move(x, y)
  self.x = x
  self.y = y

  -- update the rays position to match the new point of reference
  for i, ray in ipairs(self.rays) do
    ray.x = x
    ray.y = y
  end
end
