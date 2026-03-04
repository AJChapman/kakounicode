declare-option -hidden str kakounicode_inline_prefix "\\"
declare-option -hidden str kakounicode_inline_suffix " "
provide-module kakounicode %§

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
    #     eval "nop%opt{map_lookup_result}"
    # } catch %{
    #     fail "attempting to add alias %arg{2} for unicode %arg{1}, but this alias is already in use by %opt{map_lookup_result}"
    # }

    # Map this alias to this unicode
    map-add-value alias_unicode %arg{2} %arg{1}

    # Add this alias to the list of aliases for this unicode
    map-add-value unicode_aliases %arg{1} %arg{2}
}

define-command add-unicode -params 1..3 %{
    add-unicode-alias "%arg{1}" "%arg{2}"
    map-add-value unicode_name "%arg{1}" "%arg{3}"
}

§

hook global WinSetOption 'kakounicode_auto_expand=false$' %{
    rmhooks window kakounicode-auto-expand
}
hook global WinSetOption 'kakounicode_auto_expand=true$' %{
    rmhooks window kakounicode-auto-expand
    hook -group kakounicode-auto-expand window InsertChar %opt{kakounicode_inline_suffix} %{
        evaluate-commands -draft -save-regs /"|^@vm %{
            echo -debug "unicode suffix detected"
            try %{
                # echo -debug "initial selection is %val{selection}"
                # Search backwards to the previous %opt{kakounicode_inline_prefix}, stopping if we reach whitespace and failing if we don't find it
                execute-keys "hh<a-B><a-;>s%opt{kakounicode_inline_prefix}\S+\z<ret><a-;>L""mZ"
                echo -debug "looking for unicode alias for %val{selection}"
                require-module kakounicode
                map-lookup alias_unicode %val{selection}
                if-not-empty "%opt{map_lookup_result}" %{
                    # Restore the selection from the m register, as it is inexplicably clobbered by map-lookup
                    exec """mz"
                    echo -debug "unicode is %opt{map_lookup_result}; current selection is %val{selection}"
                    exec "H<a-;>Lc%opt{map_lookup_result}"
                }
            }
        }
    }
}

# this one must be declared after the hook, otherwise it might not be enabled right away
declare-option bool kakounicode_auto_expand true

