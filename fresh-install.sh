#/bin/env sh

function update_system {
  # update mirrors to fastest
  sudo pacman-mirrors --fasttrack 
  # update system
  sudo pacman -Syuu --noconfirm
}

function install_basic_apps {
  # install basic applications
  sudo pacman -S --noconfirm \
    yay \
    neovim \
    zsh \
    tmux \
    alacritty \
    cowsay \
    fortune-mod \
    pyenv \
    base-devel \
    bashtop \
    nodejs \
    fzf \
    yarn \
    wmctrl \
    rofi \
    flameshot \
    sysstat \
    i3blocks \
    ttf-meslo-nerd-font-powerlevel10k \
    noto-fonts-emoji
}

function config_zsh {
  # install oh-my-zsh / powerlevel10k / zsh-autosuggestion
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

function config_nvim {
  # install vim-plug
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

function install_browser {
  yay -S vivaldi \
    vivaldi-ffmpeg-codecs \
    vivaldi-widevine
}

function install_image_apps {
  yay -S krita \
    gimp
}

function install_printer {
  yay -S brother-dcp-l2550dw 
}

function misc_apps {
  yay -S --noconfirm \
    telegram-desktop \
    steam \
    signal-desktop \
    visual-studio-code-bin \
    jetbrains-toolbox

  snap install spotify
}

function python_apps {
  version="3.9.6"
  pyenv install $version
  pyenv global $version
  pip install -U pip
  pip install pipx
  # aws command line
  pipx install awscli 
  # spotify i3blocks plugin
  yay -S gobject-introspection --noconfirm
  pipx install i3blocks-mpris
}

function fix_time {
  sudo systemctl start ntpd
  # sudo systemctl enable ntpd
}

# if no argument was passed, show available functions
if [[ $# -eq 0 ]]; then
  IFS=$'\n'
  for f in $(declare -F); do
    echo "${f:11}"
  done
fi

$1

