require "Particle"
require "Firework"

WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
RADIUS_FIREWORK = 2
RADIUS_PARTICLE = 1.5
FIREWORKS = 5
PARTICLES = 100
VELOCITY_MIN = 380
VELOCITY_MAX = 580
VELOCITY_PARTICLE = 80
GRAVITY_PARTICLE = 200
GRAVITY = 450

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.window.setTitle("Fireworks")
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)

  fireworks = {}
  for i = 1, FIREWORKS do
    table.insert(fireworks, Firework:create())
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  for i = #fireworks, 1, -1 do
    local firework = fireworks[i]
    firework:update(dt)
    if firework.hasExpired then
      table.remove(fireworks, i)
      table.insert(fireworks, Firework:create())
    end
  end
end

function love.draw()
  for i, firework in ipairs(fireworks) do
    firework:render()
  end

  love.graphics.print(#fireworks[1].particles, 8, 8)
end
