#!/bin/sh -eu

echo 'launch front..'
# call wait-for-it with args and then start node if it succeeds
. /home/nix/.nix-profile/etc/profile.d/nix.sh && nix-shell prod.nix --verbose --command "npm run serve"