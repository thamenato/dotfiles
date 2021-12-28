#/bin/env sh

function update_system {
  # update mirrors to fastest
  sudo pacman-mirrors --fasttrack 
  # update system
  sudo pacman -Syuu --noconfirm
}

function must_install {
  sudo pacman -S --noconfirm \
    vivaldi \
    vivaldi-ffmpeg-codecs \
    yay \
    neovim \
    zsh \
    fzf \
    alacritty \
    pyenv \
    nodejs \
    yarn \
    flameshot \
    noto-fonts-emoji
  # ttf-meslo-nerd-font-powerlevel10k
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

function install_i3_extras {
  sudo pacman -S --noconfirm \
    wmctrl \
    sysstat \
    i3blocks \
    rofi
}

function install_image_apps {
  yay -S krita \
    gimp
}

function install_printer {
  yay -S brother-dcp-l2550dw 
}

function install_apps {
  yay -S --noconfirm \
    telegram-desktop \
    steam \
    signal-desktop \
    visual-studio-code-bin \
    jetbrains-toolbox \
    slack-desktop \
    spotify \
    easyeffects
}

function python_apps {
  version="3.10.0"
  pyenv install $version
  pyenv global $version
  pip install -U pip
  pip install pipx
  yay -S gobject-introspection --noconfirm
  pipx install i3blocks-mpris
  # aws command line
  # pipx install awscli // awscli is outdated on pipx
  # use https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  # spotify i3blocks plugin
}

function fix_time {
  sudo systemctl start ntpd
  # sudo systemctl enable ntpd
}

function install_misc {
  # install basic applications
  sudo pacman -S --noconfirm \
    tmux \
    cowsay \
    fortune-mod \
    base-devel \
    bashtop
}

# if no argument was passed, show available functions
if [[ $# -eq 0 ]]; then
  IFS=$'\n'
  for f in $(declare -F); do
    echo "${f:11}"
  done
fi

$1

