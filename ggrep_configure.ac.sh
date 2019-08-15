#!/bin/sh
find . -type f -name configure.ac | grep -v ".svn" | xargs grep -Hn "$1" --color

exit 0
