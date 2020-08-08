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

alarm () {
  aplay -Ddefault:CARD=U0x41e0x30d3 /home/spfeifer/projects/metaalarm/alarm.wav
}

cd /var/spool/sms/incoming

for sms in $(ls -1); do
  from=$(formail -zx From: < $sms)
  text=$(formail -I "" < $sms | sed -e"1d")

  blink &
  alarm &

  # Replace Umlauts and ß
  text="${text//ü/ue}"
  text="${text//ö/oe}"
  text="${text//ä/ae}"

  text="${text//Ü/Ue}"
  text="${text//Ö/Oe}"
  text="${text//Ä/Ae}"

  text="${text//ß/ss}"

  # Cut off the text after 50 characters
  text=$(echo $text | cut -c-50)

  echo -e "$(date +"%d.%m.%Y %H:%M") : +${from} : ${text}\r\n:" | sudo tee /dev/usb/lp0

  rm $sms
done
