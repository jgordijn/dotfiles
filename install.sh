#!/bin/bash
thisDir=$(dirname $0)
for i in $(find ${thisDir}/root -type f);
do
	linkTo=$(readlink -f $i)
	ln -sv $linkTo ~
done

for i in $(find ${thisDir}/config/* -type d);
do
	linkTo=$(readlink -f $i)
	ln -sv $linkTo ~/.config
done
ln -sv ~/.config/tmux/tmux.conf ~/.tmux.conf

OHMYDIR=~/.oh-my-zsh
if [ ! -d "$OHMYDIR" ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

VIMPLUGFILE=~/.vim/autoload/plug.vim
if [ ! -f "$VIMPLUGFILE" ]; then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
NVIMPLUGFILE=~/.local/share/nvim/site/autoload/plug.vim
if [ ! -f "$NVIMPLUGFILE" ]; then
	curl -fLo $NVIMPLUGFILE --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

which fzf > /dev/null
if [ $? -ne 0 ]; then
	echo Install FZF!
fi

