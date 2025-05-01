# CamperVan

<!--toc:start-->
- [CamperVan](#campervan)
  - [Design](#design)
  - [Electrical System](#electrical-system)
    - [Sensors](#sensors)
  - [TODO](#todo)
<!--toc:end-->

## Design
I used [OpenScad](https://openscad.org/) to do the campervan design. Whilst I have used SketchUp in the past OpenScad appealed to me more as it is a programmers CAD program plus it is a parametric CAD program which allow me to quickly change a parameter to see how it affects the van layout e.g. visualising the Sofa Bed as a Sofa or a Bed, or easily changing the width of a upboard, which would cause all other dependent cupboards to adjust accordingly.

## Dashboard App
The dashboard app on ios/macos to control the electrical system is written in Flutter and communicates to the Arduino control board via websockets. See [Campervan Flutter](https://github.com/akladnig/campervan_flutter) for details.

## Electrical System

The electrical system for the camper van needs to power the following devices:
- Induction Cooktop - 1800W
- Air Fryer - 1800W
- Duetto Hot Water - 300W
- Bushman 85l fridge -
- Water Pump -
- Lights & Fan - 

![schematic](electrical/schematic.png)

The power system needs to provide off-grid power for 3 days, which required a 4.8kW or 400Ah battery system.

Since 12V, 400A would require massive fuses, switches and cable etc. I've decided to run the system as 2x isolated batteries, rather than in parallel. This will reduce the need for 400A fuses and switches to 200A fuses ans switches.

The other issue is that the DC-DC battery charger has a maximum output of 50A which would result in a 7-8 hour charge time via the alternator. Being able to independently charge each battery with it's own battery charger solves this problem and also 2x 50A chargers are a lot cheaper than a single 100A charger.

The system is designed so the batteries can never be inadvertently connected in parallel.

There are two modes of operation:
- Manual
- Automatic

Manual mode will override any automatic setting and allows the selection of:
- which battery to use for powering appliances
- swapping the dc-dc battery chargers. This will allow selection of which battery to charge via Solar Cells/50A DC-DC charger or 20A DC-DC charger.

Automatic mode will select the battery to use for powering appliances. When the battery charge falls below a certain threshold it will swap to the other battery.

Automatic mode will also swap chargers during driving to ensure the optimum charge time for both batteries. When the ignition is off, charging via solar cells will automatically switch to the second battery when the first is fully charged.

### Sensors
There are a variety of sensors in use:
- voltage dividers
- RS485 which will require some reverse engineering
- Hall effect devices
- Bluetooth for the smart batteries and 50A DC-DC

The following devices are monitored for the associated properties using a voltage divider:
- Starter Battery voltage
- Battery 1 input voltage (before 60A fuse)
- Battery 1 output voltage (after 200A fuse)
- Battery 2 input voltage (before 60A fuse)
- Battery 2 output voltage (after 200A fuase)
- Battery 2 charge switch status - to a digital input
- Battery 2 switch status - to a digital input

The following are monitored via RS485:
- 20A DC-DC battery charger
- Duoetto Heater

The following are monitored via hall effect devices:
- Water input flow
- Water output flow

The following devices are bluetooth enabled:
- Battery 1
- Battery 2
- 50A DC-DC charger

Schematic design software used is [Kicad](https://www.kicad.org/)

## TODO
 - add an Oled touch panel
 - ignition switch input



