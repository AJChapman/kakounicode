# Kakounicode

Unicode character (code point) input, and more.

Kakounicode allows you to input aliases, such as '\lambda', followed by a space key (which will not be input) and have this replaced by the corresponding unicode character.

It is inspired by and tries to follow the conventions of agda-mode for Emacs.

**WARNING**: Use of unicode symbols can be addictive, and will annoy your friends.

## Installation

If you're using [plug.kak](https://github.com/andreyorst/plug.kak) then add this to your kakrc:

```
plug "AJChapman/kakounicode"
```

## Usage

### Unicode Symbol Entry

To enter a unicode symbol, start in insert mode and type \ followed by its alias.
E.g:

```
\lambda
```

Now press the spacebar.
The `\lambda` will be replaced with `λ`.

The full collection of what are currently the default unicode symbols can be found in [agda.kak](rc/modules/agda.kak).
It is based on those found in agda-mode for Emacs.
These defaults may change in future.

Note that the first expansion (intentional or otherwise) may take a couple of seconds.
This is because the unicode aliases are not loaded until this first expansion.
Subsequent expansions should happen instantly™.

## Configuration

You can configure a number of things by setting options in your kakrc.
If you are using plug.kak then placing this in your kakrc will result in the default settings ready for you to customise:

```
plug "AJChapman/kakounicode" config %{
    # Set whether aliases will be expanded or not.
    # This is basically the on/off switch.
    set-option global kakounicode_auto_expand true

    # Set what should delimit the start of a unicode alias, e.g. if you want `lambda to expand to λ instead.
    # Note that this should be a regex search term, hence the default needing to be escaped.
    set-option global kakounicode_inline_prefix "\\"

    # Set what should delimit the end of a unicode alias, e.g. if you want to press \ again to expand, rather than <spacebar>.
    set-option global kakounicode_inline_suffix " "

    # Enable or disable collections of unicode symbol aliases.
    set-option global kakounicode_enable_agda true
    set-option global kakounicode_enable_greek false
    set-option global kakounicode_enable_equals_and_similar false
    set-option global kakounicode_enable_sets false
    set-option global kakounicode_enable_TeX false
}
```

