###############################################################################
##
## H 21C flying banana for FlightGear.
## Walk view configuration.
##
##  Stolen from
##  Copyright (C) 2008 - 2010  Anders Gidenstam  (anders(at)gidenstam.org)
##  and modify by Marc Kraus (info(at)marc-kraus.de) in Avril 2012
##
###############################################################################
# Constraints
var flightdeckConstraint =
    walkview.makeUnionConstraint(
        [
         # [ smallest x, smallest y, smallest z] in the DO-X
         # [ largest x, largest y, largest z] in the DO-X
         # Instrument View.
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -7.1, 0, -0.3], 
                                                [ -6.9, 0, -0.3]),
              func {
                  #print("Instrument View");
                  walkview.active_walker().set_eye_height(0.7);
              },
              func(x, y) {
                  # Nothing.
              }),
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -6.9,  0, -0.4], 
                                                [ -6.6,  0   , -0.4]),
              func {
                  #print("stand up in cockpit");
                  walkview.active_walker().set_eye_height(1.2);
              },
              func(x, y) {
                  # Nothing.
              }),
         # Cockpit door
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -6.6,  0, -0.4], 
                                                [ -5.65,  0, -0.4]),
              func {
                  #print("cockpit door");
                  walkview.active_walker().set_eye_height(1.0);
              },
              func(x, y) {
                  # Nothing.
              }),

         # in the cabin
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([  -5.65, -0.70, -0.4], 
                                                [  -5.0,  1.2, -0.4]),
              func {
                  #print("Search position");
                  walkview.active_walker().set_eye_height(1.0);
              },
              func(x, y) {
                  # Nothing.
              }),


         # in the cabin
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -5.0, -0.65, -0.4], 
                                                [  -4.5,  0.55, -0.4]),
              func {
                  #print("cabine more 1");
                  walkview.active_walker().set_eye_height(0.65);
              },
              func(x, y) {
                  # Nothing.
              }),


         # in the cabin
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([  -4.5, -0.65, -0.4], 
                                                [  -3.5,  0.55, -0.4]),
              func {
                  #print("cabine more 2");
                  walkview.active_walker().set_eye_height(0.55);
              },
              func(x, y) {
                  # Nothing.
              }),

         # in the cabin
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([  -3.5, -0.65, -0.4], 
                                                [  -0.80,  0.55, -0.4]),
              func {
                  #print("cabine more 3");
                  walkview.active_walker().set_eye_height(0.45);
              },
              func(x, y) {
                  # Nothing.
              }),

         # Back Door view
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -0.80 , -1.20, -0.4], 
                                                 [-0.45,   0.55, -0.4]),
              func {
                  #print("Back Door");
                  walkview.active_walker().set_eye_height(0.38);
              },
              func(x, y) {
                  # Nothing.
              }),

         # in the cabin
         walkview.ActionConstraint.new
             (walkview.SlopingYAlignedPlane.new([ -0.45 , -0.55, -0.4], 
                                                 [ 0.20,  0.55, -0.4]),
              func {
                  #print("end of cabine");
                  walkview.active_walker().set_eye_height(0.35);
              },
              func(x, y) {
                  # Nothing.
              })

        ]);

# The view manager.
var copilot_walker = walkview.Walker.new("Walkview", flightdeckConstraint);

