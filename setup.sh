#!/usr/bin/env bash

echo "@reboot root sleep 20 && hostname -I | mail -s metaalarm sebastian.pfeifer@unicorncloud.org" | sudo tee /etc/cron.d/ip
echo "* * * * * root bash /home/spfeifer/projects/metaalarm/smsparser.sh" | sudo tee /etc/cron.d/smsparser
echo "@reboot root cd /home/spfeifer/projects/metaalarm/relaisboardsteuerung && ./usb-relay" | sudo tee /etc/cron.d/relaysoffatreboot
echo "0 0 * * * root reboot" | sudo tee /etc/cron.d/dailyreboot
sudo apt install smstools procmail -y
sudo systemctl enable smstools.service
sudo rm /etc/smsd.conf
sudo cp smsd.conf /etc/smsd.conf
sudo systemctl restart smstools.service
