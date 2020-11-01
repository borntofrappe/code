# Bit Shifting

The idea is to enhance the demo introduced in _Binary Counter_ to illustrate how the bitwise operator `>>` works.

## Markup

The existing markup is modified to include a button element.

```html
<button>Shift bit \>\></button>
```

## Functionality

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

## Functionality/2

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

## Concluding remakrs

The `disabled` attribute is added/removed as the state of the `<input>` element is modified. This happens both as the `<form>` element registers the `input` event, and as the `<button>` element consders the `click` event, which leads to considerable repetition. For a more refined demo, consider moving the logic into dedicated functions.
