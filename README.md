# Diff2HTML

Diff2HTML generates diffs similar to the diff views provided on GitHub repositories.
Use `diff2html` just as you would use `git diff` to generate a mini-site of HTML/CSS/JS
that is perfect for code reviews.

## Installation

Install globally via npm:

```sh
npm install -g diff2html
```

## Usage

### diff2html

diff2html pass all provided settings to `git diff`.

For example, to see what changed in the last commit:

	diff2html HEAD^

## License

Copyright 2014 Jason Deering. Released under the terms of the MIT license.

---
