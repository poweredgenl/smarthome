# Peter-Paul's smarthome project

## Intro

This repository contains all information and scripts (as much as possible) on my smarthome projects. As im working with Red Hat, i want to honor the open source way of working to share my automations and setup. Things i wont share are specifics around the alarm system and security setup.

## Platform overview

For my smarthome setup i use the follow components.

### Basics

- Home Assistant
- Z-zwave via AEOTEC gen5 stick
- Zigbee via/with Philips Hue bridge
- Wifi / MQTT modules

### Hardware platform

There are multiple options for running the above components, commonly a Raspberry PI or equivalent platform is used but im running already a virtualized platform with other servers.

- 2x Dell PowerEdge R320 (Xeon E5-2420, 64GiB Ram)
- Synology DS920+ (4x 3TiB)
- HPE/Aruba series switches (2530-24G-POE+, 2530-8G-POE+, etc)

