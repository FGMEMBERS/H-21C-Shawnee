###############################################################################
##  Nasal for dual control the H-21C Piasecki over the multiplayer network.
##
##  Copyright (C) 2007 - 2008  Anders Gidenstam  (anders(at)gidenstam.org)
##  This file is licensed under the GPL license version 2 or later.
##
##  For the H-21C, written in Avril 2012 by Marc Kraus
##
###############################################################################

## Renaming (almost :)
var DCT = dual_control_tools;

## Pilot/copilot aircraft identifiers. Used by dual_control.
var pilot_type   = "Aircraft/H-21C-Shawnee/Models/H21-piasecki.xml";
var copilot_type = "Aircraft/H-21C-Shawnee/Models/H21-copilot.xml";

############################ PROPERTIES MP ###########################

var switch_mpp     = "sim/multiplay/generic/int[0]";
var TDM_mpp        = "sim/multiplay/generic/string[0]";

# double
var door			= ["instrumentation/doors/doorfront/position-norm",  
                       "instrumentation/doors/doorback/position-norm"];  
var hdg				= "autopilot/settings/heading-bug-deg"; 
var magnetos		= "controls/engines/engine/magnetos";   
var master			= "controls/electric/master-switch";
var radio			= "instrumentation/radio-select/switch";   
var rotor			= "controls/engines/engine/rotorgear"; 
var qnh				= "instrumentation/altimeter/setting-inhg"; 
var torquemain		= "rotors/main/torque";
var torquetail		= "rotors/tail/torque";
var electric		= ["controls/electric/master-switch", 
                       "controls/lighting/panel-norm"];
var tank			= ["consumables/fuel/tank[0]/mk-level-gal_us", 
                       "consumables/fuel/tank[1]/mk-level-gal_us"];
var rollspeed		= ["gear/gear[0]/rollspeed-ms", 
                       "gear/gear[1]/rollspeed-ms", 
                       "gear/gear[2]/rollspeed-ms"];
var gearcaster		= "gear/gear[0]/caster-angle-deg";


# Navigation
var nav             = ["instrumentation/nav[0]/frequencies/selected-mhz",
                       "instrumentation/nav[0]/radials/selected-deg"];
var adf             = "instrumentation/adf[0]/frequencies/selected-khz";
var tacan           = "instrumentation/tacan/frequencies/selected-channel";
var tacanString     = "instrumentation/tacan/frequencies/selected-channel[4]";

# Engine
var h21state        = "sim/model/h21/state";

var comm            = "instrumentation/comm/frequencies/selected-mhz";

# FlightRalleyWatch
var frw             = ["instrumentation/frw/flight-time/hours", 
                       "instrumentation/frw/flight-time/minutes", 
                       "instrumentation/frw/flight-time/seconds"];

# bool
var bat             = "controls/engines/engine/master-bat"; 
var battery         = "controls/electric/battery-switch";  
var gear            = ["gear/gear[0]/wow", 
                       "gear/gear[1]/wow", 
                       "gear/gear[2]/wow"];
var ap              = ["autopilot/switches/alt",
                       "autopilot/switches/ap",
                       "autopilot/switches/hdg",
                       "autopilot/switches/nav",
                       "autopilot/switches/dme"];
var light           = ["controls/lighting/nav-lights",
                       "controls/lighting/beacon",
                       "controls/lighting/strobe",
                       "controls/lighting/landing-lights",
                       "controls/lighting/logo-lights",
                       "controls/switches/master-cover",
                       "controls/switches/rotor-brake-cover",
                       "controls/switches/start",
                       "controls/rotor/brake",
                       "controls/gear/brake-parking"];

var l_dual_control  = "dual-control/active";

######################################################################
###### Used by dual_control to set up the mappings for the pilot #####
######################## PILOT TO COPILOT ############################
######################################################################

var pilot_connect_copilot = func (copilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Pilot section");
  setprop(l_dual_control, 1);

  return [
      ##################################################
      # Map copilot properties to buffer properties

      # copilot to pilot
      DCT.TDMEncoder.new
        ([
          props.globals.getNode(door[0]),
          props.globals.getNode(door[1]),
          props.globals.getNode(hdg),
          props.globals.getNode(magnetos),
          props.globals.getNode(master),
          props.globals.getNode(radio),
          props.globals.getNode(rotor),
          props.globals.getNode(qnh),
          props.globals.getNode(torquemain),
		  props.globals.getNode(torquetail),
          props.globals.getNode(electric[0]),
          props.globals.getNode(electric[1]),
          props.globals.getNode(tank[0]),
          props.globals.getNode(tank[1]),
          props.globals.getNode(frw[0]),
          props.globals.getNode(frw[1]),
          props.globals.getNode(frw[2]),
          props.globals.getNode(nav[0]),
          props.globals.getNode(nav[1]),
          props.globals.getNode(adf),
          props.globals.getNode(tacan),
          props.globals.getNode(comm),
		  props.globals.getNode(rollspeed[0]),
		  props.globals.getNode(rollspeed[1]),
		  props.globals.getNode(rollspeed[2]),
		  props.globals.getNode(gearcaster)
         ], props.globals.getNode(TDM_mpp)),

      DCT.SwitchEncoder.new
        ([
          props.globals.getNode(bat),
          props.globals.getNode(battery),
          props.globals.getNode(gear[0]),
          props.globals.getNode(gear[1]),
          props.globals.getNode(gear[2]),
          props.globals.getNode(ap[0]),
          props.globals.getNode(ap[1]),
          props.globals.getNode(ap[2]),
          props.globals.getNode(ap[3]),
          props.globals.getNode(ap[4]),
          props.globals.getNode(light[0]),
          props.globals.getNode(light[1]),
          props.globals.getNode(light[2]),
          props.globals.getNode(light[3]),
          props.globals.getNode(light[4]),
          props.globals.getNode(light[5]),
          props.globals.getNode(light[6]),
          props.globals.getNode(light[7]),
          props.globals.getNode(light[8]),
          props.globals.getNode(light[9])
         ], props.globals.getNode(switch_mpp)),   

  ];
}

##############
var pilot_disconnect_copilot = func {
  setprop(l_dual_control, 0);
}

######################################################################
##### Used by dual_control to set up the mappings for the copilot ####
######################## COPILOT TO PILOT ############################
######################################################################

var copilot_connect_pilot = func (pilot) {
  # Make sure dual-control is activated in the FDM FCS.
  print("Copilot section");
  setprop(l_dual_control, 1);

  return [

      ##################################################
      # Map pilot properties to buffer properties

      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[0]"),
                         props.globals.getNode("/position/altitude-agl-ft", 1)),
	  DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[19]"),
                         props.globals.getNode("/position/gear-agl-m", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/float[7]"),
                         props.globals.getNode("/rotors/main/rpm", 1)),
      DCT.Translator.new(pilot.getNode("sim/multiplay/generic/string[1]"), props.globals.getNode(tacanString, 1)),

      DCT.TDMDecoder.new
        (pilot.getNode(TDM_mpp), 
        [func(v){pilot.getNode(door[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~door[0], 1).setValue(v);},
         func(v){pilot.getNode(door[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~door[1], 1).setValue(v);},
         func(v){pilot.getNode(hdg, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~hdg, 1).setValue(v);},
         func(v){pilot.getNode(magnetos, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~magnetos, 1).setValue(v);},
         func(v){pilot.getNode(master, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~master, 1).setValue(v);},
         func(v){pilot.getNode(radio, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~radio, 1).setValue(v);},
         func(v){pilot.getNode(rotor, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~rotor, 1).setValue(v);},
         func(v){pilot.getNode(qnh, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~qnh, 1).setValue(v);},
         func(v){pilot.getNode(torquemain, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~torquemain, 1).setValue(v);},
		 func(v){pilot.getNode(torquetail, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~torquetail, 1).setValue(v);},
         func(v){pilot.getNode(electric[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~electric[0], 1).setValue(v);},
         func(v){pilot.getNode(electric[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~electric[1], 1).setValue(v);},
         func(v){pilot.getNode(tank[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank[0], 1).setValue(v);},
         func(v){pilot.getNode(tank[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tank[1], 1).setValue(v);},
         func(v){pilot.getNode(frw[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~frw[0], 1).setValue(v);},
         func(v){pilot.getNode(frw[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~frw[1], 1).setValue(v);},
         func(v){pilot.getNode(frw[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~frw[2], 1).setValue(v);},
         func(v){pilot.getNode(nav[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav[0], 1).setValue(v);},
         func(v){pilot.getNode(nav[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~nav[1], 1).setValue(v);},
         func(v){pilot.getNode(adf, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~adf, 1).setValue(v);},
         func(v){pilot.getNode(tacan, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~tacan, 1).setValue(v);},
         func(v){pilot.getNode(comm, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~comm, 1).setValue(v);}, 
		 func(v){pilot.getNode(rollspeed[0], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~rollspeed[0], 1).setValue(v);},
		 func(v){pilot.getNode(rollspeed[1], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~rollspeed[1], 1).setValue(v);},
		 func(v){pilot.getNode(rollspeed[2], 1).setValue(v); props.globals.getNode("dual-control/pilot/"~rollspeed[2], 1).setValue(v);},
		 func(v){pilot.getNode(gearcaster, 1).setValue(v); props.globals.getNode("dual-control/pilot/"~gearcaster, 1).setValue(v);}
        ]),

      DCT.SwitchDecoder.new
        (pilot.getNode(switch_mpp),
        [func(b){props.globals.getNode(bat).setValue(b);},
         func(b){props.globals.getNode(battery).setValue(b);},
         func(b){props.globals.getNode(gear[0]).setValue(b);},
         func(b){props.globals.getNode(gear[1]).setValue(b);},
         func(b){props.globals.getNode(gear[2]).setValue(b);},
         func(b){props.globals.getNode(ap[0]).setValue(b);},
         func(b){props.globals.getNode(ap[1]).setValue(b);},
         func(b){props.globals.getNode(ap[2]).setValue(b);},
         func(b){props.globals.getNode(ap[3]).setValue(b);},
         func(b){props.globals.getNode(ap[4]).setValue(b);},
         func(b){props.globals.getNode(light[0]).setValue(b);},
         func(b){props.globals.getNode(light[1]).setValue(b);},
         func(b){props.globals.getNode(light[2]).setValue(b);},
         func(b){props.globals.getNode(light[3]).setValue(b);},
         func(b){props.globals.getNode(light[4]).setValue(b);},
         func(b){props.globals.getNode(light[5]).setValue(b);},
         func(b){props.globals.getNode(light[6]).setValue(b);},
         func(b){props.globals.getNode(light[7]).setValue(b);},
         func(b){props.globals.getNode(light[8]).setValue(b);},
         func(b){props.globals.getNode(light[9]).setValue(b);},
        ]),


      ##################################################
      # Animation of the knobs and more
      # from switch_mpp
      DCT.Translator.new(props.globals.getNode(bat, 1), pilot.getNode("/"~bat)),
      DCT.Translator.new(props.globals.getNode(battery, 1), pilot.getNode("/"~battery)),
      DCT.Translator.new(props.globals.getNode(gear[0], 1), pilot.getNode("/"~gear[0])),
      DCT.Translator.new(props.globals.getNode(gear[1], 1), pilot.getNode("/"~gear[1])),
      DCT.Translator.new(props.globals.getNode(gear[2], 1), pilot.getNode("/"~gear[2])),
      DCT.Translator.new(props.globals.getNode(ap[0], 1), pilot.getNode("/"~ap[0])),
      DCT.Translator.new(props.globals.getNode(ap[1], 1), pilot.getNode("/"~ap[1])),
      DCT.Translator.new(props.globals.getNode(ap[2], 1), pilot.getNode("/"~ap[2])),
      DCT.Translator.new(props.globals.getNode(ap[3], 1), pilot.getNode("/"~ap[3])),
      DCT.Translator.new(props.globals.getNode(ap[4], 1), pilot.getNode("/"~ap[4])),
      DCT.Translator.new(props.globals.getNode(light[0], 1), pilot.getNode("/"~light[0])),
      DCT.Translator.new(props.globals.getNode(light[1], 1), pilot.getNode("/"~light[1])),
      DCT.Translator.new(props.globals.getNode(light[2], 1), pilot.getNode("/"~light[2])),
      DCT.Translator.new(props.globals.getNode(light[3], 1), pilot.getNode("/"~light[3])),
      DCT.Translator.new(props.globals.getNode(light[4], 1), pilot.getNode("/"~light[4])),
      DCT.Translator.new(props.globals.getNode(light[5], 1), pilot.getNode("/"~light[5])),
      DCT.Translator.new(props.globals.getNode(light[6], 1), pilot.getNode("/"~light[6])),
      DCT.Translator.new(props.globals.getNode(light[7], 1), pilot.getNode("/"~light[7])),
      DCT.Translator.new(props.globals.getNode(light[8], 1), pilot.getNode("/"~light[8])),
      DCT.Translator.new(props.globals.getNode(light[9], 1), pilot.getNode("/"~light[9])),

      # from TDM_mpp
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~door[0], 1), props.globals.getNode(door[0]), props.globals.getNode(door[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~door[1], 1), props.globals.getNode(door[1]), props.globals.getNode(door[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~hdg, 1), props.globals.getNode(hdg), props.globals.getNode(hdg), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~magnetos, 1), props.globals.getNode(magnetos), props.globals.getNode(magnetos), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~master, 1), props.globals.getNode(master), props.globals.getNode(master), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~radio, 1), props.globals.getNode(radio), props.globals.getNode(radio), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~rotor, 1), props.globals.getNode(rotor), props.globals.getNode(rotor), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~qnh, 1), props.globals.getNode(qnh), props.globals.getNode(qnh), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~torquemain, 1), props.globals.getNode(torquemain), props.globals.getNode(torquemain), 0.01),
	  DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~torquetail, 1), props.globals.getNode(torquetail), props.globals.getNode(torquetail), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~electric[0], 1), props.globals.getNode(electric[0]), props.globals.getNode(electric[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~electric[1], 1), props.globals.getNode(electric[1]), props.globals.getNode(electric[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank[0], 1), props.globals.getNode(tank[0]), props.globals.getNode(tank[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tank[1], 1), props.globals.getNode(tank[1]), props.globals.getNode(tank[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~frw[0], 1), props.globals.getNode(frw[0]), props.globals.getNode(frw[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~frw[1], 1), props.globals.getNode(frw[1]), props.globals.getNode(frw[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~frw[2], 1), props.globals.getNode(frw[2]), props.globals.getNode(frw[2]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav[0], 1), props.globals.getNode(nav[0]), props.globals.getNode(nav[0]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~nav[1], 1), props.globals.getNode(nav[1]), props.globals.getNode(nav[1]), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~adf, 1), props.globals.getNode(adf), props.globals.getNode(adf), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~tacan, 1), props.globals.getNode(tacan), props.globals.getNode(tacan), 0.01),
      DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~comm, 1), props.globals.getNode(comm), props.globals.getNode(comm), 0.01),
	  DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~rollspeed[0], 1), props.globals.getNode(rollspeed[0]), props.globals.getNode(rollspeed[0]), 0.01),
	  DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~rollspeed[1], 1), props.globals.getNode(rollspeed[1]), props.globals.getNode(rollspeed[1]), 0.01),
	  DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~rollspeed[2], 1), props.globals.getNode(rollspeed[2]), props.globals.getNode(rollspeed[2]), 0.01),
	  DCT.MostRecentSelector.new(props.globals.getNode("dual-control/pilot/"~gearcaster, 1), props.globals.getNode(gearcaster), props.globals.getNode(gearcaster), 0.01)
  ];

}

var copilot_disconnect_pilot = func {
  setprop(l_dual_control, 0);
}
