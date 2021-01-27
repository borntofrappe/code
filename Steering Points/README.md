<!-- TODOS
- [x] Create grid
  - [ ] rename project to 'Create grid'
- [x] Read grid
  - [ ] remove points from grid arguments
- [x] Make points into particles subject to multiple forces
  - [x] attracted to original position
  - [x] repelled by mouse cursor
  ~- [ ] repelled by other particles~
 -->

# Steering Points

The project is inspired by [a coding challenge](https://youtu.be/4hA7G3gup-4) from [The Coding Train](https://thecodingtrain.com/), and might actually involve a series of demos to ultimately create a grid of points tracing an outline. The idea is to ultimately have particles trace the outline of a shape, and have them scatter as the mouse cursor approaches each and every one of them.

## Create grid

The demo sets up a grid with a fixed number of columns and rows. This grid is modified with mouse and keyboard input by:

- clicking

  - left to add a point (if the cell is available)

  - right to remove a point (if the cell is populated)

- pressing

  - `e` to empty the grid

  - `g` to show the grid's lines

  - `t` to create a `.txt` file where every empty cell is represented by an `x` and every point by `o`

  - `p` to create a `.png` image

_Please note:_ the `.txt` and `.png` files are produced in the default path described by [`love.system`](https://love2d.org/wiki/love.filesystem)

## Read grid

Starting from a string of `x`s and `o`s, much similar to one created with the previous demo, the goal is to populate a grid with points matching the second character.

It is important to mention that the width and height of the window are set only after the script is able to discern the number of columns and rows.

For the number columns the position of the first newline character `\n` gives the index of the character separating the first and second row.

For the number of rows, instead, the number of newline characters `\n` points to one less than the actual value (since the last row ends with an `x` or `o`).

## Steer grid
