#!/bin/sh
find . -type f -name "*" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
