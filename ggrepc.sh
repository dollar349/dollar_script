#!/bin/sh
find . -name "*.c" -o -name "*.cpp" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
