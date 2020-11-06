# Binary Numbers

Here you find two projects:

- `Binary Counter`, convert between binary and decimal numbers by toggling a series of checkboxes

- `Bit Shifting`, illustrate how the bitwise operator works, by shifting binary digits to the right and computing the matching decimal number

In preparation, I reviewed the following challenges from [the coding train](https://thecodingtrain.com/):

- [Binary to decimal conversion](https://thecodingtrain.com/CodingChallenges/119-binary-decimal-conversion.html)

- [Bit Shifting](https://thecodingtrain.com/CodingChallenges/120-bit-shifting.html)

The [MDN docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators) for [bitwise operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators#Bitwise_shift_operators) also helped.

## Binary Counter

The idea is to include eight checkboxes to toggle a binary digit on and off. Each time a checkbox is toggled, the idea is to then loop through the existing input elements to compute the matching decimal number.

The `html` skeleton includes nothing short of a link tag to a stylesheet and a script tag to a series of JavaScript instructions. These instructions are responsible for both the markup and functionality of the demo.

### Markup

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

### Functionality

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

### Style

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

## Bit Shifting

The idea is to enhance the demo introduced in _Binary Counter_ to illustrate how the bitwise operator `>>` works.

### Markup

The existing markup is modified to include a button element.

```html
<button>Shift bit \>\></button>
```

### Functionality

As the `<button>` element is clicked, the idea is to illustrate how the binary digits are shifted to the right by one place by modifying the `checked` attribute of the `<input>` elements:

- consider if the previous checkbox was checked

```js
let wasChecked = false;
```

- loop through the `<input>` elements

```js
inputs.forEach(input => {
}
```

- consider here the `checked` attribute of the current input, and the boolean `wasChecked`

  - if the input is checked, toggle `wasChecked` to true. However, do so only after considering the boolean's value.

    Considering `wasChecked` is necessary to remove the `checked` attribute if the previous checkbox was not checked. Visually, if the previous lightbulb was turned off.

    ```js
    if (input.checked) {
      if (!wasChecked) {
        input.checked = false;
      }
      wasChecked = true;
    }
    ```

  - else, consider the boolean to check the `<input>` element if the previous one was checked.

    Visually, turn on the lightbulb if the previous one was turned on.

    ```js
    else {
      if(wasChecked) {
        input.checked = true;
        wasChecked = false;
      }
    }
    ```

Once the shift is complete, the idea is to finally update the decimal number; this is achieved by repeating the instructions introduced in the demo _Binary Counter_, and evaluating the state of the individual checkboxes.

### Functionality/2

The `<button>` element is first disabled through the `disabled` attribute.

```html
<button disabled>Shift bit \>\></button>
```

The idea is to allow a click event only if necessary, only if at least one `<input>` element is checked.

As the checkboxes are toggled, as the button is clicked, this condition is considered through the `.some()` function.

```lua
const someChecked = [...inputs].some(input => input.checked);
```

The `for of` loop provides an alternative to achieve the same result:

- initialize a variable to consider if at least one checkbox is checked

  ```js
  let someChecked = false;
  ```

- loop through the input elements

  ```js
  for (const input of inputs) {
  }
  ```

- if one is checked toggle the boolean to true

  ```js
  if (input.checked) {
    someChecked = true;
  }
  ```

  The advantage of this solution is that as soon as one input is found to be checked, it's possible to terminate the loop with a `break` statement.

  ```js
  if (input.checked) {
    someChecked = true;
    break;
  }
  ```

### Concluding remarks

The `disabled` attribute is added/removed as the state of the `<input>` element is modified. This happens both as the `<form>` element registers the `input` event, and as the `<button>` element consders the `click` event, which leads to considerable repetition. For a more refined demo, consider moving the logic into dedicated functions.
