# $Id: s51.nas







# engines/rotor =====================================================
var rotor = props.globals.getNode("controls/engines/engine/rotorgear");
var collective0= props.globals.getNode("controls/engines/engine/throttle");
var collective1= props.globals.getNode("controls/engines/engine[1]/throttle");
var state = props.globals.getNode("sim/model/h21/state");
var turbine = props.globals.getNode("sim/model/h21/turbine-rpm-pct", 1);
var brake = props.globals.getNode("controls/rotor/brake");
var master_bat = props.globals.getNode("controls/engines/engine/master-bat");
var magnetos = props.globals.getNode("controls/engines/engine/magnetos");
var master_switch = props.globals.getNode("controls/electric/master-switch");
var battery_switch = props.globals.getNode("controls/electric/battery-switch");



print("engines off");
var engines = func {

              var  s = state.getValue();
                        if (arg[0] == 1)  {
                                if (s == 0  and master_switch.getValue() == 1) {
                                        state.setValue(1);
                                        print("engines started");
                                        brake.setValue(0);
                                        collective0.setValue(1);
                                        collective1.setValue(1);
                                        settimer(func { rotor.setValue(1) }, 3);
                                        interpolate(turbine, 100, 10.5);
                                        settimer(func { state.setValue(2) ; print("engines running") }, 10.5);
                        }
                        } else {
                                if (s == 2) {
                                        print("engines stopped");
                                        rotor.setValue(0);
                                        state.setValue(3);
                                        interpolate(turbine, 0, 18);
                                        settimer(func { state.setValue(0) ; print("engines off") }, 18);
                                        }
                                        magnetos.setValue(0);
                                        master_bat.setValue(0);
                                        master_switch.setValue(0);
                                        battery_switch.setValue(0);
                                    }
                                            
                }
                
var electric = func {
                    magnetos.setValue(3);
                    master_bat.setValue(1);
                    master_switch.setValue(1);
                    battery_switch.setValue(1);
}


#Alimentation Electrique========Allumé   Coupé===========================================


var Aig_AC=0;

setprop("/controls/electric/master-switch",Aig_AC);

var Electric_Cmt=func{
        if(getprop("/controls/engines/engine[0]/magnetos")=="1"){
        Aig_AC=getprop("/controls/electric/master-switch");
        Aig_AC=1-Aig_AC;
        setprop("/controls/electric/master-switch",Aig_AC);
        }
}

setlistener("/controls/engines/engine[0]/magnetos",Electric_Cmt);

var Electric_Cmd=func{
        if(getprop("/controls/electric/master-switch")=="1"){
        setprop("/controls/electric/battery-switch","true");
        setprop("controls/electric/external-power", "true");
        setprop("/controls/engines/engine[0]/master-bat", "true");
        
        setprop("/controls/switches/master-avionics", "true");  
        }
        elsif(getprop("/controls/electric/master-switch")=="0"){
        setprop("/controls/electric/battery-switch","false");
        setprop("controls/electric/external-power", "false");
        setprop("/controls/engines/engine[0]/master-bat", "false");
        
        setprop("/controls/switches/master-avionics", "false");
        #setprop("/controls/lighting/instruments-norm",0);
        }
}
Electric_Cmd();

setlistener("/controls/electric/master-switch",Electric_Cmd);


