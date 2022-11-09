#!/bin/bash

if [ $# -eq 1 ];then
   ISGITHUB=`git remote -v | grep origin | grep github`
   if test "${ISGITHUB}" != ""; then
      #echo "github"
      PRBRANCH="PR_${1}"
      git fetch origin pull/${1}/head:${PRBRANCH} && git checkout ${PRBRANCH}
   elif test "`git remote -v | grep origin | grep gitlab`" != ""; then
      #echo "gitlab"
      PRBRANCH="MR_${1}"
      git fetch origin merge-requests/${1}/head:${PRBRANCH} && git checkout ${PRBRANCH}      
   fi
else
   echo please enter a PR number.
fi
