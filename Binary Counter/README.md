# Binary Counter

The idea is to include eight checkboxes to toggle a binary digit on and off. Each time a checkbox is toggled, the idea is to then loop through the existing input elements to compute the matching decimal number.

The `html` skeleton includes nothing short of a link tag to a stylesheet and a script tag to a series of JavaScript instructions. These instructions are responsible for both the markup and functionality of the demo.

## Markup

The script includes a `form` element with eight checkboxes. Each checkbox is included through a `<label>` element, nesting an `<input>` element and the SVG illustration making up a lightbulb.

> refer to `lightbulb.svg` for the graphic designed for the project

On top of these elements, the code includes a `<span>` element with a class of `.visually-hidden`. The idea is to here provide some text for assistive technologies, describing the purpose of the checkbox.

The markup is therefore designed to consider the following nested structure.

```html
<form>
  <!-- for every checkbox -->
  <label>
    <span></span>
    <input />
    <svg></svg>
  </label>
</form>
```

## Functionality

Once the script populates the page with the desired markup, the idea is to consider the `input` event on the form element.

```js
form.addEventListener('input', computeDecimalNumber);
```

As the checkboxes are toggled on and off, the event bubbles up to the parent container, so that adding a listener on the form is enough to collect the change in every instance.

As the event is registered, the idea is to tally up the decimal number matching the binary digit. This is achieved by considering how many input elements exist, and the index of the individual element.

```js
const inputs = form.querySelectorAll('input');
```

`inputs` provides a `NodeList` with the checkboxes. By looping through this collection, it is possible to consider their state through the `.checked` attribute. The code uses a `.reduce()` function, but it's possible to explain the code with a for loop as well.

- initialize a counter variable

  ```js
  let decimalNumber = 0;
  ```

  This variable is meant to be increased with every checked input.

- loop through the collection, considering the individual element

  ```js
  for (i = 0; i < inputs.length; i++) {
    const input = inputs[i];
  }
  ```

- if the input element is checked, consider the decimal number matching the binary digit

  ```js
  if (input.checked) {
    const number = 2 ** (inputs.length - i);
    decimalNumber = decimalNumber + number;
  }
  ```

  Here the number is computed as `2` to the power of `length - (i + 1)` since checkboxes are ordered in decreasing values. `(i + 1)` to make sure that the last checkbox considers `2` to the power of `0`, promtping the decimal value of `1`.

`decimalNumber` comes to describe the total in decimal base, and the value is finally rendered on the screen through the `p` element.

```js
document.querySelector('p').textContent = decimalNumber;
```

## Style

The script is responsible for computing the decimal number as the checboxes are updated. The stylesheet is then responsible for tweaking the appearance of the `<svg>` graphic. The idea is to have the lightbulbs grayed-out, thanks to the `filter` property.

```css
form label svg {
  filter: grayscale(1);
}
```

As the `input` elements are checked then, the graphic returns to its original colors through the sibling selector `+`.

```css
form label input:checked + svg {
  filter: grayscale(0);
}
```
