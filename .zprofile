# XXX: Is it possible to generalize here?

export EDITOR="emacsclient -c"
# this starts emacs --daemon if not running already
export ALTERNATE_EDITOR=""
export EMAIL=flo@chaoflow.net
export FULLNAME="Florian Friesdorf"
export INFOPATH="~/.info${INFOPATH:+:$INFOPATH}"
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

if which keychain >/dev/null 2>&1; then
    eval `keychain --eval --quick --agents gpg,ssh id_dsa 0C45F083`
fi

test -d /tmp/cfl || mkdir /tmp/cfl
