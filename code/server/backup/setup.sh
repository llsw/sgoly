#!/bin/bash
sudo cp dataBackup.sh /usr/sbin/dataBackup.sh
sudo chmod +x /usr/sbin/dataBackup.sh
echo "* * * * * root /usr/sbin/dataBackup.sh" >>/etc/crontab