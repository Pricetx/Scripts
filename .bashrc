### FreeBSD Version

[[ $- != *i* ]] && return
export EDITOR="nano"
export LC_ALL="en_GB.UTF-8"
export LSCOLORS="Ex"
export HISTSIZE=5000
export HISTFILESIZE=10000
export PAGER="less"
export NCURSES_NO_UTF8_ACS=1
PS1='\[\e[1m\]\u\[\e[m\]@\h:\[\e[4m\]${PWD}\[\e[m\]>'
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

shopt -s cdspell
shopt -s histappend

bind '"\e[1~": beginning-of-line'
bind '"\e[4~": end-of-line'
bind '"\e[2~": overwrite-mode'

alias ls='ls -GF'
alias dir='ls -halGF'
