#!/bin/bash

username=${1}

while test "${username}" = ""
do
   read -p "Please give a username: " username
done

#sudo smbpasswd -a $username

user_home=$(bash -c "cd ~$(printf %q "${username}") 2>/dev/null && pwd")
if test "$?" != "0";then
   echo "Invalid user"
fi

sudo smbpasswd -a ${username}

sudo bash -c "cat <<EOF >> /etc/samba/smb.conf
[${username}]
    path = ${user_home}
    writeable = yes
    browseable = yes
    valid users = ${username}
EOF"
