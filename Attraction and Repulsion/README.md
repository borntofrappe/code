# Attraction and Repulsion

In this folder you find to demos exploring the topic of gravitational forces, be it attraction, attraction and repulsion. The project stems from the physics introduced in [this coding challenge](https://thecodingtrain.com/CodingChallenges/056-attraction-repulsion.html) from [the coding train](https://thecodingtrain.com/) website, and heavily relies on the [accompanying code in the p5.js editor](https://editor.p5js.org/codingtrain/sketches/6WL2O4vq0).

In the future, I hope to revisit the folder with more knowledge regarding the underlying concepts, but here I am satisfied to create two mildly intriguing demos. I use Lua and Love2D instead of JavaScript, but the concepts are applicable to any stack.

## Euler Integration

The concept is explaine in the [`Fireworks` demo](https://github.com/borntofrappe/code/blob/master/Fireworks/README.md#physics), and relates to the physics making it possible for a particle to move with uniform acceleration. The idea is to use vectors for the position, velocity, and acceleration, have the position influenced by the velocity, and the velocity by the acceleration. With a constant acceleration, the velocity increases/decreases to have the particle move faster/slower and eventually reverse its movement.

## [Gravitational Attraction](https://repl.it/@borntofrappe/Gravitational-Attraction)

The folder introduces gravitational forces in an environment populated with one attractor, in the center of the window, and many particles, scattered around it.

The physics behind the force of attraction in detailed in the `Particle` entity. Here you find two important functions, `Particle:update()` and `Particle:attract()` responsible for the particle's movement.

### Update

`Particle:update()` introduces Euler's integration to consider the position, velocity and acceleration vectors. On top of this integration however, it limits the vector describing the velocity according to the magnitude of the vector itself.

```lua
local velocityMagnitude = (self.velocity.x ^ 2 + self.velocity.y ^ 2) ^ 0.5

if velocityMagnitude > VELOCITY_MAGNITUDE_LIMIT then
  self.velocity.x = self.velocity.x / velocityMagnitude * VELOCITY_MAGNITUDE_LIMIT
  self.velocity.y = self.velocity.y / velocityMagnitude * VELOCITY_MAGNITUDE_LIMIT
end
```

This snippet is the equivalent of the Processing function `P5Vector.limit(VELOCITY_MAGNITUDE_LIMIT)`. In order to limit the vector you need to consider its magnitude (the distance of the vector arrow), and scale each component in the moment the magnitue exceeds the arbitrary threshold.

The two lines updating the components, in particular, are the equivalent of the Processing function `P5Vector.setMag(VELOCITY_MAGNITUDE_LIMIT)`.

```lua
self.velocity.x = self.velocity.x / velocityMagnitude * VELOCITY_MAGNITUDE_LIMIT
self.velocity.y = self.velocity.y / velocityMagnitude * VELOCITY_MAGNITUDE_LIMIT
```

The Processing function normalizes the vector using its magnitude, `velocityMagnitude`, before multiplying each component with the new value.

### Attract

The idea is to consider the vector connecting the particle to the attractor. The function receives the attractor as its only argument, so that the vector is found subtracting the `x` and `y` component of the target object.

```lua
function Particle:attract(target)
  local force = {
    ["x"] = target.position.x - self.position.x,
    ["y"] = target.position.y - self.position.y
  }
end
```

This would already be enough to provide a force of attraction. Update the acceleration vector to match, and the measure is then included in the velocity and position vector.

```lua
self.acceleration.x = force.x
self.acceleration.y = force.y
```

The lecturer, however, decides to scale the force vector, with the goal of increasing/decreasing the influence of the force according to two components: a constant of gravity `G` and the distance between the particle and target. The formula is obtained by simplifying the formula for the force vector.

```lua
F = G * (m1 * m2) / (d ^ 2)
```

Considering both masses as `1`, the idea is to compute the strength as the gravitational constant divided by the distance squared. The force vector is then scaled exactly like the vector describing the velocity in the previous section.

```lua
force.x = force.x * strength / magnitude
force.y = force.y * strength / magnitude
```

These two lines are once more the equivalent of the Processing function `P5.setMag`.

_Please note_: the _magnitude_ of a vector is computed with the following formula

```lua
magnitude = (vector.x ^ 2 + vector.y ^ 2) ^ 0.5
```

In the context of a 2D vector, the measure is therefore the same as the distance, `vector.x` and `vector.y` being the components of the distance in the `x` and `y` dimensions.

## [Playground](https://repl.it/@borntofrappe/Gravitational-Playground)

The folder creates a more interactive demo, closer to the project finalized in the cited video. The idea is to have multiple particles and multiple attractors. The particles spawn continuously, while the attractors spawn following a click and the position of the mouse cursor.

The forces involved are roughly the same, with a few modifications to the `Particle:update()` and `Particle:attract()` function.

Starting with `Particle:attract()`, the acceleration vector is not set to the force vector, but incremented by the vector's components.

```lua
self.acceleration.x = self.acceleration.x + force.x
self.acceleration.y = self.acceleration.y + force.y
```

Without this change, the particles would consider only the last attractor (the last overrides the penultimate, which overrides the third to last until the very first).

The force vector is also updated to push the particles away when reaching an arbitrary threshold.

```lua
if distance < DISTANCE_THRESHOLD then
  force.x = force.x * -1
  force.y = force.y * -1
end
```

In `Particle:update`, finally, the vector describing the acceleration is reset after updating the velocity and position.

```lua
function Particle:update(dt)
  -- update position and vector

  self.acceleration.x = 0
  self.acceleration.y = 0
end
```

This is a direct consequence to the change introduced in the `attract` function, to avoid having the forces cumulate their influence frame after frame.
