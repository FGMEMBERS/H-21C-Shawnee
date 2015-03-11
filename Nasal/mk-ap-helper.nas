#=======================================================================
# In copilot mode the value of autopilot kill all pilot - copilot action
# ok, so pilot settings must be written to switch boolean values
#=======================================================================
setlistener("/sim/signals/fdm-initialized", func {
      setprop("/autopilot/locks/altitude", "");
      setprop("/autopilot/locks/heading", "");
      setprop("/autopilot/switches/ap", 0);
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/nav", 0);
});

setlistener("/autopilot/switches/ap", func (ap){
    var ap = ap.getBoolValue();
    if (ap == 1){
      var hdgSet = getprop("/autopilot/switches/hdg");
      var altSet = getprop("/autopilot/switches/alt");
      var navSet = getprop("/autopilot/switches/nav");

      if((!hdgSet and !altSet and !navSet)){
        setprop("/autopilot/locks/heading", "wing-leveler");
      }

    }else{
      setprop("/autopilot/locks/altitude", "");
      setprop("/autopilot/locks/heading", "");
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/nav", 0);
      applyTrimWheels(0, 0);
    }
});

setlistener("/autopilot/switches/hdg", func (hdg){
    var hdg = hdg.getBoolValue();
    if (hdg == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/locks/heading", "dg-heading-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/alt", func (alt){
    var alt = alt.getBoolValue();
    if (alt == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/locks/altitude", "altitude-hold");
      setprop("/autopilot/settings/target-altitude-ft", getprop("/position/altitude-ft"));
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});

setlistener("/autopilot/switches/nav", func (nav){
    var nav = nav.getBoolValue();
    if (nav == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/locks/heading", "nav1-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});


# If the elevator trim wheel is not on 0 and you click the center of this wheel
var trimBackTime = 2.0;
var applyTrimWheels = func(v, which = 0) {
    if (which == 0) { interpolate("/controls/flight/elevator-trim", v, trimBackTime); }
}

