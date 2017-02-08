#!/usr/bin/expect
set timeout 30
set RPC2_BRANCH [lindex $argv 0]
set DAILYBUILD_FOLDER [lindex $argv 1]
set WORKSPACE [lindex $argv 2]
set P4_USER [lindex $argv 3]

spawn activate -p rpc2k -b ${RPC2_BRANCH} -d ${DAILYBUILD_FOLDER}/ -c ${WORKSPACE} -u ${P4_USER} -g 
expect "\>"
set timeout -1
send "bitbake rpc2k-image > ${DAILYBUILD_FOLDER}/build.log 2>&1\r"
expect "\>"
send "echo AAA >> ${DAILYBUILD_FOLDER}/build.log\r"
expect "\>"
send "exit\r"
interact
