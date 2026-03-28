provide-module kakounicode_kv_store %§

declare-option -hidden str kakounicode_map_equals_escape_char "፠"

define-command -hidden new-map -params 1 %{
    declare-option -hidden str-to-str-map %arg{1}
}

declare-option -hidden str map_translate_result

define-command -hidden map-translate -params 1..3 %{
    # Note that this may re-open this buffer, which is why we first delete any existing buffer contents.
    edit -scratch "*kakounicode-map-translate*"
    set-register v %arg{1}
    set-register / %arg{2}
    set-register u %arg{3}
    try %{
        # Replace the buffer contents with the string (from the 'v' register),
        # search for all matching strings (uses the existing '/' register),
        # replaces those with the replacement string,
        # and saves the result to the 'v' register.
        # If anything fails then the 'v' register will remain unchanged, being the input string.
        execute-keys -draft "<percent>""vR<percent>s<ret>""uR<percent>H""vy"
    }
    # Save the result to be retrieved by the caller
    set-option global map_translate_result %reg{v}
}

define-command -hidden map-escape-equals -params 1 %{
    map-translate %arg{1} '=' %opt{kakounicode_map_equals_escape_char}
}

define-command -hidden map-unescape-equals -params 1 %{
    map-translate %arg{1} %opt{kakounicode_map_equals_escape_char} '='
}

define-command -hidden map-double-comma -params 1 %{
    map-translate %arg{1} ',' ',,'
}

define-command -hidden map-undouble-comma -params 1 %{
    map-translate %arg{1} ',,' ','
}

declare-option -hidden str map_add_value_key ""

define-command -hidden map-set-value -params 1..3 %{
    # Escape any '=' character in the key
    map-escape-equals %arg{2}

    # We have to save it elsewhere as the next map-escape-equals will overwrite %opt{map_translate_result}
    set-option global map_add_value_key %opt{map_translate_result}

    # Escape any '=' character in the value
    map-escape-equals %arg{3}

    # Add this value to the map
    # (we add single quotes around the keys and values in case they contain a \ character)
    set-option -add global %arg{1} "'%opt{map_add_value_key}'='%opt{map_translate_result}'"
}

define-command -hidden map-add-value -params 1..3 %{
    # Look up the existing value for this key (if any)
    map-lookup %arg{1} %arg{2}
    try %{
        # This will throw an error if there was an existing value, thereby running the catch block
        eval "nop%opt{map_lookup_result}"

        # An error wasn't thrown, therefore there wasn't an existing value, so we can just set this first value
        map-set-value %arg{1} %arg{2} %arg{3}
    } catch %{
        # An error was thrown so there was an existing value (or values) at this key (at %opt{map_lookup_result}), so we will add to this

        # Escape any '=' character in the key
        map-escape-equals %arg{2}

        # We have to save the escaped key elsewhere as the next map-escape-equals will overwrite %opt{map_translate_result}
        set-option global map_add_value_key %opt{map_translate_result}

        # Escape any '=' character in the new value
        map-escape-equals %arg{3}

        # Add this value to the map by tab-separating it and the existing values
        # (we add single quotes around the keys and values in case they contain a \ character)
        set-option -add global %arg{1} "'%opt{map_add_value_key}'='%opt{map_lookup_result}	%opt{map_translate_result}'"
    }
}

define-command map-remove -params 1..2 %{
    set-option -remove global %arg{1} %arg{2}
}

# define-command map-add-values -params 1.. %{
#     eval %sh{
#         map="$1"
#         key="$2"
#         values=("${@:3}")
#         for value in "${values[@]}"; do
#             map-add-value "$map" "$key" "$value"
#         done
#     }
# }

declare-option -hidden str-to-str-map map_contents
declare-option -hidden str map_lookup_result

define-command map-lookup -params 1..2 %{
    evaluate-commands -draft -save-regs /"|^@vw %{
        # Note that this may re-open this buffer, which is why we start our key commands with "<percent>c"; to first delete the existing buffer contents.
        edit -scratch "*kakounicode-map-lookup*"
        # Set %opt{map_contents} to the contents of the map
        eval "set-option global map_contents %%opt{%arg{1}}"
        # Replace '=' with the escape char within the key. The result will be in %opt{map_translate_result}.
        map-escape-equals %arg{2}
        try %{
            # Use the '*' command to set the '/' register to a regex-escaped version of map_translate_result.
            # Use the v register to input the key, in case it contains a < character.
            # We have to *not* save the / register so we can retrieve it, so we exclude it from the -save-regs list.
            set-register v "'%opt{map_translate_result}'"
            execute-keys -draft -save-regs |"^@vm "<percent>""vR<percent>H*"

            # Look up the item with this key (if any) and save it to the 'v' register.
            # Use the 'w' register to input the map, in case it contains a < character.
            set-register w "%opt{map_contents}"
            # Set the / register to the key we want to search for in the <a-k> below, so we don't have to enter it in the execute-keys, in case it contains a <
            set-register / "\A%reg{/}="
            # Replace buffer contents with the 'w' register,
            # split into words (key=value pairs) using the 't' register to avoid overwriting the '/' register,
            # keep only those key=value pairs matching the key we want, then save the value to the 'v' register.
            execute-keys -draft "<percent>""wR<percent>H""ts'[^']+'='[^']+'<ret><a-k><ret>;<a-t>=L<a-semicolon>H""vy"

        } catch %{
            # If anything fails return nothing
            set-register v ''
        }

        # Replace the escape char with '=' in the result
        map-unescape-equals %reg{v}
        set-option global map_lookup_result %opt{map_translate_result}
    }
}

define-command map-lookup-many -params 1..2 %{
    map-lookup %arg{1} %arg{2}
}

§
