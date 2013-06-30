### FreeBSD Version

[[ $- != *i* ]] && return
export EDITOR="nano"
export LSCOLORS="Ex"
PS1='\[\e[1m\]\u\[\e[m\]@\h:\[\e[4m\]${PWD}\[\e[m\]>'
shopt -s cdspell
alias ls='ls -GF'
alias dir='ls -halGF'
chmod a+rw `tty`

### Linux Version

[[ $- != *i* ]] && return
export EDITOR="nano"
PS1='\[\e[1m\]\u\[\e[m\]@\h:\[\e[4m\]${PWD}\[\e[m\]>'
shopt -s cdspell
alias ls='ls --color -F'
alias dir='ls --color -halF'
chmod a+rw `tty`
