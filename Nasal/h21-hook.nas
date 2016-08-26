### ONLY IN PILOT SETFILE, FOR COPILOT ANIMATIONS ######
setlistener("/consumables/fuel/tank[0]/level-gal_us", func(vol1) {
    var vol1 = vol1.getValue();
    setprop("/consumables/fuel/tank[0]/mk-level-gal_us", vol1);
});

setlistener("/consumables/fuel/tank[1]/level-gal_us", func(vol2) {
    var vol2 = vol2.getValue();
    setprop("/consumables/fuel/tank[1]/mk-level-gal_us", vol2);
});

var move_hook = func{
  # arg[0] is the step
  # arg[1] is the target/ longeur
  var node = props.globals.getNode("/controls/crane/hook-pos", 1);
  if (node.getValue() == nil) {
      node.setValue(0.0);
  }
  node.setValue(node.getValue() + arg[0]);
  if (node.getValue() < 0.0) {
      node.setValue(0.0);
  }  
  if (node.getValue() >  arg[1]) {
      node.setValue( arg[1]);
  }
}






