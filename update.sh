# set -e

nix flake update --option access-tokens "github.com=$(gh auth token)"
nh os switch .
nh home switch .
nh clean all
