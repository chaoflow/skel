#!/bin/sh
#
# Create tags in nixos and nixpkgs for the current root nixos channel
#
# The nixos and nixpkgs git repos need to be subdirs of the current
# working dir


# get nixos and nixpkgs revision from channel

CHANNEL=/nix/var/nix/profiles/per-user/root/channels/nixos
REV_FILE=$CHANNEL/nixos/svn-revision
TAG_CMD="git tag"

#TAG=nixos-channel-$(cut -d'_' -f1 < $REV_FILE)
TAG=nixos-channel-$(date +%Y-%m-%d-%H-%M)
REV_INFO=$(cut -d'_' -f2 < $REV_FILE)
NIXOS_REV=$(echo $REV_INFO | cut -d'-' -f1)
NIXPKGS_REV=$(echo $REV_INFO | cut -d'-' -f2)

echo "Using revision file:"
echo "  $REV_FILE"
echo "nixos revision:   $NIXOS_REV"
echo "nixpkgs revision: $NIXPKGS_REV"
echo


# check there is a nixos and nixpkgs dir in the current dir

if ! test -d nixos; then
    echo "ERROR: No nixos subdir"
    exit 1
fi
if ! test -d nixpkgs; then
    echo "ERROR: No nixpkgs subdir"
    exit 2
fi


# create tags

echo "nixos: $TAG_CMD $TAG $NIXOS_REV"
(cd nixos && $TAG_CMD $TAG $NIXOS_REV)

echo "nixpkgs: $TAG_CMD $TAG $NIXPKGS_REV"
(cd nixpkgs && $TAG_CMD $TAG $NIXPKGS_REV)
