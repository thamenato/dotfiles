# Enable Powerlevel10k instant prompt. Should stay close to the top of /workspaces/kode/.devcontainer/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/usr/bin

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_AUTOSTART=true

plugins=(
    git
    git-auto-fetch
    zsh-autosuggestions
    tmux
)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit /workspaces/kode/.devcontainer/.p10k.zsh.
[[ ! -f /workspaces/kode/.devcontainer/.p10k.zsh ]] || source /workspaces/kode/.devcontainer/.p10k.zsh
