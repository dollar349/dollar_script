#!/bin/sh
find . -name "*.c" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
