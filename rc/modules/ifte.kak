provide-module kakounicode_ifte %§

define-command true -params 2 %{ eval %arg{1} }
define-command false -params 2 %{ eval %arg{2} }
define-command ifte -params 3 %{ eval -verbatim %arg{1} %arg{2} %arg{3} }
define-command if -params 2 %{ eval -verbatim %arg{1} %arg{2} nop }
define-command unless -params 2 %{ eval -verbatim %arg{1} nop %arg{2} }

define-command if-empty -params 2 %{
    try %{
        eval "nop%arg{1}"
        eval %arg{2}
    }
}

define-command if-not-empty -params 2 %{
    try %{
        eval "nop%arg{1}"
    } catch %arg{2}
}

§
