#!/bin/bash
thisDir=$(dirname $0)
for i in $(find ${thisDir}/root -type f);
do
	linkTo=$(readlink -f $i)
	ln -svf $linkTo ~
done
