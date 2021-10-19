# Peter-Paul's smarthome project

## Intro

This repository contains all information and scripts (as much as possible) on my smarthome projects. As im working with Red Hat, i want to honor the open source way of working to share my automations and setup. Things i wont share are specifics around the alarm system and security setup.

## Platform overview

For my smarthome setup i use the follow components.

### Basics

- Home Assistant Supervised on Debian (yes i know ... not Red Hat ... yet)
- Z-zwave via AEOTEC gen5 stick
- Zigbee via/with Philips Hue bridge
- Wifi / MQTT modules
- Node-RED for automation flows

### Hardware platform

There are multiple options for running the above components, commonly a Raspberry PI or equivalent platform is used but im running already a virtualized platform with other servers.

- 2x Dell PowerEdge R320 (Xeon E5-2420, 64GiB Ram)
- Synology DS920+ (4x 3TiB)
- HPE/Aruba series switches (2530-24G-POE+, 2530-8G-POE+, etc)
- Vivotek / Foscam POE cameras.

### Integrations in Home-Assistant enabled

- Amazon Alexa
- Auto backup
- BMW Connected drive
- Broadink
- Buienradar (weather forecast the Netherlands)
- CO2 Signal
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

## Automations

All automations below are the ones i have implemented in my home. Those not related to security are uploaded as well.

- Automated lights with sensors including day/night routines, mood scenes after sunset and vacation lights when the alarm is armed.
- Realtime person tracking via Frigate NVR and Doubletake (check out https://github.com/jakowenko/double-take)

