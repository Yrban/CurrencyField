# CurrencyField
## A simple SwiftUI Textfield to handle currency

### `TextFields` in SwiftUI have come a long way since its introduction. We now have the ability to natively handle non-String types directly in `TextFields` by way of formatters. However, entering currency in a `TextField` is not as simple as it should be. Take, for example, this `TextField:`

            TextField("", value: $currencyDouble, formatter: currencyFormatter, prompt: Text("Why do I have to press return"))

This `TextField` has a few drawbacks. First, the `prompt` will **never** show. This is because by using a `Double` there is always some value, in this case "0.00" to display. Prompts only appear when there is no value to display in a `TextField`. The second drawback is in order to enter a value, **you have to delete the value that is already in the field.** This is unintuitive to your user. Third, **there is no validation of data entry until the user is finished entering the data.** This means that instead of typing in a currency amount, the user could type "Mary had a little lamb...". And, if you think you can prevent that with a `.decimalPad`, you still won't get validation if the user types in multiple separators, such as "10..4.01..3" which is obviously **not** a valid number. Also, using a `.decimalPad` causes you to lose your "Done" button.

Wait, didn't Apple introduce a `.currency` format for a `TextField?` You could try this `TextField:`

            TextField("", value: $currencyDouble, format: .currency(code: "USD"), prompt: Text("Are you kidding me?"))

But this is even worse. The `.currency` format requires you to pick a currency, and **use a string code** in it. Really?

Introducing **CurrencyField!** CurrencyField handles these issues:
1. Shows currency when not editing, and the double when editing;
2. Shows the prompt if the value is zero;
3. **Validates input at entry**;
4. Continually updates the values;
5. Handles both "." and "," as separators;
6. Automatically uses local currency formatting;
7. Adds a "Done" button to the keyboard to dismiss the keyboard.

Simply copy the file and add it to your project to use just like any other TextField.
