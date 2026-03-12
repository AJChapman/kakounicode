# Kakounicode

Unicode character (code point) input, and more.

Kakounicode allows you to input aliases, such as '\lambda', followed by a space key (which will not be input) and have this replaced by the corresponding unicode character.

It is inspired by and tries to follow the conventions of agda-mode for Emacs.

**WARNING**: Use of unicode symbols can be addictive, and will annoy your friends.

## Installation

If you're using [plug.kak](https://github.com/andreyorst/plug.kak) then add this to your kakrc:

```kak
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

### Unicode Symbol Lookup

You can learn about the symbol under the cursor if you set the option `kakounicode_describe_selection` to `true`.
It's probably best not to enable it at startup, since it will require loading all the unicode aliases on startup.
You may want to add these mappings, or similar:

```kak
    map global user k ': set global kakounicode_describe_selection true<ret>'
    map global user K ': set global kakounicode_describe_selection false<ret>'
```

## Configuration

You can configure a number of things by setting options in your kakrc.
If you are using plug.kak then placing this in your kakrc will result in the default settings ready for you to customise:

```kak
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

    # Enable or disable describing the currently selected unicode symbol
    set-option global kakounicode_describe_selection false
}
```

## Customisation

You can add your own custom 'unicode' symbols, or additional aliases for existing symbols.
The commands are simple: `add-unicode` and `add-unicode-alias`; but there's a little boilerplate to add to
E.g:

```kak
add-unicode '💩' 'pileofpoo' 'Pile of poo'
add-unicode-alias '💩' 'poo'
add-unicode-alias '💩' 'poop'
add-unicode-alias '💩' 'emacs'
```

You are not limited to single characters either; any string will do:

```kak
add-unicode '¯\_(ツ)_/¯' 'shrug' 'Shrug'
```
