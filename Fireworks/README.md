# Fireworks

The most immediate goal of this project is replicating the visual introduced in [this demo](https://thecodingtrain.com/CodingChallenges/027-fireworks.html) from the [coding train](https://thecodingtrain.com/) website.

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

`acceleration` is used to modify the velocity itself. By increasing/decreasing the velocity the particle speeds up or slows down and eventually reverses itself.

```lua
function love.update(dt)
  self.velocity.x = self.velocity.x + self.acceleration.x * dt
  self.velocity.y = self.velocity.y + self.acceleration.y * dt
end
```

In the particular demo the particles are initialized in the bottom part of the screen, with a negative velocity so that the particles move upwards. The acceleration is introduced in the form of gravity is positive so that the particles slow down before falling down. To modify the acceleration, the `applyForce` function directly modifies the appropriate `x` and `y` components.

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

_Please note_: the code explained in the snippets is updated so that the `Particle` construct accepts the three vectors, and otherwise uses the mentioned values as a default, as a fallback. This ensures that `Particle:create(RADIUS_FIREWORK)` introduces a particle moving upwards under the force of gravity.

## Garbage Collection

The particles are removed when they exceed the bottom of the window.

```lua
for i = #particles, 1, -1 do
  local particle = particles[i]
  if particle.y - RADIUS_PARTICLE > WINDOW_HEIGHT then
    table.remove(particles, i)
  end
end
```

This works as a first solution however. Eventually, the idea is to remove the firework when it reaches the topmost point, and the accompanying particles disappear.
