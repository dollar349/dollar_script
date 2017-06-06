#!/bin/sh
git fetch origin pull/${1}/head:pull_${1}
git checkout pull_${1}
