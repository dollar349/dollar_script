#!/bin/bash

if [ $# -eq 1 ];then
   PRBRANCH="PR_${1}"
   git fetch origin pull/${1}/head:${PRBRANCH} && git checkout ${PRBRANCH}
else
   echo please enter a PR number.
fi
