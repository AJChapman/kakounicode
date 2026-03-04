require-module kakounicode_ifte

declare-option -docstring 'Enable set operations kakounicode aliases.' \
    str kakounicode_enable_sets false

hook global ModuleLoaded kakounicode %{
    if %opt{kakounicode_enable_sets} %{ require-module kakounicode_sets }
}

provide-module kakounicode_sets %§

echo -debug "loading kakounicode_sets"

# Set membership etc.
add-unicode '∈' 'member1' 'Element of'
add-unicode '∉' 'member2' 'Not an element of'
add-unicode-alias '∉' 'inn'
add-unicode '∊' 'member3' 'Small element of'
add-unicode-alias '∊' ''
add-unicode '∋' 'member4' 'Contains as member'
add-unicode-alias '∋' ''
add-unicode '∌' 'member5' 'Does not contain as member'
add-unicode-alias '∌' ''
add-unicode '∍' 'member6' 'Small contains as member'
add-unicode-alias '∍' ''
add-unicode '⋲' 'member7' 'Element of with long horizontal stroke'
add-unicode-alias '⋲' ''
add-unicode '⋳' 'member8' 'Element of with vertical bar at end of horizontal stroke'
add-unicode-alias '⋳' ''
add-unicode '⋴' 'member9' 'Small element of with vertical bar at end of horizontal stroke'
add-unicode-alias '⋴' ''
add-unicode '⋵' 'member10' 'Element of with dot above'
add-unicode-alias '⋵' ''
add-unicode '⋶' 'member11' 'Element of with overbar'
add-unicode-alias '⋶' ''
add-unicode '⋷' 'member12' 'Small element of with overbar'
add-unicode-alias '⋷' ''
add-unicode '⋸' 'member13' 'Element of with underbar'
add-unicode-alias '⋸' ''
add-unicode '⋹' 'member14' 'Element of with two horizontal strokes'
add-unicode-alias '⋹' ''
add-unicode '⋺' 'member15' 'Contains with long horizontal stroke'
add-unicode-alias '⋺' ''
add-unicode '⋻' 'member16' 'Contains with vertical bar at end of horizontal stroke'
add-unicode-alias '⋻' ''
add-unicode '⋼' 'member17' 'Small contains with vertical bar at end of horizontal stroke'
add-unicode-alias '⋼' ''
add-unicode '⋽' 'member18' 'Contains with overbar'
add-unicode-alias '⋽' ''
add-unicode '⋾' 'member19' 'Small contains with overbar'
add-unicode-alias '⋾' ''
add-unicode '⋿' 'member20' 'Z notation bag membership'
add-unicode-alias '⋿' ''

§
# ("inn" . ("∉"))
# ("nin" . ("∌"))

# ;; Intersections, unions etc.

# ("intersection" . ,(agda-input-to-string-list "∩⋂∧⋀⋏⨇⊓⨅⋒∏ ⊼      ⨉"))
# ("union"        . ,(agda-input-to-string-list "∪⋃∨⋁⋎⨈⊔⨆⋓∐⨿⊽⊻⊍⨃⊎⨄⊌∑⅀"))

# ("and" . ("∧"))  ("or"  . ("∨"))
# ("And" . ("⋀"))  ("Or"  . ("⋁"))
# ("i"   . ("∩"))  ("un"  . ("∪"))  ("u+" . ("⊎"))  ("u." . ("⊍"))
# ("I"   . ("⋂"))  ("Un"  . ("⋃"))  ("U+" . ("⨄"))  ("U." . ("⨃"))
# ("glb" . ("⊓"))  ("lub" . ("⊔"))
# ("Glb" . ("⨅"))  ("Lub" . ("⨆"))


