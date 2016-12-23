#!/usr/bin/expect
set timeout 10
set ip 10.162.244.33
set user admin
set password admin 
spawn ssh -o StrictHostKeyChecking=no "$user\@$ip"
expect "password:"
send "$password\r"
expect {
        "Information" {send "time\r"}
        timeout {
           send "exit\r"
           expect "closed"
           exit 1
        }
}
send "exit\r"

