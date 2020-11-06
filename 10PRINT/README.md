# 10PRINT

[10 print](https://10print.org/) relates to a program which continuously render one of two characters, and in so doing creating a creative pattern.

With this project I set out to explore the concept starting from [a coding challenge](https://thecodingtrain.com/CodingChallenges/076-10print.html) from [The Coding Train](https://thecodingtrain.com/).

## Canvas

With `canvas.html` I recreate the pattern using the Canvas API and a few lines of JavaScript. The goal is to have the pattern repeated as to cover the entirety of the window's width and height. In order to achieve this effect, it is necessary to also include a couple of instructions in CSS.

```css
body {
  margin: 0;
  overflow: hidden;
}
```

Removing the margin is necessary to avoid the default value included by the browser's own stylesheet. Hiding the overflow is convenient to avoid the scrollbars.

In terms of JavaScript, the script implements a nested for loop to populate the makeshift grid with one of two lines. One starting from the top-left corner and moving diagonally toward the opposite end.

```js
context.moveTo(x, y);
context.lineTo(x + spacing, y + spacing);
```

One starting from the top-right corner and moving backwards toward the bottom-left.

```js
context.moveTo(x + spacing, y);
context.lineTo(x, y + spacing);
```

### Functions

The instructions drawing the pattern are nested in a function, so to repeat the operation when the window changes in size, or a mouse click is registered on the same element. When the window changes in size, the width and height of the canvas are also updated to match the new dimensions.

_Please note_: `clearRect` is necessary to avoid drawing the lines above the previous grid. It is not necessary as the window changes in width or height, as this automatically removes the existing structure.

```lua
context.clearRect(0, 0, width, height);
```

## Rain

With `rain.html` I take the _10 print_ concept and use it to simulate rain. This is possible by having the conditional draw a line only if the condition resolves to `true`, without specifying an `else` statement.

```lua
 if (odds()) {
  context.beginPath();
  context.moveTo(x, y);
  context.lineTo(x + spacing, y + spacing);
  context.closePath();
  context.stroke();
}
```

To simulate the rain's movement, the operation is repeated using [`requestAnimationFrame`](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame).

To further refine the demo, the rain's appearance is modified with a slider, which modifies the simulation through different variables:

- the spacing

- the line width

- the interval at which the animation is refreshed

- the odds describing how frequently to draw a line.

_Nifty_; the icons are copied from [tablericons](https://tablericons.com).
