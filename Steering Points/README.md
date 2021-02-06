# Steering Points

The project is inspired by [a coding challenge](https://youtu.be/4hA7G3gup-4) from [The Coding Train](https://thecodingtrain.com/), and might actually involve a series of demos to ultimately create a grid of points tracing an outline.

## Create grid

The demo sets up a grid with a fixed number of columns and rows. This grid is modified with mouse and keyboard input by:

- clicking

  - left to add a point (if the cell is available)

  - right to remove a point (if the cell is populated)

- pressing

  - `e` to empty the grid

  - `g` to show the grid's lines

It is also possible to write a file locally describing the grid. Press

- `t` to create a `.txt` file where every empty cell is represented by an `x` and every point by `o` characters

- `p` to create a `.png` image

_Please note:_ the `.txt` and `.png` files are created in the default path described by the [`love.system`](https://love2d.org/wiki/love.filesystem) module.

## Read grid

Starting from a string of `x`s and `o`s, much similar to one created with the previous demo, the goal is to populate a grid with points matching the second character.

It is important to mention that the width and height of the window are set only after the script is able to discern the number of columns and rows.

For the number columns the position of the first newline character `\n` gives the index of the character separating the first and second row.

For the number of rows, instead, the number of newline characters `\n` points to one less than the actual value (since the last row ends with an `x` or `o`).

## Steer grid

Building on top of the `Read grid` demo, the goal is to update the points to be particles with a position, velocity and acceleration. The acceleration is then modified to have the particles repelled by the mouse cursor, but always attracted to their original position.

There are specifically three forces:

- a force pushing the particles to a target vector (steer)

- a force slowing down the particle (friction)

- a force pushing the particle away from the mouse, but only when the mouse is within a prescribed area (repel)

## Pattern grid

The goal is to have different patterns and change the configuration of the steering points by pressing a specific key:

- `r` for a rocket,
- `b` for blog,
- `c` for codepen,
- `f` for freecodecamp,
- `g` for github,
- `t` for twitter
