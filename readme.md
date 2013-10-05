# vim-zsh-completion

This is a vim omnicompletion which captures completions from zsh's completion
engine. This is an application of
[this](https://github.com/Valodim/zsh-capture-completion) zsh completion
capturing method.

## Demo

![demo](http://mugenguild.com/~valodim/vim-zsh-completion.gif)

## Status

The script works reasonably well for most cases I tested. There is a corner
case where descriptions aren't displayed for some prefix types which may or may
not be fixed later on.

While it does work reasonably well, this entire script is a HUGE HACK. Don't
expect more than proof of concept code quality. Also note the completion
capturing script requires (at the time of this writing) a nightly version of
zsh which includes the patch from here:

http://www.zsh.org/mla/workers/2013/msg00728.html
https://github.com/zsh-users/zsh/commit/b0a0441902f848da4284e107c29e43e222252959


## Installation

Install using [vundle](https://github.com/gmarik/vundle):

    Bundle 'Valodim/vim-zsh-completion'
    BundleInstall

Use as omnicompletion ftplugin for zsh files as usual (^X^O). Or bind to user
completion (^X^U) with:

    :set completefunc=zsh_completion#Complete
