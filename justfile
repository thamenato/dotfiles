# New install on a remote machine
remote-install HOSTNAME USER IP:
    #!/usr/bin/env bash
    set -e

    temp=$(mktemp -d)

    cleanup() {
        rm -rf "$temp"
    }
    trap cleanup EXIT

    install -d -m755 "$temp/sops/age"
    cp ~/.config/sops/age/keys.txt "$temp/sops/age/keys.txt"
    chmod 600 "$temp/sops/age/keys.txt"

    nix run github:nix-community/nixos-anywhere -- --flake ".#{{ HOSTNAME }}" \
        --generate-hardware-config nixos-generate-config ./hosts/{{ HOSTNAME }}/hardware-configuration.nix \
        --extra-files "$temp" \
        {{ USER }}@{{ IP }}
