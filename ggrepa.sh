#!/bin/sh
find . -name "*.[ch]" | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
