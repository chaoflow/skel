autoload zmv

autoload -U compinit; compinit
zstyle ':completion::complete:*' use-cache 1

SAVEHIST=20000
HISTSIZE=20000
HISTFILE=~/.zsh.history
#setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
#setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt PUSHD_IGNORE_DUPS

autoload -U colors; colors

typeset -A title
title[start]="\e]0;"
title[end]="\a"


if [[ $TERM == (rxvt|xterm|screen)* && $oldterm != $TERM$WINDOWID ]]; then
    SHLVL=1
    export oldterm=$TERM$WINDOWID
fi

REPORTTIME=1
TIMEFMT="%E=%U+%S"

#PS1="%(?..%{${fg_bold[red]}%}%?%{$reset_color%} )%(2L.%{${fg_bold[yellow]}%}<%L>%{$reset_color%} .)%B%(#.%{${bg[red]}%}.)%m %(#..%{$fg[green]%})%#%{$reset_color%}%b "
#RPS1=" %{${fg_bold[green]}%}%~%{${fg_bold[black]}%}|%{${fg_bold[blue]}%}%(t.DING!.%*)%{$reset_color%}"

#ps_return_status="%(0?..%{${fg_bold[red]}%}%?%{$reset_color%} )"
#ps_shlvl="%(2L.%{${fg_bold[yellow]}%}<%L>%{$reset_color%} .)"
#ps_hostname="%(0#.%{${bg[red]}%}.%{${fg[green]}%}%n@)%m"
#ps_prompt="%#%{$reset_color%}"
#
#PS1="${ps_return_status}${ps_shlvl}%B${ps_hostname} ${ps_prompt}%b "
#RPS1=" %{${fg_bold[green]}%}%~%{${fg_bold[black]}%}|%{${fg_bold[blue]}%}%(t.DING!.%*)%{$reset_color%}"
#
#autoload promptinit
#promptinit
#
#setopt transientrprompt


setopt PROMPT_PERCENT
# Substitute vars.  Notice that we're in "", so $vars here are
# replaced already here.  All dynamic content needs to go
# in escaped \$vars.
#setopt PROMPT_SUBST
function prompt_generate {
    PS1=""
    prompt_time
    prompt_screen
    prompt_virtualenv
    # git dynamic content, i.e. branch name
    prompt_git
    # switch to red background when root
    PS1="$PS1%(#.%{${bg[red]}%}.)"
    # hostname
    PS1="$PS1%B%m%b:"
    # path
    PS1="$PS1%{${fg_bold[green]}%}%~%b/"
    # history number
    #PS1="$PS1%{${fg[magenta]}%}!%!$reset_color "
    # jobs display
    prompt_jobs
    # shell nesting
    PS1="$PS1%(2L.%{${fg_bold[yellow]}%}<%L>%{$reset_color%} .)"
    # tty name
    #PS1="$PS1%l "
    # start second line
    PS1="$PS1
"
    # If we're in paste mode, forget all the fancyness and only do
    # the basic prompt.
    if [[ -n $paste_mode ]] {
        PS1=""
    }
    # return value
    PS1="$PS1%(?..%{${fg_bold[red]}%}%?%{$reset_color%} )"
    # prompt!
    PS1="$PS1%(#.%{${bg_bold[red]}%}.%{$fg[green]%})%# %{$reset_color%}"
}

typeset -g lastding
function prompt_time {
    local t
    local -a curtime
    local hour
    local minute

    curtime=(${(@s,:,)$(print -Pn "%D{%H:%M}")})
    hour=$curtime[0]
    minute=$curtime[2]

    t="%*"
    if [[ $minute -eq 0 && $lastding -ne $hour ]]; then
        lastding=$hour
        # not using ^G here, because then cat'ing
        # this file will beep.
        t="DING!$(printf '\a')   "
    fi
    PS1="$PS1%{${fg_bold[blue]}%}$t%{$reset_color%} "
}

function prompt_screen {
    if [[ -n $STY ]] {
        PS1="${PS1}[${STY#*.}] "
        return
    }
}

function prompt_virtualenv {
    if [[ -n $VIRTUAL_ENV ]] {
        PS1="$PS1($(basename $VIRTUAL_ENV)) "
        return
    }
}

function prompt_git {
    local ref

    ref=$(git symbolic-ref HEAD 2>/dev/null)
    ref=${ref#refs/heads/}
    if [[ -n $ref ]] {
        # real symbolic ref
        PS1="$PS1<%{${fg[cyan]}%}$ref%{$reset_color%}> "
        return
    }

    # maybe detached?
    ref=$(git rev-parse HEAD 2>/dev/null)
    ref=${ref[0,10]}
    if [[ -n $ref ]] {
        # detached head, print commitid
        PS1="$PS1<%{${bg[cyan]}${fg[black]}%}$ref%{$reset_color%}> "
        return
    }
}

function prompt_jobs {
    # from http://www.miek.nl/blog/archives/2008/02/20/my_zsh_prompt_setup/index.html
    local js
    local jobno

    js=()
    for jobno (${(k)jobstates}) {
        local fullstate=$jobstates[$jobno]
        local state="${${(@s,:,)fullstate}[2]}"
        js+=($jobno${state//[^+-]/})
    }
    if [[ $#js -gt 0 ]]; then
        PS1="$PS1%{${fg[yellow]}%}[${(j:,:)js}]%{$reset_color%} "
    fi
}

function precmd {
    title_generate
    if [[ $TERM == eterm* ]]; then
        emacs_tramp_generate
    fi
    prompt_generate
}

function emacs_tramp_generate {
    ansih='\eAnSiT'

    print -P "${ansih}u %n"
    print -P "${ansih}c %/"
    print -P "${ansih}h %M"
}

function title_generate {}

if [[ $TERM == (rxvt|xterm|screen)* ]]; then
    function title_generate {
        print -Pn "${title[start]}%n@%m:%~${title[end]}"
    }

    function preexec {
        emulate -L zsh
        local -a cmd; cmd=(${(z)1})
        local -a checkjobs

        case $cmd[1] in
        fg|wait)
            if (( $#cmd == 1 ))
            then
                checkjobs=%+
            else
                checkjobs=$cmd[2]
            fi
            ;;
        %*)
            checkjobs=$cmd[1]
            ;;
        esac

        print -n "${title[start]}"

        if [[ -n "$checkjobs" ]]
        then
            # from: http://www.zsh.org/mla/workers/2000/msg03990.html
            local -A jt; jt=(${(kv)jobtexts})    # Copy jobtexts for subshell
            builtin jobs -l $checkjobs 2>/dev/null >>(read num rest
                cmd=(${(z)${(e):-\$jt$num}})
                print -nr "$cmd")
        else
            print -nr "$cmd"
        fi

        print -Pn " | %* | "
        print -Pn "%n@%m:%~"
        print -n "${title[end]}"
    }
fi

if which todo >/dev/null 2>&1; then
    function chpwd {
        # only print stuff in the interactive case
        [[ ! -o interactive ]] && return

        todo
    }
fi

if [[ -r ~/.aliasrc ]]; then
    source ~/.aliasrc
fi

umask 22

export PAGER='less -R'
export BLOCKSIZE=K
lesspipe=$(which lesspipe.sh 2>/dev/null) || \
lesspipe=$(which lesspipe 2>/dev/null)
if test -n "$lesspipe"; then
    export LESSOPEN="|$lesspipe %s"
fi

bindkey -e
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\eOH' beginning-of-line
bindkey '\eOF' end-of-line
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
autoload -U down-line-or-beginning-search
autoload -U up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
autoload run-help
bindkey '\eOP' run-help
bindkey '\e[M' run-help
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word
bindkey '\e[3~' delete-char
#WORDCHARS=${WORDCHARS//[\/&.;=]}
autoload -U select-word-style
select-word-style bash
zstyle ':zle:transpose-words' word-style shell
setopt NO_FLOW_CONTROL

function psrc {
    # change into the code directory of a python egg
    basedir=$(dirname $1)
    eggdir=$(basename $1)
    pushd $basedir
    pushd $eggdir
    srcdir='./'
    [ -d './src' ] && srcdir="$srcdir/src"
    srcdir="$srcdir/${eggdir:gs,.,/}"
    pushd $srcdir
}

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if test -x =dircolors; then
    if test -f ~/.dir_colors; then
    eval `dircolors ~/.dir_colors`
    else
    eval `dircolors`
    fi
    export ZLS_COLORS=${LS_COLORS}
fi

GPG_TTY=$( tty )
export GPG_TTY

eggcd() {
    egg=$1
    if test -z $egg; then 
    cd ~/dc/__git
    return 0
    fi
    path=$egg/trunk/src

    bIFS=$IFS
    IFS='.'
    for x in $egg; do
    path=$path/$x
    done
    IFS=$bIFS

    set -x
    cd $path
    set +x
}

# colors for the linux console
# commented are the values from phraktured
# in use are the colors from .Xdefaults, coming from vim ps_color
if [[ $TERM == "linux" ]]; then
    #echo -en "\e]P0222222" #black
    echo -en "\e]P0000000" #black
    #echo -en "\e]P1803232" #darkred
    echo -en "\e]P1800000" #darkred
    #echo -en "\e]P25b762f" #darkgreen
    echo -en "\e]P2008000" #darkgreen
    #echo -en "\e]P3aa9943" #brown
    echo -en "\e]P3d0d090" #brown
    #echo -en "\e]P4324c80" #darkblue
    echo -en "\e]P4000080" #darkblue
    #echo -en "\e]P5706c9a" #darkmagenta
    echo -en "\e]P5800080" #darkmagenta
    #echo -en "\e]P692b19e" #darkcyan
    echo -en "\e]P6a6caf0" #darkcyan
    #echo -en "\e]P7ffffff" #lightgrey
    echo -en "\e]P7d0d0d0" #lightgrey
    #echo -en "\e]P8222222" #darkgrey
    echo -en "\e]P8b0b0b0" #darkgrey
    #echo -en "\e]P9982b2b" #red
    echo -en "\e]P9f08060" #red
    #echo -en "\e]PA89b83f" #green
    echo -en "\e]PA60f080" #green
    #echo -en "\e]PBefef60" #yellow
    echo -en "\e]PBe0c060" #yellow
    #echo -en "\e]PC2b4f98" #blue
    echo -en "\e]PC80c0e0" #blue
    #echo -en "\e]PD826ab1" #magenta
    echo -en "\e]PDf0c0f0" #magenta
    #echo -en "\e]PEa1cdcd" #cyan
    echo -en "\e]PEc0d8f8" #cyan
    #echo -en "\e]PFdedede" #white
    echo -en "\e]PFe0e0e0" #white

    #this is an attempt at working utf8 line drawing chars in the linux-console
#    export TERM=linux+utf8
    #clear #hmm, yeah we need this or else we get funky background collisions
fi

export PATH=$HOME/.nodejs/bin:$PATH


# user specific stuff
[[ -r $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

cd .
