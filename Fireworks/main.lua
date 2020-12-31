require "Firework"

COLOR_MIN = 50
COLOR_MAX = 255
ODDS_FIREWORK = 40
ODDS_HEART_SHAPE = 5

function love.load()
  love.window.setTitle("Fireworks")
  love.graphics.setBackgroundColor(0, 0, 0)
  love.window.setMode(0, 0)

  WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
  -- adjust the controlling variables according to the size of the window
  VELOCITY_MIN = WINDOW_HEIGHT * 0.95
  VELOCITY_MAX = WINDOW_HEIGHT * 1.45
  GRAVITY = WINDOW_HEIGHT * 1.125

  VELOCITY_PARTICLE = WINDOW_HEIGHT * 0.2
  GRAVITY_PARTICLE = WINDOW_HEIGHT * 0.2

  MULTIPLIER_HEART_SHAPE = WINDOW_HEIGHT * 0.005
  OFFSET_HEART_SHAPE_MAX = WINDOW_HEIGHT * 0.025

  FIREWORKS = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) * 0.02)
  RADIUS_FIREWORK = math.min(WINDOW_WIDTH, WINDOW_HEIGHT) * 0.005

  PARTICLES = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) * 0.5)
  RADIUS_PARTICLE = math.min(WINDOW_WIDTH, WINDOW_HEIGHT) * 0.0025

  THRESHOLD_FIREWORK = VELOCITY_MIN * 0.15
  POINTS_TRAIL = math.floor(WINDOW_HEIGHT * 0.04)

  fireworks = {}
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  if love.math.random(ODDS_FIREWORK) == 1 then
    table.insert(fireworks, Firework:create())
  end

  for i = #fireworks, 1, -1 do
    local firework = fireworks[i]
    firework:update(dt)
    if firework.hasExpired then
      table.remove(fireworks, i)
    end
  end
end

function love.draw()
  for i, firework in ipairs(fireworks) do
    firework:render()
  end
end
