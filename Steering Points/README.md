# Steering Points

The project is inspired by [a coding challenge](https://youtu.be/4hA7G3gup-4) from [The Coding Train](https://thecodingtrain.com/), and might actually involve a series of demos to ultimately create a grid of points tracing an outline. The idea is to ultimately have particles trace the outline of a shape, and have them scatter as the mouse cursor approaches each and every one of them.

## Create grid

The first demo sets up a grid with a fixed number of columns and rows. This grid is modified with mouse and keyboard input by:

- clicking

  - left to add a point (if the cell is available)

  - right to remove a point (if the cell is populated)

- pressing

  - `e` to empty the grid

  - `g` to show the grid's lines

  - `t` to create a `.txt` file where every empty cell is represented by an `x` and every point by `o`

  - `p` to create a `.png` image

_Please note:_ the `.txt` and `.png` files are produced in the default path described by [`love.system`](https://love2d.org/wiki/love.filesystem)
