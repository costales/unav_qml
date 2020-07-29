var gps_started = false;

function start() {
    if (gps_started) {
        return;
    }
    gps_started = true;
    location.start();
}

function save_pos() { 
}