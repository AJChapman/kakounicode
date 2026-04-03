provide-module kakounicode_db %§

echo -debug "loading kakounicode_db"

require-module kakounicode_ifte
require-module kakounicode_kv_store

# A name for each unicode symbol
new-map unicode_name

# A unicode symbol for each alias
new-map alias_unicode

# One or more aliases for each unicode symbol
new-map unicode_aliases

define-command add-unicode-alias -params 1..2 %{
    # Detect duplicate aliases.
    # If first load takes too long then comment this block out.
    # map-lookup alias_unicode %arg{2}
    # try %{
    #     eval "nop%reg{v}"
    # } catch %{
    #     fail "attempting to add alias %arg{2} for unicode %arg{1}, but this alias is already in use by %opt{map_lookup_result}"
    # }

    # Map this alias to this unicode
    map-add-value alias_unicode %arg{2} %arg{1}

    # Add this alias to the list of aliases for this unicode
    map-add-value unicode_aliases %arg{1} %arg{2}
}

define-command add-unicode -params 1..3 %{
    map-add-value unicode_name "%arg{1}" "%arg{3}"

    # Map this alias to this unicode
    map-add-value alias_unicode %arg{2} %arg{1}

    # Add this alias to the list of aliases for this unicode
    map-add-value unicode_aliases %arg{1} %arg{2}
}

§
