#!/bin/sh
find . -path './build*' -prune -o -type f -name "$1"

exit 0
