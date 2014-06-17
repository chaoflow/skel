#typeset -U path
#path=(~/bin ~/.gem/ruby/1.8/bin $path)

# XXX: investigate what to quote for homes with spaces
USER_ZSH_FUNCTIONS=$HOME/.zfuncs
if [[ -d $USER_ZSH_FUNCTIONS ]]; then
    typeset -U fpath
    fpath=($USER_ZSH_FUNCTIONS $fpath)

    _zsh_reload_user_functions() {
        local f
        f=($USER_ZSH_FUNCTIONS/*(.))
        unfunction $f:t 2> /dev/null
        autoload -U $f:t
    }
fi

if [[ -r ~/.zshenv.local ]]; then
    source ~/.zshenv.local
fi
