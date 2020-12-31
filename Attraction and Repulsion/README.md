# Attraction and Repulsion

Here I try to implement the physics introduced in [this coding challenge](https://thecodingtrain.com/CodingChallenges/056-attraction-repulsion.html) from [the coding train](https://thecodingtrain.com/) website, to experiment with a force of attraction and or repulsion.

I use Lua and Love2D instead of JavaScript, but the concepts are applicable to any stack.

## Euler Integration

The concept is explaine in the [`Fireworks` demo](https://github.com/borntofrappe/code/blob/master/Fireworks/README.md#physics), and relates to the physics making it possible for a particle to move with uniform acceleration. The idea is to use vectors for the position, velocity, and acceleration, have the position influenced by the velocity, and the velocity by the acceleration. With a constant acceleration, the velocity increases/decreases to have the particle move faster/slower and eventually reverse its movement.

## Attraction
