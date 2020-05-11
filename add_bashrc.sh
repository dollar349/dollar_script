#!/bin/bash
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")
GITPROMPT="/etc/bash_completion.d/git-prompt"
BASHRC="~/.bashrc"
eval BASHRC=$BASHRC

cd ~ && MYPATH=`pwd` && cd - > /dev/null
ADD_PATH=`echo $SCRIPTPATH | sed  "s,"${MYPATH}",~,g"`

echo "PATH=\$PATH:$ADD_PATH" >> $BASHRC 

if [[ -e ${GITPROMPT} ]]; then
    echo "source /etc/bash_completion.d/git-prompt" >> $BASHRC
    echo 'PS1="\[\e[01;32m\][\T]\[\033[35m\][\w]\[\033[36m\]\$(__git_ps1)\n\[\033[1;33m\]\u~[\h]$ \[\033[0m\]"' >> $BASHRC
else
    echo 'PS1="\[\e[01;32m\][\T]\[\033[35m\][\w]\[\033[36m\] \n\[\033[1;33m\]\u~[\h]$ \[\033[0m\]"' >> $BASHRC
fi


# function rebake { bitbake -c cleanall $@ && bitbake $@; }

