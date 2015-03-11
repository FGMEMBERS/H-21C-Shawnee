# =====
# Doors
# =====

Doors = {};

Doors.new = func {
   obj = { parents : [Doors],
           doorfront : aircraft.door.new("instrumentation/doors/doorfront", 2.0, 0),
		   doorback : aircraft.door.new("instrumentation/doors/doorback", 2.0, 0),
		   crane : aircraft.door.new("instrumentation/doors/crane", 3.0, 0),
         };
   return obj;
};

Doors.doorfrontexport = func {
   me.doorfront.toggle();
}

Doors.doorbackexport = func {
   me.doorback.toggle();
}

Doors.craneexport = func {
   me.crane.toggle();
}

# ==============
# Initialization
# ==============

# objects must be here, otherwise local to init()
doorsystem = Doors.new();




