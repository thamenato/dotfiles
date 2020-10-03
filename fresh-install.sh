#/bin/env sh

function update_system {
  # update mirrors to fastest
  sudo pacman-mirrors --fasttrack 5

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
    nodejs
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

function install_fonts {
  yay -S nerd-fonts-complete
}

function install_image_apps {
  yay -S krita \
    gimp
}

function install_printer {
  yay -S brother-dcp-l2550dw 
}

function misc_apps {
  yay -S telegram \
    spotify
}
