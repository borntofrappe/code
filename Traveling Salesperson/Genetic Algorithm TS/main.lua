LVector = require "LVector"
require "Point"
require "Path"
require "Population"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

POINTS = 6
POINT_RADIUS = 5

LINE_WIDTH = 2

SIZE = 5

function love.load()
  love.window.setTitle("Traveling salesperson - Genetic Algorithm TS")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.07, 0.07, 0.07)

  math.randomseed(os.time())

  population = Population:new(SIZE)
end

function love.update(dt)
  population:update()
end

function love.draw()
  population:render()
end
