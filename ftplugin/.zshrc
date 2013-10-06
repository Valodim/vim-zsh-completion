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
zstyle ':completion:*' list-grouped false

# we use zparseopts
zmodload zsh/zutil

# override compadd (this our hook)
compadd () {

    typeset -a __tmp

    # check if any of -O, -A or -D are given
    if [[ ${@[1,(i)(-|--)]} == *-(O|A|D)\ * ]]; then
        # if that is the case, just delegate and leave
        builtin compadd "$@"
        return $?
    fi

    # ok, this concerns us!
    # echo -E - got this: "$@"

    # be careful with namespacing here, we don't want to mess with stuff that
    # should be passed to compadd!
    typeset -a __hits __dscr;

    # capture completions by injecting -A parameter into the compadd call.
    # this takes care of matching for us.
    builtin compadd -A __hits "$@"

    # JESUS CHRIST IT TOOK ME FOREVER TO FIGURE OUT THIS OPTION WAS SET AND MESSED WITH MY SHIT HERE
    setopt localoptions norcexpandparam extendedglob

    # extract suffix from compadd call. we can't do zsh's cool -r remove-func
    # magic, but it's better than nothing.
    typeset -A apre hpre hsuf asuf
    zparseopts -E P:=apre p:=hpre S:=asuf s:=hsuf

    # append / to directories?
    integer dirsuf=0
    # don't be fooled by -default- >.>
    if [[ -z $hsuf && "${${@//-default-/}% -# *}" == *-[[:alnum:]]#f* ]]; then
        dirsuf=1
    fi

    [[ -n $__hits ]] || return

    # TODO descriptions don't align with the array we get from -A, so we can't
    # align those easily.

    # do we have descriptions?
    if (( $@[(I)-d] )); then # kind of a hack, $+@[(r)-d] doesn't work because of line noise overload
        __tmp=${@[$[${@[(i)-d]}+1]]}
        if (( ${(P)#__tmp} == $#__hits)); then
            for i in {1..$#__hits}; do
                if (( dirsuf )) && [[ -d $__hits[$i] ]]; then
                    echo -E - $IPREFIX$apre$hpre$__hits[$i]/$hsuf$asuf -- ${${(P)__tmp}[$i]#$__hits[$i] #-- }
                else
                    echo -E - $IPREFIX$apre$hpre$__hits[$i]$hsuf$asuf -- ${${(P)__tmp}[$i]#$__hits[$i] #-- }
                fi
            done
            return
        fi
    fi

    # otherwise, just print all candidates
    for i in {1..$#__hits}; do
        if (( dirsuf )) && [[ -d $__hits[$i] ]]; then
            echo -E - $IPREFIX$apre$hpre$__hits[$i]/$hsuf$asuf
        else
            echo -E - $IPREFIX$apre$hpre$__hits[$i]$hsuf$asuf
        fi
    done

}
