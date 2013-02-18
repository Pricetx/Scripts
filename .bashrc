export EDITOR="nano"
PS1='\[\e[1m\]\u\[\e[m\]@\h:\[\e[4m\]${PWD}\[\e[m\]>'
alias ls='ls --color=auto -GF'
alias dir='ls ==color=auto -alGF'
alias nano='nano -Sw'
chmod a+rw `tty`
alias ggo='screen -x gravitygunonly'
