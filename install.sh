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
	echo $linkTo
	ln -sv $linkTo ~/.config
done
ln -sv ~/.config/tmux/tmux.conf ~/.tmux.conf
