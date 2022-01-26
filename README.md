# H17 Smarthome project

## Intro

This repository contains all information and scripts (as much as possible) on my smarthome projects. As im working with Red Hat, i want to honor the open source way of working to share my automations and setup. Things i wont share are specifics around the alarm system and security setup.

H17 refers to the street and housename ... so theres the history in that. Im living with a son and my wife in the Netherlands.

If you like the guide and information [![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/Peterpaul "Buy Me A Coffee")

## Platform overview

I have a generic virtualized platform which runs a multitude of servers.

- firewall, domain controller, monitoring, docker hosts, steppingstones, raspberry pi's for individual tasks etc. 

For our smarthome setup we use the follow components.

### Basics

HASS virtual machnine
- Home Assistant Supervised on Debian (yes i know ... not Red Hat ... yet)
- Z-zwave via AEOTEC gen5 stick
  - Qubino dimmer & relays / Aeotec plugs / Eurotronic radiators / Neo Coolcam sensors & plugs / Heiman smoke detectors
- Zigbee via/with Philips Hue bridge
- Wifi / MQTT modules
  - Shelly 2.5 etc.
- Node-RED for automation flows

Docker virtual machine
- Compreface (AI/ML vision API)
- DSMR readers
- Portainer
- Monocle cam
- Double-take (see below)
- Deepstack (testing)


### Hardware platform

There are multiple options for running the above components, commonly a Raspberry PI or equivalent platform is used but im running already a virtualized platform with other components.

- 2x Dell PowerEdge R320 (Xeon E5-2420, 64GiB Ram)
- Synology DS920+ (4x 3TiB)
- HPE/Aruba series switches (2530-24G-POE+, 2530-8G-POE+, etc)
- 4x Vivotek / 2x Foscam POE cameras.
- Google Coral TPU
- 2x APC Backup UPS 
- 2x Raspberry PI 4b + POE HATs
- 23" Industrial touchscreen / bezelless for the home dashboard on PI #1
- P1 cable / reader on PI #2
- Redundant WAN - fiber 1000/1000mbit - 4G backup via Mikrotik router + Huawei stick.


<p align="center">
  <img src="https://i.imgur.com/XDkNqdP.jpeg" />
  <img src="https://tweakers.net/i/0r6HpkIA0E4dJyqFy1RX9d0q4Ds=/x800/filters:strip_icc():strip_exif()/f/image/AIuuBZATDU5sVqqeE1d0l8iR.jpg?f=fotoalbum_large" />
  <img src="https://tweakers.net/i/BnynUxD0-xjVEEZ8QYtpUjkWuh8=/x800/filters:strip_icc():strip_exif()/f/image/MQInl94P9KkwBdvsHLK8Ryuj.jpg?f=fotoalbum_large" />
</p>

### Integrations in Home-Assistant enabled

- Amazon Alexa
- Auto backup 
- BMW Connected drive
- Broadink
- Buienradar (weather forecast the Netherlands)
- CO2 Signal
- DSMR reader
- Elgato Key light (2 in studio)
- Frigate NVR (on Synology) - guides: https://github.com/blakeblackshear/frigate 
- Google Maps travel
- Grocy
- HACS (Home Assistant community store)
- Siemens Home Connect
- Sensor.community (Luftdaten)
- MQTT
- Mac Home Assistant companion - to integrate my macbook sensors in HA to do cool automations
- Google Nest
- Kodi
- Network UPS tools
- Node-red
- Opentherm Gateway with NodeMCU: https://github.com/rvdbreemen/OTGW-firmware
- Philips Hue
- Philips Android TV
- RFXcom 433mhz
- Resmed MyAir - sleep apnea device which i use. (read out my sleeping health) https://github.com/prestomation/resmed_myair_sensors/
- Shelly
- Spotify
- Synology
- Transmission BT (on Synology)
- pfSense UPNP
- Z-Wave JS with Z-wave JS to MQTT (for control panel)
- Telegram notification service
- Tasmoto

## Dashboard

I run one of the raspberry PI's with a industrial touchscrene, which is seamless mounted on the wall. Cabling runs thru the walls to the PI so i have the best possible/cleaned setup. THe system boots with autostart on chromium in kiosk mode. I edited /etc/xdg/lxsession/LXDE-pi/autostart for this.

I added: /usr/bin/chromium-browser --kiosk --disable-restore-session-state --disable-component-update http://HASSIP:8123/DASHBOARD-NAME/default_view?hide_sidebar=

I installed via HACS the kiosk card, which helps hiding the sidebar which i dont want to visualize.

I use also the 3d version of my home, created based on https://aarongodfrey.dev/home%20automation/creating-a-3d-floorplan-in-home-assistant/ as an interactive panel on the homescreen. 

<p align="center">
  <img src="https://i.imgur.com/VnICZaC.png" />
</p>

## Automations

### Generic automations 

Below are the ones i have implemented in my home. Those not related to security are uploaded as well.

- Realtime person tracking via Frigate NVR and Doubletake (check out https://github.com/jakowenko/double-take)
- Home build wake up lights - Philips style - with Hue Bulbs and the HASS "next_alarm" sensor.
- Bathroom fan - when humidity is above a certain level.
- Alarm system with sensors
- Power monitoring everything / plugs / dimmers etc.
   - DSMR is reading the central p1 power monitor and gathers this in the HASS energy dashboard.
- The upstairs thermostats are joined in a climate group so i can control them as a whole floor. (eurotronic spirit zwave)
- Nightly the HASS and frigate/AI-ML setup is backupped and transferred 1 locally to the drive 2 copied to the NAS 3 synced with a cloud storage provider. (using the 3 2 1 method for backups)

### Frigate / Synology surveillance tracking

- Using Frigate NVR with the Coral USB to actively track the people in my house. its now trained with myself and my wife with Compreface

### Light automations

- In toilet / storage and attic, office, lights turn on/off based on motion sensor, re-triggered / reset of the timer in case of continued presence.
- In the hallway / kitchen / dining and living lights turn on/off based on motion sensor, but included with mood scenes to dim after no presence is detected anymore. In this way creating a mood-effect, eg dimmed lights to provide a cozy atmosphere.
- Automated lights with sensors including day/night routines, mood scenes after sunset and vacation lights when the alarm is armed.
- When the webcam (sony a5100 via camlink 4k on USB) of my macbook is ' on ', it triggers the automation to turn on the studio lights (elgato key lights)

## House status

### Notification system automations

I wanted to maximize the way the house is reponsive in voice and notifications as well. so i linked telegram and alexa tts to specific events or information i want to know. THe family can then ask to the house via the [wakeword]alexa " whats the house status "  for example whici is returned via TTS and flows who get the actual sensor state values.

- House status: responds the amount of current power consumption (in watts, the remaining runtimes on the UPS batteries in the serverrack and hallway. Also reports the current central heating pressure in the system (in bar).
- Open Windows: responds / checks which windows are open and responds which are open and need to be closed
- Goodmorning: responds " good morning " (duh), puts on the lights, but also mentions if the last nights backup has failed and hasnt uploaded.
- Good night: responds nothing - but - when the car is not closed it will ' whisper ' the message thru the speaker i asked / mentioned goodnight to.
- Where is who?: based on the frigate information, i can ask " where is Peter-Paul "  which then voices back the last know home location, or, if im away or my wife is not at home, i will lookup the external location and mention this.
- Battery check: every day at 1200, the system will check the battery of the sensors in the house and will mention if a sensor is below 15% via a message on telegram.
- Zwave dead node check: every day at 1200, the system will check if a zwave node has the 'dead' status. HASS will notify me via telegram if this is the case and which node is dead (and i have to check).
- Kitchen check: sometimes it can happen the frigirator door is left open, after 2 minutes, it will mention this via a generic announce on alexa that the fridge is indeed open and needs to be closed. (you all know - sometimes in a rush - we forget)
- Garden: we hate cats in the garden whom are keeping  birds / wildlife away, so the camera / Frigate checks if theres a cat in the garden and mentions this as well via TTS so we can sprint to the garden and chase it away.
- Travel time: by integrating google maps, i can also ask the house how many minutes i need to get to the office, both for myseld and the missus.
- Door trigger: when the doorbell is pressed it makes a picture and sents it to telegram and mentions there is somebody at the door via Alexa TTS
- Door welcome message: when im returning from work or left for a longer time from the house, based on frigate and some other factors it determines if im in the hallway (sequence / cam detection / door opening / no wifi on phone) to send me via Alexa TTS a ' welcome back ' message to the hallway Amazon speaker.
- Alarm system: when the alarm is armed, the system will report any movement based on frigate/motion sensors/door sensors/sound and some other thingie, to telegram / sms and creates photos in the process. This flow i wont share ...
- Washing machine + dryer: the Node-red flows monitor the energy usage and when the value stays below a certain amount of time, the system will notice the washing machine or dryer is not in cycle mode anymore, and will report this accordingly.
- Smoke detection: multiple smoke detectors placed around the house which report via SMS / Telegram with photo and the HASS app if there is an emergency.
- With Opentherm Gateway and sensors, the house notifies me when the pressure of the heating system is getting low, and/or, issues with the boiler flame, other faults are detected.
- Morning alarm/wake up light link: you can use the integrated sensor of your phone (next_alarm) as an entity in an automation. Philips has nice wakeup lights but if you want this effect/routine with a different styled lamp then you have to program it yourself. Have build a node-red flow which checks / turns on a wakeuplight routine for me and my wife based on the alarm setting on our (android phones).
- Flood sensor: when flooding is detected in the storage room - HA will sent a telegram warning message and announce via the Alexa speakers there is water detected.
- Particle density: you can ask Alexa to tell you the current PM2.5 and PM10 particle density in the house in micrograms per qubic meter (air).
- BMW fuel remaining: you can ask Alexa how much fuel (liters) is remaning and the approximate range (km's) which you can drive with this.

## Other automations

- Central heating: when the windows in the office or master bedroom are open, the radiator valve is automatically closed. Done via a workaround to set the radiator at a very low temperature level. (14 degrees celcius)
- Kodi integration with Philips Hue + Philips Ambilight - when a movie is started - HASS switches Ambilight + Hue on so we have ambient lighting during the movie.

## Todo

- Garden irrigation / anti-cat: on the roadmap is the refurbishment of the front and back garden, the latter including a sprinkler system, which will water the plants and grass and acts also as a friendly 'chase the cats' away routine. If cat==detected, then turn on sprinkler system. :-)
- Out of bed lights: i have no lights / step out lights under the bed at the moment, probably this will be built in the near future.
- Grocy / Groceries inventory management: already had grocy running / integrated but no good sensor/hardware use case found to test inventory management yet. WIP untill i find something to monitor.

## Community ideas?

Do you have ideas which i didnt have thought about ? Perhaps you can suggest them so i can build them as well.
