# no prompt!
PROMPT=

# load completion system
autoload compinit
compinit

# never run a command
bindkey '^M' undefined
bindkey '^J' undefined
bindkey '^I' complete-word

# send a line with null-byte at the end before and after completions are output
null-line () {
    echo -E - $'\0'
}
compprefuncs=( null-line )
comppostfuncs=( null-line exit )

# never group stuff!
zstyle \* list-grouped false

# we use zparseopts
zmodload zsh/zutil

# override compadd (this our hook)
compadd () {

    typeset -a tmp hits; 

    # check if any of -O, -A or -D are given
    if [[ ${@[1,(i)(-|--)]} == *-(O|A|D)\ * ]]; then
        # if that is the case, just delegate and leave
        builtin compadd "$@"
        return $?
    fi

    # ok, this concerns us!
    # echo -E - got this: "$@"

    # extract suffix from compadd call. we can't do zsh's cool -r remove-func
    # magic, but it's better than nothing.
    typeset -A apre hpre hsuf asuf
    zparseopts -E P:=apre p:=hpre S:=asuf s:=hsuf

    # capture completions by injecting -A parameter into the compadd call
    builtin compadd -A hits "$@"

    # JESUS CHRIST IT TOOK ME FOREVER TO FIGURE OUT THIS OPTION WAS SET AND MESSED WITH MY SHIT HERE
    setopt localoptions norcexpandparam extendedglob

    # do we have descriptions?
    if (( $@[(I)-d] )); then # kind of a hack, $+@[(r)-d] doesn't work because of line noise overload
        tmp=${@[$[${@[(i)-d]}+1]]}
        if (( ${(P)#tmp} == $#hits)); then
            for i in {1..$#hits}; do
                echo -E - $IPREFIX$apre$hpre$hits[$i]$hsuf$asuf -- ${${(P)tmp}[$i]#$hits[$i] #-- }
            done
            return
        fi
    fi

    # otherwise, just print all candidates
    (( $#hits )) && print -l -- $IPREFIX$apre$hpre${^hits}$hsuf$asuf

}