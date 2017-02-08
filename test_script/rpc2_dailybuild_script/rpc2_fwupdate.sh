#!/usr/bin/expect
set timeout 30
set PDU_IP [lindex $argv 0]
set FTP_IP [lindex $argv 1]
set IMAGE_PATH [lindex $argv 2]
set IMAGE_NAME [lindex $argv 3]

set timeout 10
set ip [lindex $argv 0]
set ARRAYSIZE [lindex $argv 1]
set user root
set password linux
spawn ssh -o StrictHostKeyChecking=no "$user\@$ip"
expect {
        "assword:" {send "$password\r"}
        timeout {
           exit 1
        }
}
expect "~]#"
send "fetchImage ${FTP_IP} dailybuild  dailybuild ${IMAGE_PATH} ${IMAGE_NAME}\r"
set timeout 600
expect  {
        "~]#" {}
        timeout {
           send "exit\r"
           expect "closed"
           exit 1
        }
}
send "flashImage -clean_etc -clean_home /tmp/avoImage\r"
expect  {
        "~]#" {}
        timeout {
           send "exit\r"
           expect "closed"
           exit 1
        }
}
send "reboot \r"
expect  {
        "~]#" {}
        timeout {
           send "exit\r"
           expect "closed"
           exit 1
        }
}
send "exit\r"
expect eof
exit