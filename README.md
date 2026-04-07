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

Two collections of unicode symbols are enabled by default:

- [agda.kak](rc/modules/agda.kak), based on those found in agda-mode for Emacs,
- [emoji.kak](rc/modules/emoji.kak), a collection of emoji.

Note that the first expansion (intentional or otherwise) may take a couple of seconds.
This is because the unicode aliases are not loaded until this first expansion.
Subsequent expansions should happen instantly™.

### Unicode Symbol Lookup

You can learn about the symbol under the cursor if you set the option `kakounicode_describe_selection` to `true`.

## Configuration

You can configure a number of things by setting options in your kakrc.
If you are using plug.kak then placing this in your kakrc will result in the default settings ready for you to customise:

```kak
plug "AJChapman/kakounicode" config %{
    # Create a user mode for kakounicode, opened with <leader>k
    declare-user-mode kakounicode-menu
    map global user k ': enter-user-mode kakounicode-menu<ret>' -docstring 'Kakounicode options'

    # Set whether aliases will be expanded or not.
    # This is basically the on/off switch.
    set-option global kakounicode_auto_expand true
    map global kakounicode-menu k ': set global kakounicode_auto_expand true<ret>' -docstring 'Alias expansion on'
    map global kakounicode-menu <a-k> ': set global kakounicode_auto_expand false<ret>' -docstring 'Alias expansion off'

    # Set what should delimit the start of a unicode alias, e.g. if you want `lambda to expand to λ instead.
    # Note that this should be a regex search term, hence the default needing to be escaped.
    set-option global kakounicode_inline_prefix "\\"

    # Set what should delimit the end of a unicode alias, e.g. if you want to press \ again to expand, rather than <spacebar>.
    set-option global kakounicode_inline_suffix " "

    # Enable or disable collections of unicode symbol aliases.
    set-option global kakounicode_enable_agda true
    set-option global kakounicode_enable_emoji true

    # These are all superseded by the agda collection, though you may want them individually, without the rest
    set-option global kakounicode_enable_greek false
    set-option global kakounicode_enable_equals_and_similar false
    set-option global kakounicode_enable_sets false
    set-option global kakounicode_enable_TeX false

    # Enable alias autocomplete completer
    set-option global kakounicode_alias_autocomplete true
    set-option global completers option=kakounicode_alias_completions %opt{completers}
    map global kakounicode-menu a ': set global kakounicode_alias_autocomplete true<ret>' -docstring 'Alias autocomplete on'
    map global kakounicode-menu <a-a> ': set global kakounicode_alias_autocomplete false<ret>' -docstring 'Alias autocomplete off'

    # Enable or disable describing the currently selected unicode symbol
    set-option global kakounicode_describe_selection true
    map global kakounicode-menu d ': set global kakounicode_describe_selection true<ret>' -docstring 'Describe character on'
    map global kakounicode-menu <a-d> ': set global kakounicode_describe_selection false<ret>' -docstring 'Describe character off'
}
```

## Customisation

You can add your own custom 'unicode' symbols, or additional aliases for existing symbols.
The commands are simple: `add-unicode` and `add-unicode-alias`; but there's a little boilerplate to add to
E.g:

```kak
# Immediately after the kakounicode plug block:
} defer kakounicode_db %{
    add-unicode-alias '💯' 'kakoune'

    # You are not limited to single characters either; any string will do:
    add-unicode '¯\_(ツ)_/¯' 'shrug' 'Shrug'
}
```
