#!/bin/sh
find . -name "*.h" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
