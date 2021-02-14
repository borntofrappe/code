# Fireworks

With this project I set out to simulate fireworks following the example provided in [this coding challenge](https://thecodingtrain.com/CodingChallenges/027-fireworks.html) from [the coding train](https://thecodingtrain.com/) website. The approach is slightly different, the demo is implemented in Lua and Love2D instead of Processing, but the rules, the physics governing the motion of the particles is the same.

_Update:_ to reiterate how the logic is agnostic of language, the demo is recreated with JavaScript and the Canvas API. The notes are however and mostly dedicated to the Lua version.

## Physics

The lecturer introduces a series of vectors to set and modify the position of the particles.

```lua
local position = {
  ["x"] = 0,
  ["y"] = 0
}
local velocity = {
  ["x"] = 0,
  ["y"] = 0
}
local acceleration = {
  ["x"] = 0,
  ["y"] = 0
}
```

`velocity` is used to modify the position of a particle. This allows to move the particle at a constant rate.

```lua
function love.update(dt)
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt
end
```

`acceleration` is used to modify the velocity itself. By increasing/decreasing the velocity the particle speeds up or slows down and eventually reverses its movement.

```lua
function love.update(dt)
  self.velocity.x = self.velocity.x + self.acceleration.x * dt
  self.velocity.y = self.velocity.y + self.acceleration.y * dt
end
```

In the particular demo the particles are initialized in the bottom part of the screen, with a negative velocity so that the particles move upwards. The acceleration is introduced in the form of gravity is positive so that the particles slow down before falling down.

```lua
local velocity = {
  ["x"] = 0,
  ["y"] = VELOCITY * -1
}

local acceleration = {
  ["x"] = 0,
  ["y"] = GRAVITY
}
```

_Please note_: the code is updated so that the `Particle` construct accepts the three vectors in the initialization function. Following the modification, the movement is implemented as described in the snippets above.

## Heart Shape

By default, the particles explode in a circle.

```lua
for i = 1, PARTICLES do
  local angle = math.rad(love.math.random(360))
  local radius = love.math.random(VELOCITY_PARTICLE)
  vx = math.cos(angle) * radius
  vy = math.sin(angle) * radius
end
```

With an arbitrary odd, the default shape is however disregarded in favor of a heart.

```lua
if self.isHeartShaped then
  -- heart explosion
else
  -- default explosion
end
```

This shape is computed consiering the logic introduced [in this coding challenge](https://thecodingtrain.com/CodingChallenges/134.1-heart-curve.html) and the formula [from this Wolfram MathWorld](http://mathworld.wolfram.com/HeartCurve.html).

The trigonometric functions are used on a value in the `[1, math.pi * 2]` range.

```lua
for i = 1, PARTICLES do
  local t = i / PARTICLES * math.pi * 2
  vx = 16 * math.sin(t) ^ 3
  vy = (13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t))
end
```

The components of the vector are then multiplied to have the particles scatter in a wider area.

```lua
vx = vx * MULTIPLIER_HEART_SHAPE
vy = vy * MULTIPLIER_HEART_SHAPE * -1
```

## constants

In a first version, the constants describing the velocity, gravity and otherwise appearance of the simulation were initialized at the top of `main.lua` with arbitrary values.

```lua
VELOCITY_MIN = 380
VELOCITY_MAX = 540
```

This approach worked with the size chosen for the window.

```lua
WINDOW_WIDTH = 400
WINDOW_HEIGHT = 400
```

As I updated the demo to consider the entirety of the screen, and therefore a variable measure for both dimensions, I moved the constants in `love.load()`, so that the simulation changes according to the available widht and height.

```lua
VELOCITY_MIN = WINDOW_HEIGHT * 0.95
VELOCITY_MAX = WINDOW_HEIGHT * 1.45
```

The width and height are retrieved from the window, after Love2D is instructed to cover the entirety of the available space.

```lua
love.window.setMode(0, 0)
WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()
```

## Trail

I decided to update the demo to have a series of circles describe the trail of the firework, or at least the body of the firework. The idea is to include the vector of the position in a `trail` table, and loop through the table to draw circle with decreasing radius and opacity.

```lua
for i, position in ipairs(self.trail) do
  local opacity = (#self.trail - i) / #self.trail / 2
  local radius = (#self.trail - i) / #self.trail * self.particle.r / 2
  love.graphics.setColor(self.particle.color.r, self.particle.color.g, self.particle.color.b, opacity)
  love.graphics.circle("fill", position.x, position.y, radius)
end
```

When building the table, the position of the main particle is added as the first item of the table.

```lua
local position = {
  ["x"] = self.particle.position.x,
  ["y"] = self.particle.position.y
}

table.insert(self.trail, 1, position)
```

A threshold is then used to ensure a limited number of points.

```lua
if #self.trail > POINTS_TRAIL then
  table.remove(self.trail)
end
```

## JavaScript and Canvas API

The demo is recreated in the browser through the Canvas API and `requestAnimationFrame`.

The biggest challenge in implementing the logic from the Lua version is finding the most appropriate values for the gravity and velocity, in an environment withouth a concept of delta time `dt`. In this context, the values are mapped to the height of the window.

Another challenge is connected to the variability of the environment itself. The width, the height of the window are not known in advance, and it is therefore necessary to adjust the simulation according to the computed values. The dimension is also subject to change, as the window might be resized after the simulation is first run. To cope with this last issue, the appropriate variables are modified in as the window registers the `resize` event.

A note on the class syntax used to separate the logic of the simulation. `Particle` describes a body which moves through three variables: position, velocity, acceleration. `Fragment` is created to behave just like a particle, but one that reduces its radius in the `update` function. To add just this functionality, the class extends from the parent class and then repeats the `update` function through the `super` keyword.

```js
class Fragment extends Particle {
  // constructor

  update() {
    super.update();
    this.r = Math.max(0, this.r - FRAGMENT_RADIUS_DECREASE);
  }
}
```

`super` is also useful with the `HeartFirework` class, which inherits from `Firework`, and then overrides the `getFragments` method, so to change the configuration of the exploding particles.

```js
class HeartFirework extends Firework {
  constructor() {
    super();
  }

  // overrides getFragments(x, y) from parent class
  getFragments(x, y) {}
}
```
