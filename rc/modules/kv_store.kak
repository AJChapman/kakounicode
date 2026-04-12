provide-module kakounicode_kv_store %§

define-command -hidden new-map -params 1 %{
    declare-option -hidden str %arg{1}
}

declare-option -hidden str map_translate_result

define-command -hidden map-translate -params 1..3 %{
    # Note that this may re-open this buffer, which is why we first delete any existing buffer contents.
    edit -debug -scratch "*kakounicode-map-translate*"
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

define-command -hidden map-add-value -params 1..3 %{
    # Add this value to the map
    set-option -add global %arg{1} "%arg{2}	%arg{3}
"
}

declare-option -hidden str map_contents

define-command map-lookup -params 1..2 %{
    evaluate-commands -draft -save-regs /"|^@w %{
        # Note that this may re-open this buffer, which is why we start our key commands with "<percent>c"; to first delete the existing buffer contents.
        edit -debug -scratch "*kakounicode-map-lookup*"
        # Set %opt{map_contents} to the contents of the map
        eval "set-option global map_contents %%opt{%arg{1}}"
        try %{
            # Use the '*' command to set the '/' register to a regex-escaped version of arg 2.
            # Use the v register to input the key, in case it contains a < character.
            # We have to *not* save the / register so we can retrieve it, so we exclude it from the -save-regs list.
            set-register v %arg{2}
            execute-keys -draft -save-regs |"^@v "<percent>""vR<percent>H*"

            # Look up the item with this key (if any) and save it to the 'v' register.
            # Use the 'w' register to input the map, in case it contains a < character.
            set-register w "%opt{map_contents}"
            # Set the / register to the key we want to search for in the <a-k> below, so we don't have to enter it in the execute-keys, in case it contains a <
            set-register / "\A%reg{/}\t"
            # Replace buffer contents with the 'w' register,
            # split into lines (key<tab>value pairs),
            # keep only those key<tab>value pairs matching the key we want, then save the value to the 'v' register.
            execute-keys -draft "<percent>""wR<percent>H<a-s><a-k><ret>;h<a-t><tab>""vy"
        } catch %{
            # If anything fails return nothing
            set-register v ''
        }
    }
}

define-command map-search -params 1..2 %{
    evaluate-commands -draft -save-regs /"|^@w %{
        # Note that this may re-open this buffer, which is why we start our key commands with "<percent>c"; to first delete the existing buffer contents.
        edit -debug -scratch "*kakounicode-map-lookup*"
        # Set %opt{map_contents} to the contents of the map
        eval "set-option global map_contents %%opt{%arg{1}}"
        try %{
            # Use the '*' command to set the '/' register to a regex-escaped version of arg 2.
            # Use the v register to input the key, in case it contains a < character.
            # We have to *not* save the / register so we can retrieve it, so we exclude it from the -save-regs list.
            # The Haa<esc>Hia<esc> is to stop kak adding \b at the start and end of the regex for this search
            set-register v %arg{2}
            execute-keys -draft -save-regs |"^@v "<percent>""vR<percent>Haa<esc>Hia<esc>*"

            # Look up the item with this key (if any) and save it to the 'v' register.
            # Use the 'w' register to input the map, in case it contains a < character.
            set-register w "%opt{map_contents}"
            # Replace buffer contents with the 'w' register,
            # split into lines (key<tab>value pairs),
            # keep only those key<tab>value pairs matching the key we want, then save the value to the 'v' register.
            execute-keys -draft "<percent>""wR<percent>H<a-s><a-k><ret>""vy"
        } catch %{
            # If anything fails return nothing
            set-register v ''
        }
    }
}

§
