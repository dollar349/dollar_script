#!/bin/bash
has() {
    type "$1" >/dev/null 2>&1
}

if ! has expect; then
  echo  "expect not found! \"sudo apt-get install expect\""
fi

HOST="ecsfw@192.168.11.48"
PWD="ecsfw"

expect -c "spawn ssh ${HOST}; expect assword ; send ${PWD}\n; interact"
