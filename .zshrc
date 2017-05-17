#!/usr/bin/env zsh
# Completions and autoload {{{

# note - you can get a clean config using compinstall and zsh-newuser-install

zstyle ':completion:*' completer _expand _complete _correct
zstyle ':completion:*' completions 4
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' max-errors 1 not-numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p %s
zstyle ':completion:*' substitute 1
zstyle :compinstall filename '/Users/jed/.zshrc'

autoload -U compinit
# -u suppresses warning about "insecure files and directories",
# i.e., files and directories not owned by me or by root, or those
# that are writable by anyone else
compinit -u

#[[ $fpath = *jed* ]] || fpath=(~jed/zsh/bin $fpath)
#autoload ${fpath[1]}/*(:t)

# }}}

# Environment {{{

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

export PAGER=less

# http://arthurkoziel.com/2008/10/22/working-virtualenv/
# http://www.doughellmann.com/projects/virtualenvwrapper/
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

# }}}

# Options {{{

setopt \
    appendhistory \
    autocd \
    auto_list \
    auto_menu \
    auto_param_keys \
    auto_param_slash \
    auto_pushd \
    auto_remove_slash \
    NO_auto_resume \
    bad_pattern \
    bang_hist \
    NO_beep \
    bg_nice \
    brace_ccl \
    NO_bsd_echo \
    c_bases \
    chase_dots \
    NO_chase_links \
    check_jobs \
    NO_clobber \
    complete_in_word \
    hist_ignore_dups \
    NO_hup \
    NO_list_beep \
    notify \
    octal_zeroes \

# }}}

# Configuration {{{

bindkey -e

tset -e '^?'

# }}}

# Paths {{{

# not sure i like this 
#cdpath=(~ .)

# typeset and export args:
# -T: bind with a shell path variable
# -U: ensure that entries are unique

typeset -U path
path=(
    ./node_modules/.bin
    ~/bin 
    ~/local/bin 
    /usr/local/bin
    /usr/local/sbin
    ~/local/node/bin
    /opt/nova/bin
    /usr/bin
    /usr/sbin
    /bin
    /sbin
    /usr/local/Cellar/python/2.7.1/bin
    $path
)

export NODE_PATH=$HOME/local/node

export -TU LD_LIBRARY_PATH ld_library_path
ld_library_path=(
    ./lib
    /usr/local/lib
    $ld_library_path
)


export -TU PYTHONPATH pythonpath
pythonpath=(
    ./python
    ./lib/python
    ~/lib/python2.7/site-packages
    $pythonpath
)



# }}}

# Aliases and Functions {{{

alias ls='ls -G'
alias ssh='ssh -X -Y'
alias e='emacs -nw'

new () {
# List newest files
    o_num=(-n 10)
    zparseopts -D -K -E n:=o_num

    case $# in
        0)
            ls -Alth | head -${o_num[2]}
            ;;
        *)
            for d; do
            print -- "========== New in $d"
            ls -Alth $d | head -${o_num[2]}
            done

            ;;
    esac
}

# }}}

# Interactive shell {{{

if [[ -o interactive ]]; then
    PS1="(%n@%m) %~> "

# export PROMPT=$'%m %(0?..%{\e[0;31m%}%?)%(1j.%{\e[0;32m%}%j.)%{\e[0;33m%}%16<...<%~%<<EOF
#%{\e[0;36m%}%#%{\e[0m%} '
export PROMPT=$'%m %(0?..%{\e[0;31m%}%?)%(1j.%{\e[0;32m%}%j.)%{\e[0;33m%}%{\e[0;36m%}%#%{\e[0m%} '
export RPS1=$'%{\e[1;30m%}%~%{\e[0m%}'

# set xterm title
case $TERM in 
    (xterm*)
        xtitle () { print -Pn "\e]0; %m: %~\a" }
        precmd () { xtitle }
        ;;
esac

# other interactive commands in ~/.zlogin 

watch=(notme)
fi

# }}}

#EOF
# Correctly display UTF-8 with combining characters.
if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
	setopt combiningchars
fi

alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias ls='ls -G'
alias flac2mp3='for i in *.flac; do ffmpeg -i "$i" -ab 320k -map_metadata 0 -id3v2_version 3 "$(echo $i | sed s/\.flac//g)".mp3; done;'
alias ttasplit='for cue in *.cue; do for tta in *.tta; do shntool split -f "$cue" -t "%n. %t" -o flac "$tta"; break; done; break; done;'
alias chrome-sandbox="bash -c 'nohup /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --incognito --user-data-dir=/Users/feeshmac/Chrome/ &>/dev/null &'"
alias grep='grep --color=auto'
vlcopen () {
  if [ -e "$(pwd)/$1" ]
  then
    osascript -e "tell app \"VLC\" to open \"$(pwd)/$1\"" >/dev/null
    echo Starting: $(pwd)/$1
  else
    echo No such folder/file: $(pwd)/$1
  fi
}
ddir='/Users/feeshmac/Downloads'

setopt HIST_IGNORE_SPACE

alias restart-sshd='launchctl unload /System/Library/LaunchDaemons/ssh.plist; launchctl load -w /System/Library/LaunchDaemons/ssh.plist'
