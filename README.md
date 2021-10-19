# H17 Smarthome project

## Intro

This repository contains all information and scripts (as much as possible) on my smarthome projects. As im working with Red Hat, i want to honor the open source way of working to share my automations and setup. Things i wont share are specifics around the alarm system and security setup.

H17 refers to the street and housename ... so theres the history in that. Im living with a son and my wife in the Netherlands.

## Platform overview

For our smarthome setup we use the follow components.

### Basics

- Home Assistant Supervised on Debian (yes i know ... not Red Hat ... yet)
- Z-zwave via AEOTEC gen5 stick
- Zigbee via/with Philips Hue bridge
- Wifi / MQTT modules
- Node-RED for automation flows

### Hardware platform

There are multiple options for running the above components, commonly a Raspberry PI or equivalent platform is used but im running already a virtualized platform with other components.

- 2x Dell PowerEdge R320 (Xeon E5-2420, 64GiB Ram)
- Synology DS920+ (4x 3TiB)
- HPE/Aruba series switches (2530-24G-POE+, 2530-8G-POE+, etc)
- Vivotek / Foscam POE cameras.
- Google Coral TPU
- APC Backup UPS x2
- 2x Raspberry PI 4b + POE HATs
- 23" Industrial touchscreen / bezelless for the home dashboard on PI #1
- P1 cable / reader on PI #2

<p align="center">
  <img src="https://tweakers.net/i/0r6HpkIA0E4dJyqFy1RX9d0q4Ds=/x800/filters:strip_icc():strip_exif()/f/image/AIuuBZATDU5sVqqeE1d0l8iR.jpg?f=fotoalbum_large" />
</p>

### Integrations in Home-Assistant enabled

- Amazon Alexa
- Auto backup 
- BMW Connected drive
- Broadink
- Buienradar (weather forecast the Netherlands)
- CO2 Signal
- DSMR reader
- Frigate NVR (on Synology)
- Google Maps travel
- Grocy
- HACS (Home Assistant community store)
- Siemens Home Connect
- Sensor.community (Luftdaten)
- MQTT
- Google Nest
- Network UPS tools
- Node-red
- Opentherm Gateway
- Philips HUe
- RFXcom 433mhz
- Shelly
- Spotify
- Synology
- Transmission BT (on Synology)
- pfSense UPNP
- Z-Wave JS with Z-wave JS to MQTT (for control panel)
- Telegram notification service

## Dashboard

I run one of the raspberry PI's with a industrial touchscrene, which is seamless mounted on the wall. Cabling runs thru the walls to the PI so i have the best possible/cleaned setup. THe system boots with autostart on chromium in kiosk mode. I edited /etc/xdg/lxsession/LXDE-pi/autostart for this.

I added: /usr/bin/chromium-browser --kiosk --disable-restore-session-state --disable-component-update http://HASSIP:8123/DASHBOARD-NAME/default_view?hide_sidebar=

I instelled via HACS the kiosk card, which helps hiding the sidebar which i dont want to visualize.

## Automations

All automations below are the ones i have implemented in my home. Those not related to security are uploaded as well.

- Automated lights with sensors including day/night routines, mood scenes after sunset and vacation lights when the alarm is armed.
- Realtime person tracking via Frigate NVR and Doubletake (check out https://github.com/jakowenko/double-take)
- Home build wake up lights - Philips style - with Hue Bulbs and the HASS "next_alarm" sensor.
- Bathroom humidity control with a standard HASS automation (lazy to migrate it to Node-Red)
- Home Notfication system with Telegram and Alexa TTS

### Frigate / Synology surveillance tracking

- Using Frigate NVR with the Coral USB to actively track the people in my house. its now trained with myself and my wife with Compreface

### Light automations

- In toilet / storage and attic, office, lights turn on/off based on motion sensor, re-triggered / reset of the timer in case of continued presence.
- In the hallway / kitchen / dining and living lights turn on/off based on motion sensor, but included with mood scenes to dim after no presence is detected anymore. In this way creating a mood-effect, eg dimmed lights to provide a cozy atmosphere.

### Home notification system

I wanted to maximize the way the house is reponsive in voice and notifications as well. so i linked telegram and alexa tts to specific events or information i want to know. THe family can then ask to the house via the [wakeword]alexa " whats the house status "  for example whici is returned via TTS and flows who get the actual sensor state values.

- House status: responds the amount of power usage and the remaining runtimes on the UPS batteries
- Open Windows: responds / checks which windows are open and responds which are open and need to be closed
- Goodmorning: responds " good morning " (duh) but also mentions if the last nights backup has failed and hasnt uploaded.
- Good night: responds nothing - but - when the car is not closed it will ' whisper ' the message thru the speaker i asked / mentioned goodnight to.
- Where is who?: based on the frigate information, i can ask " where is Peter-Paul "  which then voices back the last know home location, or, if im away or my wife is not at home, i will lookup the external location and mention this.
- Battery check: every day at 1200, the system will check the battery of the sensors in the house and will mention if a sensor is below 15% via a message on telegram.
- Kitchen check: sometimes it can happen the frigirator door is left open, after 2 minutes, it will mention this via a generic announce on alexa that the fridge is indeed open and needs to be closed. (you all know - sometimes in a rush - we forget)
- Garden: we hate cats in the garden because it keeps the birds / wildlife away, so the camera / Frigate checks if theres a cat in the garden and mentions this as well via TTS so we can jump to the garden to chase it away.
- Travel time: by integrating google maps, i can also ask the house how many minutes i need to get to the office, both for myseld and the missus.
- Alarm system: when the alarm is armed, the system will report any movement based on frigate/motion sensors/door sensors/sound and some other thingie, to telegram / sms and creates photos in the process. This flow i wont share ...

## Todo

- Garden irrigation / anti-cat: on the roadmap is the refurbishment of the front and back garden, the latter including a sprinkler system, which will water the plants and grass and acts also as a friendly 'chase the cats' away routine. If cat==detected, then turn on sprinkler system. :-)
- Out of bed lights: i have no lights / step out lights under the bed at the moment, probably this will be built in the near future.
- Grocy / Groceries inventory management: already had grocy running / integrated but no good sensor/hardware use case found to test inventory management yet. WIP untill i find something to monitor.

## Community ideas?

Do you have ideas which i didnt have thought about ? Perhaps you can suggest them so i can build them as well.
