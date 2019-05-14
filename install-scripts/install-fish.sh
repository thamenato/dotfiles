#/bin/bash

if ! [ -x "$(command -v fish)" ]; then
	echo 'Fish not found! Installing...'
	sudo pacman -Syu fish --noconfirm
	curl -L https://get.oh-my.fish | fish
else
	echo 'Fish already installed!'
fi

exit 0
