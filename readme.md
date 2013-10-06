# vim-zsh-completion

This is a vim omnicompletion which captures completions from zsh's completion
engine. This is an application of
[this](https://github.com/Valodim/zsh-capture-completion) zsh completion
capturing method.

## Demo

![demo](http://mugenguild.com/~valodim/vim-zsh-completion.gif)

## Status

The script works reasonably well for most cases I tested.

While it does work reasonably well, the way completion results are gathered
from zsh is a HUGE HACK, so don't be too surprised with inexplicable behavior.
Also note the completion capturing script requires (at the time of this
writing) a nightly version of zsh which includes the patch from here:

http://www.zsh.org/mla/workers/2013/msg00728.html
https://github.com/zsh-users/zsh/commit/b0a0441902f848da4284e107c29e43e222252959


## Installation

Install using [vundle](https://github.com/gmarik/vundle):

    Bundle 'Valodim/vim-zsh-completion'
    BundleInstall

The script is set as omnicompletion (^X^O) for zsh files automatically. It
plays well with YouCompleteMe from what I have seen, although it needs to be
manually triggered like most semantic completions.

You can also bind it to user completion (^X^U) for use outside of zsh script
files using:

    :set completefunc=zsh_completion#Complete
