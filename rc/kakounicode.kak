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
        evaluate-commands -draft -save-regs /"|^@v %{
            try %{
                # Search backwards to the previous %opt{kakounicode_inline_prefix}, stopping if we reach whitespace and failing if we don't find it
                set-register / "%opt{kakounicode_inline_prefix}[^%opt{kakounicode_inline_prefix}]+\z"
                execute-keys 'hh<a-B><a-;>s<ret><a-;>L'
                require-module kakounicode_db
                # echo -debug "looking up %val{selection} in alias_unicode"
                map-lookup alias_unicode %val{selection}
                # echo -debug "result was %reg{v}"
                if-not-empty "%reg{v}" %{
                    exec "H<a-;>Lc%reg{v}"
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
        require-module kakounicode_db
        kakounicode-info %val{selection}
    }
}

# this one must be declared after the hook, otherwise it might not be enabled right away
declare-option -docstring 'Set whether to describe the characters in the current selection (if they are outside the regular set of ASCII characters.' \
    bool kakounicode_describe_selection true

# This should actually contain the completions; it is dynamically populated as you type.
declare-option -hidden completions kakounicode_alias_completions

declare-option -docstring 'Set a limit on how many alias completions to suggest.' \
    str kakounicode_alias_completion_limit 30

hook global WinSetOption 'kakounicode_alias_autocomplete=false$' %{
    rmhooks window kakounicode-alias-autocomplete
}
hook global WinSetOption 'kakounicode_alias_autocomplete=true$' %{
    rmhooks window kakounicode-alias-autocomplete
    hook -group kakounicode-alias-autocomplete window InsertIdle .* %{
        evaluate-commands -draft -save-regs /"|^@v %{
            try %{
                # Search backwards to the previous %opt{kakounicode_inline_prefix}, stopping if we reach whitespace and failing if we don't find it
                set-register / "%opt{kakounicode_inline_prefix}[^%opt{kakounicode_inline_prefix}]+\z"
                execute-keys 'h<a-B><a-;>s<ret><a-;>L'
                require-module kakounicode_db
                map-search-key-with-prefix alias_unicode %val{selection}
                try %{
                    # This will fail if a key with this prefix was found, and the catch block with run
                    eval "nop%reg{v}"

                    # A key with this prefix was not found, so search the aliases for this string anywhere
                    map-search alias_unicode %val{selection}
                    if-not-empty "%reg{v}" %{
                        kakounicode-set-completions-from-register-v
                    }
                } catch %{
                    # Aliases with this prefix were found, so use these and don't search
                    kakounicode-set-completions-from-register-v
                }
            } catch %{
                set-option window kakounicode_alias_completions
            }
        }
    }
}

# this one must be declared after the hook, otherwise it might not be enabled right away
declare-option -docstring 'Set whether kakounicode will suggest unicode alias completions.' \
    bool kakounicode_alias_autocomplete true

