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
