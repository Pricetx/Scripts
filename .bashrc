### FreeBSD Version

[[ $- != *i* ]] && return
export EDITOR="nano"
export LC_ALL="en_GB.UTF-8"
export LSCOLORS="Ex"
PS1='\[\e[1m\]\u\[\e[m\]@\h:\[\e[4m\]${PWD}\[\e[m\]>'
shopt -s cdspell
[[ -e /usr/games/fortune ]] && /usr/games/fortune freebsd-tips

chmod a+rw `tty`
alias ls='ls -GF'
alias dir='ls -halGF'

### Linux Version

[[ $- != *i* ]] && return
export EDITOR="nano"
export LC_ALL="en_GB.UTF-8"
PS1='\[\e[1m\]\u\[\e[m\]@\h:\[\e[4m\]${PWD}\[\e[m\]>'
shopt -s cdspell
[[ -e /usr/share/games/fortune/debian-hints ]] && /usr/games/fortune debian-hints

chmod a+rw `tty`
alias ls='ls --color -F'
alias dir='ls --color -halF'

