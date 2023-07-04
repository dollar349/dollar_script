#!/bin/sh

TARGET_FILE=$BASH_SOURCE
cd `dirname $TARGET_FILE`
TARGET_FILE=`basename $TARGET_FILE`

# Iterate down a (possible) chain of symlinks
while [ -L "$TARGET_FILE" ]
do
    TARGET_FILE=`readlink $TARGET_FILE`
    cd `dirname $TARGET_FILE`
    TARGET_FILE=`basename $TARGET_FILE`
done
# Compute the canonicalized name by finding the physical path
# for the directory we're in and appending the target file.
PHYS_DIR=`pwd -P`
ABSPATH=$PHYS_DIR/$TARGET_FILE
SCRIPTPATH=$(dirname "$ABSPATH")

cat > ~/.bash_profile << EOF
# Source global definitions
if [ -f ~/.bashrc ]; then
     . ~/.bashrc
fi
EOF

echo "alias ll='ls -l'" >> ~/.bashrc

ln -s ${SCRIPTPATH}/screenrc ~/.screenrc
ln -s ${SCRIPTPATH}/tmux.conf ~/.tmux.conf
ln -s ${SCRIPTPATH}/vimrc ~/.vimrc

# call add_bashrc.sh
${SCRIPTPATH}/add_bashrc.sh

