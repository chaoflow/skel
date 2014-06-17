#!/bin/sh
#
# Update channel-nixos branch for nixos and nixpkgs repos

# config
NIXPKGS_REPO=$HOME/dev/nixos/nixpkgs
CHANNEL=/nix/var/nix/profiles/per-user/root/channels/nixos
REV_FILE=$CHANNEL/nixpkgs/.git-revision
BRANCH="channel-nixos"
UPDATE_CMD="git update-ref refs/heads/$BRANCH"
PUSH_CMD="git push chaoflow $BRANCH:$BRANCH"

set -x
sudo -H nix-channel --update
set +x

# get nixos and nixpkgs revision from channel
NIXPKGS_REV=$(cat $REV_FILE)

echo "Using revision file:"
echo "  $REV_FILE"
echo "nixpkgs revision: $NIXPKGS_REV"
echo

# update branches
set -x
(cd $NIXPKGS_REPO && git fetch --all && $UPDATE_CMD $NIXPKGS_REV && $PUSH_CMD)
