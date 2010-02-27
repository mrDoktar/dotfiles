# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

export EDITOR='mate -w'

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1='\[\e[0;31m\]\w\[\e[m\]$(__git_ps1 " (%s)") $ '

# Terminal title (git completion is required for this):
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~} $(__git_ps1 " (%s)")"; echo -ne "\007"' 

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f ~/.bash_completions ]; then
    . ~/.bash_completions
fi

if [ -f ~/bin/sake-completion ]; then
  complete -C ~/bin/sake-completion -o default sake
fi