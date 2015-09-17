#!/bin/sh
if [[ $1 != "" ]]; then
rm -rf $1/src &&\
git clone https://npusgithub.emrsn.org/dowang/$1.git $1_up &&\
rsync -ar --exclude=.git $1_up/ $1/src &&\
rm -rf $1_up &&\
echo "done"
else
echo Please enter your component name !!!
fi

