# Digital-Twin H17 Smarthome /  project

## Intro

This repository contains all information and scripts (as much as possible) on my smarthome projects. As im working with Red Hat, i want to honor the open source way of working to share my automations and setup. Things i wont share are specifics around the alarm system and security setup.

H17 refers to the street and housename ... so theres the history in that. The inspiration for many things started with seeing the Marvel Iron Man movies, the house of Tony stark. Although I don't have such a lofty mansion, many things i implemented like his. (Voice, machine learning, automations, proactive  notifocations etc) .

If you like the guide and information 

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/Peterpaul "Buy Me A Coffee")

If you have suggestions - make an item / issue or pull request perhaps i can implement it!

### Table of contents

- [Platform overview](#overview)
  - [The basics](#basics)
  - [Hardware](#hardware)
    - [Servers](#servers)
    - [Monitoring](#monitoring)
- [Home Assistant](#hass)
  - [Dashboard](#dashboard)
  - [HA integrations](#integrations)
  - [Automations](#automations)
    - [Overview](#genericautomations)
    - [Realtime presence tracking](#videotracking)
    - [Lights](#lightautomations)
    - [Green IT / Energy efficiency](#green)
    - [Office & streaming](#officeautomations)
    - [BGP / Network fun](#bgp)
    - [Other automations](#otherautomations)
    - [Specific implementations](#specific)
  - [House status](#housestatus)
    - [Notification system](#notifications)
  - [Backlog / Work in progress](#wip)
- [Your ideas?](#ideas)

## Platform overview <a name="overview"/>

I have a generic virtualization platform which runs 4 regular vms and 2 docker host-vms, container total of +/- 45 containers.

- Functions: Firewall ([pfSense](https://www.pfsense.org/)), domain controllers (users/auth/windows based systems), monitoring ([LibreNMS](https://www.librenms.org/)), steppingstone, backup server ([Veeam Community Edition](https://www.veeam.com/virtual-machine-backup-solution-free.html)), a Greenbone/OpenVAS server for regular scanning and Raspberry pi's for smaller tasks. 

Total number of devices/sensors/automations/items/boleans/node red blocks in my smart home (dd - 27-07-2022) over 1600 entities.

### The basics <a name="basics"/>

HASS virtual machine
- Home Assistant Supervised
- Z-zwave2mqtt + AEOTEC gen5 stick (+/- 60 devices)
  - Qubino in wall dimmers & relays 
  - ECOdim cord dimmers for regular lamps
  - Aeotec / Neo coolcam plugs (aeotec for measuring appliances, neo for dumb switching)
  - Eurotronic radiators 
  - Neo Coolcam motion sensors
  - Heiman smoke detectors
- Zigbee2mqtt + Sonoff Zigbee Plus 3.0 zdongle-e
  - Philips hue lights / various white/ambiance/color/e14/e27/gu10 (+/- 25 devices)
  - Philips motions sensors 
  - Zemismart Zigbeee curtain blinds x3
- Wifi / MQTT modules
  - Shelly 2.5 (4x, for sunshades on the front + garden, blinds at the kitchen, and one for the garden shed)
  - Shelly Dimmer (2x for the Garden shed spots and the rear alley spots)
  - NodeMCU (2x)
- Node-RED for automation flows
- RFX 433Mhz transmitter (1x doorbell / 1x Somfy RTS blinds upstairs)
- NFC tags for various stuff

Docker  host for specific tasks
- [Portainer](https://portainer.io) for management of container stacks, with - see file, a bash script for stopping stacks.
- [Compreface](https://github.com/exadel-inc/CompreFace) - Video image processing with ML for realtime person tracking
- [Unifi Network application](https://hub.docker.com/r/linuxserver/unifi-controller)  Managing the AP's and device trackers.
- [DSMR Reader]([https://portainer.i](https://github.com/dsmrreader/dsmr-reader)o) for the P1 monitor (with serial over ethernet config).
- [Double Take]( https://github.com/jakowenko/double-take) - intermediate software which bridges between Frigate and Compreface
- [LibreNMS](#monitoring) - Monitoring the whole network - see further this README for an impression.
- Smokeping - in conjunction with LibreNMS monitoring ping times to various entities as well as the WAN feeds for their quality.


Synology DS920+
- Basic storage for media, virtual machines etc
- Hub for cameras
- [Frigate NVR](https://github.com/blakeblackshear/frigate) - (due to not having h264 GPU offloading on ESXi)


### Hardware <a name="hardware"/>

There are multiple options for running the above components, commonly a Raspberry PI or equivalent platform is used but im running already a virtualized platform with other components.

<p align="center">
  <img src="https://i.imgur.com/3Bg6Wes.jpeg" width="550" />  
</p>

- 2x Dell  Poweredge R640 (Dual Xeon Gold 6152, 576GiB Ram)
- ~~2x Dell PowerEdge R320 (Xeon E5-2470v2, 96GiB Ram)~~ 
- Synology DS920+ (4x 3TiB) + 2x 1TB WD Red NVME r/w cache.
- Core switch: Juniper Ex4300-48MP (24x1G, 24x10G, POE++)
- Edge switches: HPE/Aruba series switches (2530-8G-POE+, 1820-8g-POE+, 1810-8g-POE)
- 3x UniFi 6 Lite
- 1x Unifi 6 Professional
- 1x Unifi FLex (5 ports, POE in/POE passthru)
- 4x Vivotek POE cameras
- 2x Foscam cameras 
- 2x Hikvision 4MP cameras for outdoor
- 1x Google Coral TPU (on Synology)
- 3x UPS
  - Smart-UPS SRT 2200 + 2x SRT72RMBP (runtime severrack approx 3 hours)
  - Back-UPS 700Va for electricity closet
  - Back-UPS 1400Va for my office
- 3x Raspberry PI 4b + POE HAT for:
  - Homescreen
  - Storage monitoring station
  - Backup server / location.
- 2x 23" Industrial touchscreen (for Homescreen and monitoring station)
- 1x Raspberry PI Zero W with USB/Ehternet hub.
  - P1 cable / DSMR reader
- Redundant WAN - fiber 1000/1000mbit - 4G backup via Mikrotik router + Huawei stick.
- Secured tunnels toward my DFZ router - AS200132 - 195.95.177.0/24
- 4x ESP32 dev boards for room tracking. See [videotracking](#videotracking).
- 2x NodeMCU v2 with SDS011 particle sensor (sensor.community)

Other Stuff
- 18x Hyundai Solar panels - 430wp - Enphase IQ8M inverters - Envoy IQ Metered S - 3 phase installation
- Alfen Single Pro Line S charger - 32A - Loadbalancing - no backoffice
- BMW 330E Touring - https://www.instagram.com/g21technoviolett/
- EVCC balancer due to no proper DSMR protocol at the smartmeter of the house

#### Server & network equipement <a name="servers"/>

Small overview of the main equipment running the house. Rack consumes approx 175 watt 24/7 (which i think is quite reasonable).

Watch the video overview (click pictures):

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=TL6aasnU-vE" target="_blank">
 <img src="https://tweakers.net/fotoalbum/image/Wor6g2PCcLclY3C8jcnG6QT3.jpg" alt="Watch the video" width="500" />
</a>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=LbIXTtZXNjQ" target="_blank">
 <img src="https://i.imgur.com/LfOuYI2.jpeg" alt="Watch the video" width="500"  />
</a>
</p>


#### Librenms monitoring <a name="monitoring"/>


<p align="center">
  <img src="https://i.imgur.com/qlkoKLm.png" />  
</p>


## Home Assistant <a name="hass"/>

### Dashboard <a name="dashboard"/>


To have a proper overview of the house, and to control everything i have wall mounted touchscreen, with cables running in the walls, and a RPI which is located in a secret compartiment. The screen turns on when you touch it, and will auto-off after 5 min of not beeing used. The system boots with autostart on chromium in kiosk mode. I edited `/etc/xdg/lxsession/LXDE-pi/autostart` for this.

I added: `/usr/bin/chromium-browser --kiosk --disable-restore-session-state --disable-component-update http://HASSIP:8123/DASHBOARD-NAME/default_view?hide_sidebar=` as script. I installed via HACS the kiosk card, which helps hiding the sidebar which i dont want to visualize.

<p align="center">
  <img src="https://i.imgur.com/Nt3B9lf.jpg" />
  <img src="https://i.imgur.com/pU9iKJt.png" />
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

#### Cards used

- Picture elements, entities, custom neerslag, buienradar, horizontal and vertical stacks, pictures, customer thermonstat/dark thermostat

### HA Integrations enabled <a name="integrations"/>

- Alfen Wallbox
- Amazon Alexa
- Android TV Notifications
- Auto backup 
- BMW Connected drive
- Broadink
- Buienradar (weather forecast the Netherlands)
- Browser mod
- CO2 Signal
- DSMR reader
- Dell IDRAC integration
- Elgato Key lights
- ESXI stats / VMware vCenter integration - see [Green IT / Energy efficiency](#green) 
- ESPHome
- Enphase Envoy - HACS integration
- EVCC addon / HASSIO
- EVCC integration (interface)
- Frigate NVR (on Synology) - guides: https://github.com/blakeblackshear/frigate 
- Google Maps travel
- HACS (Home Assistant community store)
- Siemens Home Connect
- Sensor.community (Luftdaten)
- MQTT
- Mac Home Assistant companion - to integrate my macbook sensors in HA to do cool automations
- Google Nest
- Google Cast
- Google Travel Time
- Kodi (on Nvidia Shield TV 2017)
- Network UPS tools
- Node-red
- Opentherm Gateway with NodeMCU: https://github.com/rvdbreemen/OTGW-firmware
- Our Groceries (tracking)
- Philips Hue + Innr sockets
- Philips Android TV 
- RFXcom 433mhz
- Resmed MyAir - medical sleep apnea device 
- Shelly
- Spotify
- Synology
- Transmission BT (on Synology)
- pfSense UPNP
- Rainbird
- Unifi Network Application/controller
- Z-Wave JS with Z-wave JS to MQTT (for control panel)
- Zigbee2MQTT
- Telegram notification service
- Tasmoto
- Tuya local
- Xiaomi integration (for Roborock S7 vacuumrobot)

### Automations <a name="automations"/>

#### Overview  <a name="genericautomations"/>

Below are the ones i have implemented in my home. Those not related to security are uploaded as well.

- Home build wake up lights - Philips style - with zwave cord dimmers and the HASS "next_alarm" sensor.
- Bathroom fan - when humidity is above a certain level.
- Alarm system with sensors
- Power monitoring everything / plugs / dimmers etc.
   - DSMR is reading the central p1 power monitor and gathers this in the HASS energy dashboard.
- The upstairs thermostats are joined in a climate group so i can control them as a whole floor. (eurotronic spirit zwave)
- Nightly the HASS and frigate/AI-ML setup is backupped and transferred 1 locally to the drive 2 copied to the NAS 3 synced with a cloud storage provider. (using   the 3 2 1 method for backups)
- Vacuum robot cleaning the house and automations for auto empty the dock/bins.

#### Realtime presence tracking<a name="videotracking"/>

I thought it would be cool to track people around the house, without recording, to see where which person is.

- Using Frigate NVR with the Coral USB to actively track the people in my house. its now trained with myself and my wife with Compreface. (check out https://github.com/jakowenko/double-take).
- Using ESPresence (https://espresense.com/) to track BLE devices.

As i use multiple trackers / BLE / video / the HA companion apps - i want to merge the trackers to give me 1 overview sensor in HA which shows the last updated sensor. I use the following code for this:

```
 - platform: template
   sensors:
     recent_location_pp:
       friendly_name: 'Recent location PP'
       value_template: >-
         {% set x =  [ states.sensor.XX,
                       states.person.XX,
                       states.sensor.XX-BLE ]
               | sort(reverse=true, attribute='last_changed')
               | list %}
         {% if x | count > 0 %}
           {{ x[0].state }}
         {% else %}
           {{ states('sensor.recent_location_pp') }}
         {% endif %}
       entity_picture_template: /local/XX.jpeg
```

#### Light automations <a name="lightautomations"/>

- In toilet / storage and attic, office, lights turn on/off based on motion sensor, re-triggered / reset of the timer in case of continued presence.
- Wake up lights: using ECOdim cord dimmers (which i plugged in to replace regular light switches on floorlamps) built 2 wake up lights for the bedroom     to replace traditional Philips wake up lights which are less fancy. Using the android HA companion app to passthru the alarm clock variable. Used         https://www.wouterbulten.nl/blog/tech/custom-wake-up-light-with-node-red/ as guid which worked excellent!
- Automated lights with sensors including day/night routines, mood scenes after sunset and vacation lights when the alarm is armed.
- In the hallway / kitchen / dining and living lights turn on/off based on motion sensor, but included with mood scenes to dim after no presence is detected       anymore. In this way creating a mood-effect, eg dimmed lights to provide a cozy atmosphere. This is also activated when the lights are off, and no motion is     detected at sunset. If all those cases are met - the mood lights are activated automatically.

  An example node-red flow looks like this (code in repo):
  
  <p align="center">
  <img src="https://i.imgur.com/mliOoes.png" />
  </p>
  
#### Energy / Green IT / Sustanability <a name="green"/>
 
For maximum energy savings i have implemented next to automatic light switching the following options. More options tb implemented, see for this the backlog on the issues page.

- Automatic start / shutdown of the Raspberry PI's controlling, 1 the home screen 2 the backup storage. Using SSH in Node Red for shutdown and via an SSH -> SNMPSET command to power off the POE port of the resptive switch. See:  https://github.com/poweredgenl/smarthome/issues/11

<p align="center">
  <img src="https://i.imgur.com/pr2LWBI.png" />
  </p>
  
- Using the same setup with SNMP commands - also switching off the backuprouter (4G LTE) during the night via POE, i dont need those, so only online when needed.

- Phase information / energy loadbalancing workaround.
  In my house i got only an older DSMR reader which doesnt supply phase information. My car charger / Alfen Single Proline S needs this info to do proper load balancing with 3 phases.
  The solution i have chosen to still get phase information to the car charger is the following:

  Enphase -> Home Assistant -> expose P1/2/3 sensor information -> use http / get / json / rest with an Home Assistant API token -> EVCC polls home assistant for proper phase information -> EVCC exports data via modbus towards the Alfen charger. VOILA! 

<p align="center">
  <img src=https://i.imgur.com/92elSRY.png" />
  </p>

  I also modified the phase3 information synthetically. As the fuse box is split, the p3 load is shared between the car and the washing machine. Due to the fact the washing machine is on the same phases in the storage room, i instruct home assistant to artifically add some Amps to the phase to it wont overload the system.

I use the follwing code in configuration.yaml for this:

```
template:
  - sensor:
      - name: "enphase dryer L3 current sum"
        unit_of_measurement: "A"  # Replace with the appropriate unit, e.g., "kWh" or "°C"
        state: >
            {% set enphasep3 = states('sensor.envoy_consumption_current_l3') | float(0) %}
            {% set dryercur = states('sensor.dryer_electric_consumption_a') | float(0) %}
            {% set dryer_cycle = is_state('input_boolean.dryer_cycle', 'on') %}
            {% if dryercur == 'unavailable' or (dryercur | float(0) > 0.5) or dryer_cycle %}
             {{ enphasep3 + 9 }}
            {% else %}
              {{ enphasep3 }}
            {% endif %}
 ``` 

- For saving power during the night as well im stopping unessacary docker-compose/podman/portainer stacks. I use the script attached in this repo: https://github.com/poweredgenl/smarthome/tree/main/portainer_control to control specific stacks which consume a lot of CPU and memory, and thus, energy.

- Via the ESXI stats integration im controlling the power of multiple virtual machines as well. See https://community.home-assistant.io/t/custom-component-esxi-stats/131617. Because I switch off VM's, I can reduce the load on the ESX servers and keep 1 poweredoff/in    standby during fewer usage. This will save energy.

  The following systems are fully automated:
  - Backup servers: both the VEEAM environment (VM) and the backup store (raspberry pi + external drive) are only started when the backup schedule approaches.
  - OpenVas/GVM: I regular scan my whole IT environment for CVE/NVT's but this server is only needed at 2 moments, the update of the NVT's during the night and the actual scheduled scans (weekly/monthly)...during those other hours, the systems are off. 
  

#### Office / streaming <a name="officeautomations"/>

I regularly record videos for LinkedIn and using this setup also in my video calls with customers... so i automated a few things.

- **Auto studio lights**:When the camera (sony a5100 via camlink 4k on USB) of my macbook is ' on ', it triggers the automation to turn on the studio lights (elgato key lights)
- **Presenter mode**: When i activate via my streamdeck the 'presenter mode' it:
  - Dims the light, turns on the elgato key lights, changes the colouring on the hue bulbs, closes the window blinds and overrides the sensor/motion flows which     normally turn off lights.
- **Piano mode**: when i activate the piano mode via streamdeck, hass, or voice: the piano (yamaha cp4 with power socket) will turn on, a WoL packet to the 2nd         laptop is sent, and a script is executed on the laptop to start my DAW software.

#### BGP network fun <a name="bgp"/>

Im lucky to have both an ASN and a PI space, and i thought it would be cool to link my DFZ router to Home Assistant. The use cases i had/have in mind are:

- Alexa can mention number of: peers, transits, and full route table.
- HA can trigger routing actions in the bgp software, Bird 1.6.

For more info on my network setup, AS200132, check out https://github.com/poweredgenl/networkstuff/

The automation i now have built are based on ssh/pubkey login where a node red script triggers an SSH command. Specifically i used the following ones:

Routes:
```
sudo ip r | wc -l
```
Peers
```
sudo birdcl s p | grep Established | grep peer |  wc -l
```
Transits
```
sudo birdcl s p | grep Established | grep transit |  wc -l
```

The node-red flow then looks as follow:

<img src="https://i.imgur.com/PfjaNYW.png" width=60% height=60%>

As the SSH commands return an enter value as well in the payload, i trimmed the output so that the data can be used in an another msg.payload, and can also be injected into a sensor directly accessible by HA to show on the dashboards.

```
msg.nikhef1routes_sensor = msg.payload.slice(0, -1);
return msg
```

See the youtube https://www.youtube.com/shorts/vD8oDn_aoOE for a DEMO

#### Other automations <a name="otherautomations"/>

- **Central heating**: when the windows in the office or master bedroom are open, the radiator valve is automatically closed. Done via a workaround to set the         radiator at a very low temperature level. (14 degrees celcius)
- **Kodi integration with Philips Hue + Philips Ambilight** - when a movie is started - HASS switches Ambilight + Hue on so we have ambient lighting during the         movie.
- **Fireplace**: we dont have regular fireplace but youtube is your friend. In combination with `media_extractor` https://www.home-       assistant.io/integrations/media_extractor/ and node-red, i created a flow which turns on the TV, and pushes the youtube link with the 4k Fireplace video.
- **Kitchen stove fan + Alexa volume**: when the stove ventilation is one, based on power usage above 41 watss (i know - above 41 watss -> the ventilation is one)... HA will increase the volume of the Alexa speaker, and lowers it to the default when the fan is off.

#### Specific implementations <a name="specific"/>

- **RFXcom433 with Somfy RTS**:
  I had to do some fiddeling with the RXcom to get my Somfy RTS blinds working (telis 1 remote). For this i used a number of sites but in general the approach is   this:
  
  - Step 1: link your telis 1 remote to your RFXcom433 receiver. I did this on a windows machine with rfxmgr from http://www.rfxcom.com/downloads.htm
  - Step 2: When programmed - i took note of the " id " via rfxmgr and used it to MANUALLY! add it via "integrations -> RFXtrx > enter event code to add" ... ive taken the ID from         this website: https://community.home-assistant.io/t/problem-controlling-somfy-blinds-via-rfxtrx/61975. so for example `071a000001010101` ...replace the last     010101 with the ID which your programmed it with via RFXmgr.
 
 - **Sensor.community**: im using a air quality sensor from Sensor.community (eg Nova SDS011), but i want to have the output of the sensor information in my HA dashboard more readable. For this i added the following code to `configuration.yaml`.

```
 - platform: template
   sensors:
     air_quality_pm10:
       friendly_name: 'Air quality PM10'
       value_template: >-
         {%if states.sensor.pm10_stats.state | float<=25 %}
           Excellent
         {% elif states.sensor.pm10_stats.state | float<=50 | float>25 %}
           Good
         {% elif states.sensor.pm10_stats.state | float<=90 | float>25 %}
           Fair
         {% elif states.sensor.pm10_stats.state | float<=180 | float>90 %}
           Moderate
         {% elif states.sensor.pm10_stats.state | float>180 %}
           Poor
         {%- endif %}
 - platform: template
   sensors:
     air_quality_pm25:
       friendly_name: 'Air quality PM2.5'
       value_template: >-
         {%if states.sensor.pm25_stats.state | float<=15 %}
           Excellent
         {% elif states.sensor.pm25_stats.state | float<=30 | float>15 %}
           Good
         {% elif states.sensor.pm25_stats.state | float<=55 | float>30 %}
           Fair
         {% elif states.sensor.pm25_stats.state | float<=110 | float>55 %}
           Moderate
         {% elif states.sensor.pm25_stats.state | float>110 %}
           Poor
         {%- endif %}
```
- **Convert kwh to Watt**. My dsmr reader mentions the power usage in Kwh, for easy viewing i let HA convert this to Watts with the following code in `configuration.yaml`.

```
- platform: template
   sensors:
        power_consumption_w:
          friendly_name: 'Current power usage watt'
          unit_of_measurement: 'W'  
          value_template: "{{(states('sensor.dsmr_reading_electricity_currently_delivered') | float * 1000) | int }}"
```

### House status <a name="housestatus"/>

I wanted to maximize the way the house is reponsive in voice and notifications as well. so i linked telegram and alexa tts to specific events or information i want to know. The family can then ask to the house via the [wakeword]alexa " whats the house status "  for example which is returned via TTS and flows who get the actual sensor state values.

#### Notification system <a name="notifications"/>

Based on booleans i made some automations with respond via Alexa TTS on my request. I use a generic flow/shared service (TTS in, Telegram in, Telegram Photo in) to re-use functionality

  <p align="center">
  <img src="https://i.imgur.com/MpoG4hi.png" width=60% height=60%>
  </p>
  
- **Garbage helper**: at 19:15 every evening , HA checks which garbage needs to be taken out and sents a push message to notify which garbage needs to be taken out. 

- **Price plateau/limit for energy costs** in the Netherlands there is a cap on 2900Kwh and 1200m3 gas usage with maximum prices. HA gives me a notification when my quote / reduced pricing spend is above 50% (for electricity and gas).

- **House status**: responds the amount of current power consumption (in watts, the remaining runtimes on the UPS batteries in the serverrack and hallway. Also         reports the current central heating pressure in the system (in bar).
- **Open Windows**: responds / checks which windows are open and responds which are open and need to be closed
- **Goodmorning**: responds " good morning " (duh), puts on the lights, but also mentions if the last nights backup has failed and hasnt uploaded.
- **Good night**: responds nothing - but - when the car is not closed it will ' whisper ' the message thru the speaker i asked / mentioned goodnight to.
- **Where is who?**: based on the frigate information, i can ask " where is Peter-Paul "  which then voices back the last know home location, or, if im away or     my wife is not at home, i will lookup the external location and mention this.
- **Zwave dead node check**: every day at 1200, the system will check if a zwave node has the 'dead' status. HASS will notify me via telegram if this is the case   and which node is dead (and i have to check).

  <p align="center">
  <img src="https://i.imgur.com/wH5mT0N.png" />
  </p> 
  

- **Kitchen check**: sometimes it can happen the frigirator door is left open, after 2 minutes, it will mention this via a generic announce on alexa that the       fridge is indeed open and needs to be closed. (you all know - sometimes in a rush - we forget)
- **Garden**: we hate cats in the garden whom are keeping  birds / wildlife away, so the camera / Frigate checks if theres a cat in the garden and mentions this   as well via TTS so we can sprint to the garden and chase it away.

  To show you this works - a screenshot from Frigate which detected the cat and is sent to HA.
  
  <p align="center">
  <img src="https://i.imgur.com/ZAA0E1W.png" width=40% height=40%>
  </p> 

- **Travel time**: by integrating google maps, i can also ask the house how many minutes i need to get to the office, both for myseld and the missus.
- **Door trigger**: when the doorbell is pressed it makes a picture and sents it to telegram and mentions there is somebody at the door via Alexa TTS. Also - incombination with browser_mod and a script on the raspberry pi it:

  - 1 Initiates a popup on the homescreen (monitor) with the door-camera. 
  ```
  alias: Camera popup frontdoor
  description: ""
  trigger: []
  condition: []
  action:
  - service: browser_mod.popup
    data:
      dismissable: true
      autoclose: false
      title: Test
      size: wide
      timeout: 25000
      deviceID:
        - homescreen
      content:
        camera_view: live
        type: picture-glance
        entities: []
        camera_image: camera.nelnlfs001_cam01_door
  mode: single
  
  ```
  
  - 2 As the monitor is normally in sleep - it uses DPMS to force/trigger a wake-up from sleep. I use a SSH function in node-red for this with the    following command to be executed on the raspberry pi running the homescreen.
  ```
  export DISPLAY=:0 && /usr/bin/xset dpms force on
  ```

- **Door welcome message**: when im returning from work or left for a longer time from the house, based on frigate and some other factors it determines if im in   the hallway (sequence / cam detection / door opening / no wifi on phone) to send me via Alexa TTS a ' welcome back ' message to the hallway Amazon speaker.
- **Alarm system**: when the alarm is armed, the system will report any movement based on frigate/motion sensors/door sensors/sound and some other thingie, to     telegram / sms and creates photos in the process. This flow i wont share ...
- **Washing machine + dryer + dishwasher**: the Node-red flows monitor the energy usage and when the value stays below a certain amount of time, the system will   notice the washing machine / dryer & dishwasher is not in cycle mode anymore, and will report this accordingly.
- **Battery check**: every day at 1200, the system will check the battery of the sensors in the house and will mention if a sensor is below 15% via a message on   telegram.
  
  Example of the laundry equipment and the empty batteries. (in this case a zwave radiator).

  <p align="center">
  <img src="https://i.imgur.com/RvWMoKn.png" width=60% height=60%>
  </p>
  

- **Torrents finished**: when the downloads in transmission are done the system sends a telegram and whisper to the Alexa system as notification. "Hello, your downloads are ready".
- **Smoke detection**: multiple smoke detectors placed around the house which report via SMS / Telegram with photo and the HASS app if there is an emergency.
- **Opentherm Gateway and sensors**: the house notifies me when the pressure of the heating system is getting low, and/or, issues with the boiler flame, other     faults are detected.
- **Morning alarm/wake up light link**: you can use the integrated sensor of your phone (`next_alarm`) as an entity in an automation. Philips has nice wakeup         lights but if you want this effect/routine with a different styled lamp then you have to program it yourself. Have build a node-red flow which checks / turns     on a wakeuplight routine for me and my wife based on the alarm setting on our (android phones).
- **Flood sensor**: when flooding is detected in the storage room - HA will sent a telegram warning message and announce via the Alexa speakers there is water     detected.
- **Resmed apnea data**: If the data of the Resmed apnea device is uploaded, i can Ask alexa how well did i slept, incl the number of breathing stops per hour it   detected last cycle. I implemented for this the guide / code from https://github.com/prestomation/resmed_myair_sensors/

  <p align="center">
  <img src="https://i.imgur.com/0rnOZ5i.png">
  </p>
  
  It checks also if the data is current / and if not the message/TTS is different.
  
  No data:
  ```
  msg.payload = 
 
  "Hi Peter-Paul, i dont have actual information at this moment."

  return msg
  ```
  
  If there is information:
  ```
  msg.payload = 

  "Hi Peter-Paul. Last night you had: {{states.sensor.cpap_ahi_events_per_hour_2.state}} breathing stops per hour,"+ 

  "And you used the CPAP device for: {{states.sensor.cpap_usage_time_2.state}} hours "

  return msg
  ```
  
  Some example data and a picture so that people have an impression what the device is.
  
  <p align="center">
  <img src="https://i.imgur.com/yQeSDJs.png" width=40% height=40%>
  <img src="https://www.viviwebshop.be/shops/vivishop/37245-resmed-airsense-10-autoset-2.jpg" width=40% height=40%>
  </p>
  
-  This script is also used in my **Start my workday** routine. Alexa responds with a confirmation (after " alexa start my workday "), turns on the soundsystem      (i use a separate one with micro / speakers etc), reports the weather, and tells me the sleeping data how well i slept.
  
    
- **Electric bike charging done?**: using a power socket - monitoring how much energy it consumes - i know based on amount of W consumed per hour - when the       battery of the bicycle is full. HA will then via TTS announce that the bicycle battery is ready.
- **Particle density**: you can ask Alexa to tell you the current PM2.5 and PM10 particle density in the house in micrograms per qubic meter (air). Currently implemented for the downstairs sensors.
- **BMW fuel remaining**: you can ask Alexa how much fuel (liters) is remaning and the approximate range (km's) which you can drive with this.
- **BMW horn honk**: yes dont ask, i added a routine (when the car is home), to ask alexa to press the horn. Something fun to do as well :-)
- **BMW activate airconditioning**: asking Alexa to activate the AC on hot days.
- **BMW travel time to home**: its usefull when my wife uses the car and shes in a traffic jam, and mostly, because im the homecook, handy to know when she arrives back at the home. Im using a combination of the "device.tracker" , "zone.home" and Google Travel Time integration to calculate the amount of minutes untill she gets home. Handy for making sure pasta/rice/etc is right on time. 

Also i used the Alexa skill " home guide " with which you can built a homeguide skill specific for you home to guide you to specific items, or how to do stuff. F

For example, you can ask Alexa via ' **where is ...** ' the location of the following items (list limited - expanding as i go along). 

- Batteries, wine glasses, cutlery, plates, herbs, paint, tape, toilet paper, tea, coffee, candles, soup, medicines, etc.

On the ' **how to do what** ' side, i created input for, how to do:

- Turn on / off the lights, oven, furance, use the thermostat, view the tV, view the cameras, hot water tap, the shower, etc.

## In Progress <a name="wip"/>

### Building

- Based on ESP32 dev boards im implementing a -per room- tracking system. Also working with trilateralization (app deamon) to do more accurate pinpointing of devices. 
  Done: Kitchen, Living, Office, Master bedroom
  ToDo: Hallway, Storage, Dining, Attic



### Backlog && Ideas  <a name="ideas"/>

See the https://github.com/poweredgenl/smarthome/issues page on github for the enhancement. Below a short summary:

- **Grocy / Groceries inventory management**: already had grocy running / integrated but no good sensor/hardware use case found to test inventory management yet.   WIP untill i find something to monitor.
- **Circadian lighting**: you can link - if you have the proper hardware the color temperature and brightness of your lights - to the natural daylight. It should   give a more natural feeling when it comes to lighting.


Follow me on:

- LinkedIn: https://www.linkedin.com/in/peterpaulkurstjens/
- Mastodon: <a rel="me" href="https://mastodon.tuxtendo.nl/@poweredge">Follow me</a>


