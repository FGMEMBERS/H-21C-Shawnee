# must go the deviation over the elevator-trim
# in the yasim file you will find elevator-h21 on place of elevator for control fdm
setlistener("/controls/flight/elevator-trim", func(eltrim) {
    var eltrim = eltrim.getValue();
    var elev  = getprop("/controls/flight/elevator") or 0;
    var elnew = elev + eltrim;

    setprop("/controls/flight/elevator-h21", elnew);
});


setlistener("/controls/flight/elevator", func(elev) {
    var elev   = elev.getValue();
    var eltrim = getprop("/controls/flight/elevator-trim") or 0;

    var eluse  = eltrim + elev;
    setprop("/controls/flight/elevator-h21", eluse);
});


# give the local properties to multiplay surface-position/

setlistener("/controls/flight/elevator", func(elev) {
    var elev = elev.getValue();
    setprop("/surface-positions/elevator-pos-norm", elev);
});

setlistener("/controls/flight/aileron", func(ail) {
    var ail = ail.getValue();
    setprop("/surface-positions/left-aileron-pos-norm", ail);
});

setlistener("/controls/flight/rudder", func(rud) {
    var rud = rud.getValue();
    setprop("/surface-positions/rudder-pos-norm", rud);
});
