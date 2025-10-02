git fetch --all
git add .
git commit -m "sync"
git merge origin/main
nixos-generate-config --show-hardware-config > ./system/hardware-configuration.nix
