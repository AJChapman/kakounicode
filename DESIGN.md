# Design Notes

## Terminology

- **Alias**: A string, such as 'lambda', which will be translated into a unicode character.

## General Principles

- Try *not* to call %sh{ }, as this takes around 15ms per call (on Mac) which adds up to far too much time when loading thousands of aliases.
- Try not to load all the characters at startup, as it takes too long. Load them on first use instead.
- Allow users to customise how it works for them, but provide good defaults.

## Defining Aliases

For any given symbol:

1. Call add-unicode:
    - First argument is the symbol,
    - Second argument is a default alias. If the symbol was from agda-input.el and was in an `agda-input-to-string-list` list then give it an alias with the correct number; e.g. if it was the third item in the "eq" list then give it an alias of "eq3". In this case also, give the first one a default of e.g. "eq1", but also give it an alias of "eq". In emacs this would expand to the most recently used symbol in this list, but we don't (yet) have this feature,
    - Third argument is a description of the symbol. You can get a description by selecting the symbol and then piping to `xargs unicode-description.sh` (you will need chr installed; use `cargo install chr`, and put rc/unicode-description.sh in your path, e.g. symlink it into ~/bin/).
2. Add any other aliases for the symbol that seem appropriate. `add-unicode-alias` has a check for duplicates, though this may be commented out if loading everything takes too long.

# TODO: Custom Completion

- Hook on InsertChar; if it matches %opt{unicode_inline_prefix} then add (or populate) completer on every keypress
- Populate the completer by iterating over alias_unicode; filter aliases by those starting with the current string between %opt{unicode_inline_prefix} and the cursor.
- Fill in details in the completer from alias_unicode and unicode_name

# TODO: Info on character currently under cursor

- On idle hook, lookup the character in unicode_name and show this.
- Also lookup the character in unicode_aliases and show all of these.
