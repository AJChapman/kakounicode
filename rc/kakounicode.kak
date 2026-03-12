declare-option -docstring 'Set what should delimit the start of a unicode alias, e.g. if you want `lambda to expand to λ instead. Note that this should be a regex search term, hence the default needing to be escaped.' \
    str kakounicode_inline_prefix "\\"
declare-option -docstring 'Set what should delimit the end of a unicode alias, e.g. if you want to press \ again to expand, rather than <spacebar>.' \
    str kakounicode_inline_suffix " "

hook global WinSetOption 'kakounicode_auto_expand=false$' %{
    rmhooks window kakounicode-auto-expand
}
hook global WinSetOption 'kakounicode_auto_expand=true$' %{
    rmhooks window kakounicode-auto-expand
    hook -group kakounicode-auto-expand window InsertChar %opt{kakounicode_inline_suffix} %{
        evaluate-commands -draft -save-regs /"|^@vm %{
            try %{
                # Search backwards to the previous %opt{kakounicode_inline_prefix}, stopping if we reach whitespace and failing if we don't find it
                set-register / "%opt{kakounicode_inline_prefix}\S+\z"
                execute-keys 'hh<a-B><a-;>s<ret><a-;>L"mZ'
                require-module kakounicode_db
                map-lookup alias_unicode %val{selection}
                if-not-empty "%opt{map_lookup_result}" %{
                    # Restore the selection from the m register, as it is inexplicably clobbered by map-lookup.
                    # We saved it with '"mZ' above.
                    exec '"mz'
                    exec "H<a-;>Lc%opt{map_lookup_result}"
                }
            }
        }
    }
}
# this one must be declared after the hook, otherwise it might not be enabled right away
declare-option -docstring 'Set whether aliases will be expanded or not. This is basically the on/off switch.' \
    bool kakounicode_auto_expand true


hook global WinSetOption 'kakounicode_describe_selection=false$' %{
    rmhooks window kakounicode-describe-selection
}
hook global WinSetOption 'kakounicode_describe_selection=true$' %{
    rmhooks window kakounicode-describe-selection
    hook -group kakounicode-describe-selection window NormalIdle .* %{
        try %{
            require-module kakounicode_db
            # echo -debug "looking up '%val{selection}' in unicode_aliases"
            set-register v ''
            map-lookup unicode_aliases %val{selection}
            # echo -debug "result was %opt{map_lookup_result}"
            if-not-empty %opt{map_lookup_result} %{
                set-register v %opt{map_lookup_result}
                # echo -debug "looking up '%val{selection}' in unicode_name"
                map-lookup unicode_name %val{selection}
                # echo -debug "result was %opt{map_lookup_result}"
                set-register w %opt{map_lookup_result}
                info -title kakounicode "char value at cursor: %val{cursor_char_value}
selection: %val{selection}
aliases: %reg{v}
name: %opt{map_lookup_result}"
            }
        }
    }
}
# this one must be declared after the hook, otherwise it might not be enabled right away
declare-option -docstring 'Set whether to describe the characters in the current selection (if they are outside the regular set of ASCII characters.' \
    bool kakounicode_describe_selection false
