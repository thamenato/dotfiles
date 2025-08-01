#!/usr/bin/env bash
#
# @describe My nh wrapper with batteries
#

DOTFILE_REPO="$HOME/dotfiles"
NIXOS_REPO="$HOME/Projects/nixos-hosts"
CACHE_HOSTNAME=nix-cache.cthyllaxy.xyz

_check_cache() {
    # check if running the command where
    # private cache is available
    if ping -c 1 -W 1 "$CACHE_HOSTNAME" >/dev/null 2>&1; then
        return 0
    fi

    return 1
}

# @cmd Update home-manager
# @alias hm
home() {
    nh home switch "$DOTFILE_REPO" \
        --ask \
        --backup-extension .bak

    argc_mode="home"
    cache
}

# @cmd Update nixos host
os() {
    nh os switch "$NIXOS_REPO" \
        --ask
    cache
}

# @cmd Check cache
# @arg mode     Mode to run the cache
cache() {
    local folder
    folder="/run/current-system"

    if ! _check_cache; then
        echo "Cache unreachable, skipping push"
        return
    fi

    if [[ "$argc_mode" == "home" ]]; then
        folder="$HOME/.nix-profile"
    fi

    echo "Pushing $folder to private cache"

    nix copy \
        --to ssh://cthulhu@10.0.10.10 \
        "$folder"
}

eval "$(argc --argc-eval "$0" "$@")"
