#!/usr/bin/env bash

blink () {
  cd /home/spfeifer/projects/metaalarm/relaisboardsteuerung
  sudo ./usb-relay 5 > /dev/null 2>&1
  sleep 0.2
  sudo ./usb-relay 6 > /dev/null 2>&1
  sleep 0.2
  sudo ./usb-relay 5 > /dev/null 2>&1
  sleep 0.2
  sudo ./usb-relay 6 > /dev/null 2>&1
  sleep 0.2
  sudo ./usb-relay > /dev/null 2>&1
}

cd /var/spool/sms/incoming

for sms in $(ls -1); do
  from=$(formail -zx From: < $sms)
  text=$(formail -I "" < $sms | sed -e"1d")

  blink &

  text="${text//ü/ue}"
  text="${text//ö/oe}"
  text="${text//ä/ae}"

  text="${text//Ü/Ue}"
  text="${text//Ö/Oe}"
  text="${text//Ä/Ae}"

  text="${text//ß/ss}"

  echo -e "$(date +"%d.%m.%Y %H:%M") : +${from} : ${text}\r\n:" | sudo tee /dev/usb/lp0

  rm $sms
done
