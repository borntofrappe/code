# [Impossible Objects](https://en.wikipedia.org/wiki/Impossible_object)

2D objects which are perceived as three dimensional, but have an intrinstic contradiction in their design.

The goal of this folder is to recreate a few of these objects with SVG syntax. I consider it good practice with the `d` attribute of the `<path>` element, as well as `<clipPath>` and `<mask>` elements. These are essential to cut out parts of the shapes to create the illusion.

## Eye

The first object is but an experiment with a shape created with two halves, two exact copy of the same visual.

## Borromean Rings

_Please note:_ the SVG syntax includes three `<radialGradient>` elements. These are are not useful for the optical illusion, but help to convey a sense of depth.

`borromean-circles.svg` is useful to highlight a few features of SVG syntax:

- a `<mask>` elements hides the portion of the visual marked as black, `hsl(0, 0%, 0%)`, and shows those marked as white, `hsl(0, 0%, 100%)`. Anything in between would be partially concealed

- a circle with only a stroke, be it black or white, would not work. This is why each ring is created with a `<path>` element, creating the outline of the circle with a solid fill
