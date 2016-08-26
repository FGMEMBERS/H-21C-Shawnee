###############################################################################################
#		Lake of Constance Hangar :: M.Kraus
#		Race laptimes observer for Flightgear Dezember 2015
#		This file is licenced under the terms of the GNU General Public Licence V2 or later
############################################################################################### 

setlistener("/race-observer/show-mp-times", func (position){
    var position = position.getValue();
	if(position) show_mp_times();
});

################## Little Help Window on bottom of screen #################
var help_win = screen.window.new( 0, 0, 1, 5 );
help_win.fg = [1,1,1,1];

var messenger = func{
help_win.write(arg[0]);
}
############################ helper for view ####################################
var show_helper = func(s) {
  var hours = int(s / 3600);
  var minutes = int(math.mod(s / 60, 60));
  var seconds = math.mod(s, 60);
  var timestring = "";
  
	if (hours > 0){
  		timestring = sprintf("%3d:", hours);
	}
	timestring = timestring~sprintf("%02d:%.1f", minutes, seconds);	

	return timestring;
}

############################### Show mp lap and sector times ####################################
var show_mp_times = func{
    var showMpLaptimes = getprop("/race-observer/show-mp-times") or 0;
    var mpOther = props.globals.getNode("/ai/models").getChildren("multiplayer");
    var otherNr = size(mpOther);
	var winpos = 1;
	var wintoppos = -60;
	
	for(var v=0; v < otherNr; v+=1){

		if ((mpOther[v].getNode("sim/model/path").getValue() == "Aircraft/BMW-S-RR/Models/BMW-S-1000-RR.xml" or
			mpOther[v].getNode("sim/model/path").getValue() == "Aircraft/Suzuki-GSX-R/Models/Suzuki-GSX-R1000.xml" or
			mpOther[v].getNode("sim/model/path").getValue() == "Aircraft/LCR/Models/LCR-F2.xml")
			and mpOther[v].getNode("id").getValue() >= 0) {
			
			var race_win = screen.window.new( 1, wintoppos, 1, 1.1 );
			race_win.fg = [1,1,1,1]; # color last three rgb
			race_win.write(mpOther[v].getNode("callsign").getValue());
			
			var twinpos = 120;
			
			var name = mpOther[v].getNode("sim/multiplay/generic/string[0]").getValue() or '--';

			if(mpOther[v].getNode("sim/multiplay/generic/int[3]").getValue() == 1){
				name = name~"/crashed";
				var race_win = screen.window.new( twinpos, wintoppos, 1, 1.1 );
				race_win.fg = [1,0,0,1]; #color first three rgb
				race_win.write(name);
			}else if(mpOther[v].getNode("sim/multiplay/generic/float[4]").getValue() > 0.9){
				name = name~"/engine damage";
				var race_win = screen.window.new( twinpos, wintoppos, 1, 1.1 );
				race_win.fg = [1,0,0,1]; #color first three rgb
				race_win.write(name);
			}else if(mpOther[v].getNode("sim/multiplay/generic/float[4]").getValue() > 0.5){
				name = name~"/engine trouble";
				var race_win = screen.window.new( twinpos, wintoppos, 1, 1.1 );
				race_win.fg = [1,0.8,0,1]; #color first three rgb
				race_win.write(name);
			}else{
				var race_win = screen.window.new( twinpos, wintoppos, 1, 1.1 );
				race_win.fg = [1,1,0,1]; #color first three rgb
				race_win.write(name);
			}
			
			
			twinpos = 6*100;
			
			var race_win = screen.window.new( twinpos+135, wintoppos, 2, 1.1 );
			race_win.fg = [1,1,1,1]; #color last three rgb
			race_win.write("# "~mpOther[v].getNode("sim/multiplay/generic/int[1]").getValue()~".# "~show_helper(mpOther[v].getNode("sim/multiplay/generic/float[6]").getValue()));
			race_win.write(" ["~show_helper(mpOther[v].getNode("sim/multiplay/generic/float[8]").getValue())~"]");
				
			var race_win = screen.window.new( twinpos+280, wintoppos, 1, 1.1 );
			race_win.fg = [1,1,1,1]; #color last three rgb
			race_win.write(show_helper(mpOther[v].getNode("sim/multiplay/generic/float[7]").getValue()));

			wintoppos += -35;
		}
	}

    if(showMpLaptimes) settimer(show_mp_times, 1.1);
print("laeuft!");

}

