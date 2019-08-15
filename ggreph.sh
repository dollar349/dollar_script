#!/bin/sh
find . -name "*.h" -o -name "*.hpp" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
