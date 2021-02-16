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

## Possible Cube

SVG syntax doesn't currently support 3D `transform` properties, which hampers any immediate progress to create a cube and [Reutersvard’s triangle](https://en.wikipedia.org/wiki/Impossible_object#/media/File:Reutersv%C3%A4rd%E2%80%99s_triangle.svg). Without knowing the exact coordinates of an equilateral triangle, it is however possible to trace the outline of a cube by translating and rotating a series of segments. `possible-cube.svg` works to showcase how the transformation functions move the segments and most prominently the origin from which the transformation is applied.

## Possible Triangle

Using CSS transform properties, the goal is to create a series of cubes, positioned in a triangular configuraiton.

In the demo folder, each cube of is created with three `<div>` elements, each with a distinct background color. The `<div>` elements are then rotated to repeat the design of the possible cube.

Interestingly, it is not necessary to apply a `perspective`. This reiterates the tendency for the human eye to perceive depth even when there is none.

Unfortunately, the demo fails to recreate Reutersvard’s triangle, proving once more the impossibility of the visual when using possible shapes. Indeed the last cube should stand above the penultimate, but below the first one.
