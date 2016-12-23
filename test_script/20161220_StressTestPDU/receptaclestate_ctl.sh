#!/usr/bin/expect
set timeout 10
set ip [lindex $argv 0]
set RECEPTACLE [lindex $argv 1]
set POWERSTATE [lindex $argv 2]
set user admin
set password admin
spawn ssh -o StrictHostKeyChecking=no "$user\@$ip"
expect {
        "assword:" {send "$password\r"}
        timeout {
           exit 1
        }
}
expect "Information"
send "receptaclestate $RECEPTACLE $POWERSTATE \r"
expect ">"
sleep 2
send "receptaclestate $RECEPTACLE \r"
expect {
        "\{$POWERSTATE" {}
        timeout {
           send "exit\r"
           expect "closed"
           exit 1
        }
}
send "exit\r"
interact
