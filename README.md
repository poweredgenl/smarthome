# H17 Smarthome project

## Intro

This repository contains all information and scripts (as much as possible) on my smarthome projects. As im working with Red Hat, i want to honor the open source way of working to share my automations and setup. Things i wont share are specifics around the alarm system and security setup.

H17 refers to the street and housename ... so theres the history in that. Im living with a son and my wife in the Netherlands.

If you like the guide and information [![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/Peterpaul "Buy Me A Coffee")

## Platform overview

I have a generic virtualized platform which runs multiple servers, all in service for the smarthome platform.

- firewall (pfSense), domain controller (users/auth/windows based systems), monitoring (LibreNMS), docker hosts, steppingstones, raspberry pi's for individual tasks etc. 

Total number of devices/sensors/automations/items/boleans/node red blocks in my smart home (dd - 28-01-2022) - 1275 items.

### Smarthome Basic overview

HASS virtual machine
- Home Assistant Supervised
- Z-zwave via AEOTEC gen5 stick (+/- 50 devices)
  - Qubino dimmer & relays / Aeotec plugs / Eurotronic radiators / Neo Coolcam sensors & plugs / Heiman smoke detectors
- Philips Hue  (+/- 20 devices)
- Wifi / MQTT modules
  - Shelly 2.5 (3x)
  - NodeMCU (2x)
- Node-RED for automation flows
- RFX 433Mhz transmitter (doorbell / covers)

Later in this readme all the integrations i have enabled in Home Assistant.

Docker virtual machine for secondary / specific tasks
- Compreface (AI/ML vision API)
- DSMR reader
- Portainer
- Monocle cam (translates local cameras on synology into RTSP streams the Echo devices can see/view)
- Double-take (intermediate software which bridges between Frigate and Compreface)

### Hardware platform

There are multiple options for running the above components, commonly a Raspberry PI or equivalent platform is used but im running already a virtualized platform with other components.

- 2x Dell PowerEdge R320 (Xeon E5-2420, 64GiB Ram)
- Synology DS920+ (4x 3TiB)
- HPE/Aruba series switches (2530-24G-POE+, 2530-8G-POE+, etc)
- 4x Vivotek / 2x Foscam POE cameras.
- Google Coral TPU
- 2x APC Backup UPS 
- 2x Raspberry PI 4b + POE HAT (for P1/Rfxcom, and one for the Home Dashboard - see below))
- 23" Industrial touchscreen 
- P1 cable / reader on PI #2
- Redundant WAN - fiber 1000/1000mbit - 4G backup via Mikrotik router + Huawei stick.

#### Server rack in storage room

Small overview of the main equipment running the house. Rack consumes approx 250 watt 24/7 (which i think is quite reasonable).

<p align="center">
  <img src="https://tweakers.net/i/0r6HpkIA0E4dJyqFy1RX9d0q4Ds=/x800/filters:strip_icc():strip_exif()/f/image/AIuuBZATDU5sVqqeE1d0l8iR.jpg?f=fotoalbum_large" />
  <img src="https://tweakers.net/i/BnynUxD0-xjVEEZ8QYtpUjkWuh8=/x800/filters:strip_icc():strip_exif()/f/image/MQInl94P9KkwBdvsHLK8Ryuj.jpg?f=fotoalbum_large" />
</p>

## Home Assistant overview

### Dashboard


To have a proper overview of the house, and to control everything i have wall mounted touchscreen, with cables running in the walls, and a RPI which is located in a secret compartiment. The screen turns on when you touch it, and will auto-off after 5 min of not beeing used. The system boots with autostart on chromium in kiosk mode. I edited `/etc/xdg/lxsession/LXDE-pi/autostart` for this.

I added: `/usr/bin/chromium-browser --kiosk --disable-restore-session-state --disable-component-update http://HASSIP:8123/DASHBOARD-NAME/default_view?hide_sidebar=` as script. I installed via HACS the kiosk card, which helps hiding the sidebar which i dont want to visualize.

<p align="center">
  <img src="https://i.imgur.com/XDkNqdP.jpeg" />
  <img src="https://i.imgur.com/b6DuBSm.png" />
</p> 

I use also the 3d version of my home, created based on https://aarongodfrey.dev/home%20automation/creating-a-3d-floorplan-in-home-assistant/ as an interactive panel on the homescreen. 

<p align="center">
  <img src="https://i.imgur.com/VnICZaC.png" />
</p>

Next to the sensors which are displayed in the 3d image of each floor - i made a specific item with conditions which displays also the live location (last known) based on the ML model (see frigate)... on where i or my wife is last ' seen '. An example you can see below:

<p align="center">
  <img src="https://i.imgur.com/LfwS9D0.png" />
</p>

For this i used the conditional element of https://www.home-assistant.io/lovelace/picture-elements/#conditional-element to put in a picture in place of the location (so i defined a set of me and my wife for every room where detection is possible, 5 in my case). 


### HA Integrations enabled

- Amazon Alexa
- Android TV Notifications
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
- Nightly the HASS and frigate/AI-ML setup is backupped and transferred 1 locally to the drive 2 copied to the NAS 3 synced with a cloud storage provider. (using   the 3 2 1 method for backups)

### Frigate / Synology surveillance tracking

- Using Frigate NVR with the Coral USB to actively track the people in my house. its now trained with myself and my wife with Compreface

### Light automations

- In toilet / storage and attic, office, lights turn on/off based on motion sensor, re-triggered / reset of the timer in case of continued presence.
- In the hallway / kitchen / dining and living lights turn on/off based on motion sensor, but included with mood scenes to dim after no presence is detected       anymore. In this way creating a mood-effect, eg dimmed lights to provide a cozy atmosphere.
- Automated lights with sensors including day/night routines, mood scenes after sunset and vacation lights when the alarm is armed.

### Office / streaming 

I regularly record videos for LinkedIn and using this setup also in my video calls with customers... so i automated a few things.

- When the camera (sony a5100 via camlink 4k on USB) of my macbook is ' on ', it triggers the automation to turn on the studio lights (elgato key lights)
- When i activate via my streamdeck the 'presenter mode' it:
  - Dims the light, turns on the elgato key lights, changes the colouring on the hue bulbs, closes the window blinds and overrides the sensor/motion flows which     normally turn off lights.
- Piano mode: when i activate the piano mode via streamdeck, hass, or voice: the piano (yamaha cp4 with power socket) will turn on, a WoL packet to the 2nd         laptop is sent, and a script is executed on the laptop to start my DAW software.


## House status

### Notification system automations

I wanted to maximize the way the house is reponsive in voice and notifications as well. so i linked telegram and alexa tts to specific events or information i want to know. The family can then ask to the house via the [wakeword]alexa " whats the house status "  for example which is returned via TTS and flows who get the actual sensor state values.

- House status: responds the amount of current power consumption (in watts, the remaining runtimes on the UPS batteries in the serverrack and hallway. Also         reports the current central heating pressure in the system (in bar).
- Open Windows: responds / checks which windows are open and responds which are open and need to be closed
- Goodmorning: responds " good morning " (duh), puts on the lights, but also mentions if the last nights backup has failed and hasnt uploaded.
- Good night: responds nothing - but - when the car is not closed it will ' whisper ' the message thru the speaker i asked / mentioned goodnight to.
- Where is who?: based on the frigate information, i can ask " where is Peter-Paul "  which then voices back the last know home location, or, if im away or my     wife is not at home, i will lookup the external location and mention this.
- Zwave dead node check: every day at 1200, the system will check if a zwave node has the 'dead' status. HASS will notify me via telegram if this is the case and   which node is dead (and i have to check).
- Kitchen check: sometimes it can happen the frigirator door is left open, after 2 minutes, it will mention this via a generic announce on alexa that the fridge   is indeed open and needs to be closed. (you all know - sometimes in a rush - we forget)
- Garden: we hate cats in the garden whom are keeping  birds / wildlife away, so the camera / Frigate checks if theres a cat in the garden and mentions this as     well via TTS so we can sprint to the garden and chase it away.

  To show you this works - a screenshot from Frigate which detected the cat and is sent to HA.
  
  <p align="center">
  <img src="https://i.imgur.com/ZAA0E1W.png" />
  </p> 

- Travel time: by integrating google maps, i can also ask the house how many minutes i need to get to the office, both for myseld and the missus.
- Door trigger: when the doorbell is pressed it makes a picture and sents it to telegram and mentions there is somebody at the door via Alexa TTS
- Door welcome message: when im returning from work or left for a longer time from the house, based on frigate and some other factors it determines if im in the   hallway (sequence / cam detection / door opening / no wifi on phone) to send me via Alexa TTS a ' welcome back ' message to the hallway Amazon speaker.
- Alarm system: when the alarm is armed, the system will report any movement based on frigate/motion sensors/door sensors/sound and some other thingie, to         telegram / sms and creates photos in the process. This flow i wont share ...
- Washing machine + dryer: the Node-red flows monitor the energy usage and when the value stays below a certain amount of time, the system will notice the         washing machine or dryer is not in cycle mode anymore, and will report this accordingly.
- Battery check: every day at 1200, the system will check the battery of the sensors in the house and will mention if a sensor is below 15% via a message on       telegram.
  
  Example of the laundry equipment and the empty batteries. (in this case a zwave radiator).

  <p align="center">
  <img src="https://i.imgur.com/RvWMoKn.png" />
  </p>

- Smoke detection: multiple smoke detectors placed around the house which report via SMS / Telegram with photo and the HASS app if there is an emergency.
- With Opentherm Gateway and sensors, the house notifies me when the pressure of the heating system is getting low, and/or, issues with the boiler flame, other     faults are detected.
- Morning alarm/wake up light link: you can use the integrated sensor of your phone (next_alarm) as an entity in an automation. Philips has nice wakeup lights     but if you want this effect/routine with a different styled lamp then you have to program it yourself. Have build a node-red flow which checks / turns on a       wakeuplight routine for me and my wife based on the alarm setting on our (android phones).
- Flood sensor: when flooding is detected in the storage room - HA will sent a telegram warning message and announce via the Alexa speakers there is water         detected.
- Particle density: you can ask Alexa to tell you the current PM2.5 and PM10 particle density in the house in micrograms per qubic meter (air).
- BMW fuel remaining: you can ask Alexa how much fuel (liters) is remaning and the approximate range (km's) which you can drive with this.

ALso i used the Alexa skill " home guide " with which you can built a homeguide skill specific for you home to guide you to specific items, or how to do stuff. F

For example, you can ask Alexa the location of the following items (list limited - expanding as i go along)

- Batteries, wine glasses, cutlery, plates, herbs, paint, tape, toilet paper, tea, coffee, candles, soup, medicines, etc.

On the ' how to do what ' side, i created input for, how to do:

- Turn on / off the lights, oven, furance, use the thermostat, view the tV, view the cameras, hot water tap, the shower, etc.

## Other automations

- Central heating: when the windows in the office or master bedroom are open, the radiator valve is automatically closed. Done via a workaround to set the         radiator at a very low temperature level. (14 degrees celcius)
- Kodi integration with Philips Hue + Philips Ambilight - when a movie is started - HASS switches Ambilight + Hue on so we have ambient lighting during the         movie.

## Todo / building / iterating

- Garden irrigation / anti-cat: on the roadmap is the refurbishment of the front and back garden, the latter including a sprinkler system, which will water the     plants and grass and acts also as a friendly 'chase the cats' away routine. If cat==detected, then turn on sprinkler system. :-)
- Out of bed lights: i have no lights / step out lights under the bed at the moment, probably this will be built in the near future.
- Grocy / Groceries inventory management: already had grocy running / integrated but no good sensor/hardware use case found to test inventory management yet. WIP   untill i find something to monitor.
- Alexa actionable notifications - https://github.com/keatontaylor/alexa-actions/wiki

## Community ideas?

Do you have ideas which i didnt have thought about ? Perhaps you can suggest them so i can build them as well.
