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
    #     fail "attempting to add alias %arg{2} for unicode %arg{1}, but this alias is already in use by %reg{v}"
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

define-command kakounicode-info -params 1..1 %{
    try %{
        # echo -debug "looking up '%arg{1}' in unicode_aliases"
        set-register v ''
        map-lookup unicode_aliases %arg{1}
        # echo -debug "result was %reg{v}"
        try %{
            # Fails if %reg{v} is not empty
            eval "nop%reg{v}"
        } catch %{
            # echo -debug "'%arg{1}' aliases: %reg{v}"
            # Copy %reg{v} to %reg{w} as we're going to overwrite it
            set-register w %reg{v}
            # echo -debug "looking up '%arg{1}' in unicode_name"
            map-lookup unicode_name %arg{1}
            # echo -debug "result was %reg{v}"
            # info -title "kakounicode" "%arg{1} : %reg{v}
            info -title "kakounicode" "%arg{1} : %reg{v}
aliases: %sh{ echo ""${kak_opt_kakounicode_inline_prefix}$kak_reg_w"" | sed ""s/ / ${kak_opt_kakounicode_inline_prefix}/g""}
code point(s): %sh{ printf '%s' ""$1"" | iconv -f utf-8 -t UTF-32BE | xxd -p -c 4 | while read -r hex; do
  n=$((16#$hex))
  printf 'U+%X ' ""$n""
done }"
        }
    }
}

§
