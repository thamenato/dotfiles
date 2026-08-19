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

# Get Firefox Extension Id
get-firefox-ext-id link:
    #!/usr/bin/env bash
    ext_name=$(
        echo "{{ link }}" \
         | sed -E 's|https://addons.mozilla.org/firefox/downloads/file/[0-9]+/([^/]+)-[^/]+\.xpi|\1|' \
         | tr '_' '-'
    )
    download=$(
        echo "$ext_name" \
         | awk '{print "https://addons.mozilla.org/firefox/downloads/latest/" $1 "/latest.xpi"}'
    )
    cd $(mktemp -d)
    wget "$download"
    unzip latest.xpi -d my-extension && cd my-extension
    ext_id=$(cat manifest.json | jq -r '.browser_specific_settings.gecko.id')
    echo "\"${ext_id}\" = \"${ext_name}\";"

# Set up / refresh GPU drivers on non-NixOS hosts (targets.genericLinux.gpu)
gpu-setup host=`hostname` user=`whoami`:
    #!/usr/bin/env bash
    set -e

    setup="{{ home_dir() }}/.nix-profile/bin/non-nixos-gpu-setup"
    if [ ! -x "$setup" ]; then
        echo "non-nixos-gpu-setup not found — is targets.genericLinux.gpu enabled for {{ user }}@{{ host }}?"
        exit 1
    fi

    new=$(nix eval --raw ".#homeConfigurations.\"{{ user }}@{{ host }}\".config.targets.genericLinux.gpu.drivers")
    current=$(readlink /run/opengl-driver || true)

    if [ "$current" = "$new" ]; then
        echo "GPU drivers already up to date ($new)"
        exit 0
    fi

    echo "GPU drivers stale or missing:"
    echo "  current: ${current:-<none>}"
    echo "  new:     $new"
    echo "Running: sudo $setup"
    sudo "$setup"

# Scaffold a new non-NixOS host module, cloned from an existing one
new-host HOSTNAME=`hostname` TEMPLATE="thales-precision-5490":
    #!/usr/bin/env bash
    set -euo pipefail

    src="modules/home/hosts/{{ TEMPLATE }}"
    dst="modules/home/hosts/{{ HOSTNAME }}"
    cfg="modules/home/default.nix"

    if [ ! -d "$src" ]; then
        echo "template host not found: $src"
        exit 1
    fi
    if [ -d "$dst" ]; then
        echo "$dst already exists -- nothing to do"
        exit 1
    fi

    echo ">>> copying $src -> $dst"
    cp -r "$src" "$dst"

    # Every reference inside the host module is of the form
    # hosts/<name>[/sub], including the header comments, so one substitution
    # renames the module attributes, the imports and the comments together.
    find "$dst" -type f -name '*.nix' -exec \
        sed -i 's|hosts/{{ TEMPLATE }}|hosts/{{ HOSTNAME }}|g' {} +

    if grep -q '"${username}@{{ HOSTNAME }}"' "$cfg"; then
        echo ">>> $cfg already lists {{ HOSTNAME }}, leaving it alone"
    else
        echo ">>> registering {{ HOSTNAME }} in flake.homeConfigurations"
        entry='    "${username}@{{ HOSTNAME }}" = mkHome "{{ HOSTNAME }}";'
        awk -v entry="$entry" '
            /flake\.homeConfigurations = \{/ { inblock = 1; print; next }
            inblock && index($0, "@") && !placed && $0 > entry {
                print entry
                placed = 1
            }
            inblock && $0 ~ /^[[:space:]]*\};/ && !placed {
                print entry
                placed = 1
            }
            /^[[:space:]]*\};/ { inblock = 0 }
            { print }
        ' "$cfg" > "$cfg.tmp"
        mv "$cfg.tmp" "$cfg"
    fi

    if command -v alejandra >/dev/null 2>&1; then
        alejandra --quiet "$dst" "$cfg" >/dev/null 2>&1 || true
    fi

    echo
    echo ">>> scaffolded {{ HOSTNAME }} from {{ TEMPLATE }}"
    echo
    echo "Machine-specific bits you still need to review before switching:"
    echo "  $dst/services.nix          kanshi profiles (monitor criteria + modes)"
    echo "  $dst/programs/niri.nix     outputs, per-output wallpapers, spawn-at-startup"
    echo "  $dst/programs/default.nix  git signing key"
    echo "  $dst/packages.nix          host package list"
    echo
    echo "Then verify and switch:"
    echo "  nix eval .#homeConfigurations --apply builtins.attrNames"
    echo "  nh home switch"
