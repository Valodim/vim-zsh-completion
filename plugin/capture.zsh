#!/bin/zsh

zmodload zsh/zpty

here=( ${0:a:h} )
zpty z ZDOTDIR=$here zsh -i -s

# wait for ok from shell
zpty -rt z

# TODO use $2 properly for a cursor position here
zpty -w z "${1[1,${2:--1}]}"$'\t'

integer tog=0
# read from the pty, and parse linewise
while zpty -r z; do :; done | while IFS= read -r line; do
    if [[ $line == *$'\0\r' ]]; then
        (( tog++ )) && return 0 || continue
    fi
    # display between toggles
    (( tog )) && echo -E - $line
done

return 2
