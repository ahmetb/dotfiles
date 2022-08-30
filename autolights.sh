#!/bin/bash

# from https://github.com/akburg/elgatokeylight/
IP=192.168.1.246
BRIGHTNESS=40
TEMPERATURE=160
log stream --predicate 'subsystem == "com.apple.UVCExtension" and composedMessage contains "Post PowerLog"' | while read line; do
  # The camera start event has been caught and is set to 'On', turn the light on
  if echo "$line" | grep -q "= On"; then
	echo "Camera has been activated, turn on the light."
	# Light 1 - change IP to your first lights IP
	curl --location --request PUT "http://$IP:9123/elgato/lights" --header 'Content-Type: application/json' --data-raw "{\"lights\":[{\"brightness\":$BRIGHTNESS,\"temperature\":$TEMPERATURE,\"on\":1}],\"numberOfLights\":1}"
  fi

  # If we catch a camera stop event, turn the light off.
  if echo "$line" | grep -q "= Off"; then
	echo "Camera shut down, turn off the light."
	#Light 1 - set to off
	curl --location --request PUT "http://$IP:9123/elgato/lights" --header 'Content-Type: application/json' --data-raw "{\"lights\":[{\"brightness\":$BRIGHTNESS,\"temperature\":$TEMPERATURE,\"on\":0}],\"numberOfLights\":1}"
  fi
done
