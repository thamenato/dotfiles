_default:
    @just --list

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
    cp {{ home_dir() }}/.config/sops/age/keys.txt "$temp/sops/age/keys.txt"
    chmod 600 "$temp/sops/age/keys.txt"

    nix run github:nix-community/nixos-anywhere -- --flake ".#{{ HOSTNAME }}" \
        --generate-hardware-config nixos-generate-config ./hosts/{{ HOSTNAME }}/hardware-configuration.nix \
        --extra-files "$temp" \
        {{ USER }}@{{ IP }}

# Get Age key from Bitwarden
get-age-key-from-bw:
    mkdir -p {{ home_dir() }}/.config/sops/age
    bw get attachment keys.txt  --itemid "2da195b6-61cb-4ecb-a455-b1e5018476a2" --output "{{ home_dir() }}/.config/sops/age/keys.txt"

# Restore host SSH key that is stored in the repo
restore-ssh-key host=`hostname` user=`whoami` key="id_ed25519":
    #!/usr/bin/env bash
    set -e

    echo "Using host={{ host }} and user={{ user }}"
    filepath={{ home_dir() }}/.ssh/{{ key }}

    write_key() {
        install -d -m700 {{ home_dir() }}/.ssh
        sops decrypt secrets/sshKeys.yaml | yq '.{{ host }}.{{ user }}' -r > "$filepath"
        chmod 600 "$filepath"
        ssh-keygen -y -f "$filepath" > "$filepath.pub"
    }

    if [ ! -f $filepath ]; then
        echo "Decrypting SSH key to $filepath"
        write_key
        exit 0
    else
        echo "File exists!"
        printf "Overwrite file $filepath? (y/n): "
        read -r response
    fi

    if [ "$response" = "y" ]; then
        echo "Overwritting SSH key at $filepath"
        write_key
    else
        echo "Not doing anything"
    fi
