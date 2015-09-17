#!/bin/sh
find . -name "*" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
