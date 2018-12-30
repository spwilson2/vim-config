
"syntax keyword gbuildMacro macro
syntax match gbuildComment "#.*"
syntax keyword gbuildTarget Program Project
syntax match gbuildTarget "INTEGRITY Application"
syntax keyword gbuildDefconfig defineconfig

syntax region gbuildString start=/"/ skip=/\\"/ end=/"/ oneline contains=gbuildInterpolatedWrapper
syntax region gbuildInterpolatedWrapper start="\${" end="}" contained containedin=gbuildString contains=gbuildInterpolatedString
syntax region gbuildInterpolatedWrapper start="\$(" end=")" oneline contains=gbuildInterpolatedString
syntax match gbuildInterpolatedString "\v\w+" contained containedin=gbuildInterpolatedWrapper

syntax match gbuildMacroDef "\vmacro\s*[A-Za-z_0-9]+\=\S*"

syntax match gbuildOptional "\v\{optional\}"

highlight default link gbuildComment Comment

highlight default link gbuildMacro Define
highlight default link gbuildMacroDef Define
highlight default link gbuildOptional PreProc


highlight default link gbuildDefconfig Keyword
highlight default link gbuildTarget Keyword

highlight default link gbuildInterpolatedWrapper Preproc
highlight default link gbuildInterpolatedString Preproc
highlight default link gbuildString String
