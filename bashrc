# If not running interactively, don't do anything
[ -z "$PS1" ] && return

case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
    screen)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    ;;
esac
export PROMPT_COMMAND

# don't put duplicate lines in the history. See bash(1) for more options
if [ "$HISTCONTROL" = "ignorespace" ]
then
    export HISTCONTROL=ignoreboth
else
    export HISTCONTROL=ignoredups
fi

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]
then
    debian_chroot=$(cat /etc/debian_chroot)
fi

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    if type -P dircolors >/dev/null ; then
        if [[ -f ~/.dir_colors ]] ; then
            eval $(dircolors -b ~/.dir_colors)
        elif [[ -f /etc/DIR_COLORS ]] ; then
            eval $(dircolors -b /etc/DIR_COLORS)
        fi
    fi
    # red=31 green=32 yellow=33 blue=34 purple=35 cyan=36 white=37
    PS1="\[\033[01;34m\]["
    PS1="${PS1}\[\033[01;31m\]\u"
    PS1="${PS1}\[\033[01;34m\]@"
    PS1="${PS1}\[\033[01;32m\]\h"
    PS1="${PS1}\[\033[01;34m\]]"
    PS1="${PS1}\[\033[01;33m\]:"
    PS1="${PS1}\[\033[01;35m\]\w\n"
    PS1="${PS1}\[\033[01;31m\]\$"
    PS1="${PS1}\[\033[00;37m\]"

    alias ls='ls --color=auto -X'
    alias grep='grep --colour=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
elif [[ ${EUID} == 0 ]] ; then
    # show root@ when we don't have colors
    PS1='\u@\h \W \$ '
else
    PS1='\u@\h \w \$ '
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias vi='vim'
export EDITOR=/usr/bin/vim

export LANG='ko_KR.UTF-8'
export LC_ADDRESS='ko_KR.UTF-8'
export LC_IDENTIFICATION='ko_KR.UTF-8'
export LC_MEASUREMENT='ko_KR.UTF-8'
export LC_MONETARY='ko_KR.UTF-8'
export LC_NAME='ko_KR.UTF-8'
export LC_NUMERIC='ko_KR.UTF-8'
export LC_PAPER='ko_KR.UTF-8'
export LC_TELEPHONE='ko_KR.UTF-8'
export LC_TIME='ko_KR.UTF-8'
export MDM_LANG='ko_KR.UTF-8'

umask 022

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ]; then
    function command_not_found_handle {
        # check because c-n-f could've been removed in the meantime
        if [ -x /usr/lib/command-not-found ]; then
            /usr/bin/python /usr/lib/command-not-found -- $1
            return $?
        else
            return 127
        fi
    }
fi

if [ -f "$HOME/.rvm/scripts/rvm" ]
then
    source "$HOME/.rvm/scripts/rvm"
fi

# vim:set ft=sh:
