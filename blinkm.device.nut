class BlinkM{
    _i2c = null;
    _addr = null;
    
    constructor(i2c, addr){
        _i2c = i2c;
        _addr = addr;
    }
    
    function write(data){
        _i2c.write(_addr, data);
    }
    
    function read(subaddress, numbytes){
        return _i2c.read(_addr, subaddress, numbytes);
    }
    
    function stopscript(){
        write("o");
    }
    
    function setrgb(r, g, b){
        write("n");
        write(format("%c", r));
        write(format("%c", g));
        write(format("%c", b));
    }
    
    function fadetorgb(r, g, b){
        write("c");
        write(format("%c", r));
        write(format("%c", g));
        write(format("%c", b));
    }
    
    function fadetohsb(h, s, b){
        write("h");
        write(format("%c", h));
        write(format("%c", s));
        write(format("%c", b));
    }
    
    function setfadespeed(speed){
        write("f");
        write(format("%c", speed));
    }
    
    function getaddress(){
        write("a");
        
        return read("", 1)[0];
    }
    
    function getversion(){
        write("Z");
        
        local major = read("", 1)[0];
        local minor = read("", 1)[0];
        
        return (major << 8) + minor;
    }
}

hardware.i2c12.configure(CLOCK_SPEED_400_KHZ);

blinkm <- BlinkM(hardware.i2c12, (0x09 << 1));
clrindex <- 0;
colorval <- 255;
blinkInterval <- 1.0;

function initialize(){
    blinkm.stopscript()
    blinkm.setfadespeed(5);
}

function changecolor(){
    switch(clrindex){
        case 0: blinkm.fadetorgb(colorval, 0, 0);   break;
        case 1: blinkm.fadetorgb(0, colorval, 0);   break;
        case 2: blinkm.fadetorgb(0, 0, colorval);   break;
    }
    
    ++clrindex;
    
    if(3 == clrindex){
        clrindex = 0;
    }
    
    server.log("SSID: " + imp.getssid());
    server.log("Binary SSID: " + imp.getbssid());
    server.log("MAC Address: " + imp.getmacaddress());
    server.log("Software Version: " + imp.getsoftwareversion());
    server.log("Free Memory: " + imp.getmemoryfree());
    server.log("Signal Strength: " + getrssistring());
    server.log("BlinkM Address: " + blinkm.getaddress());
    server.log("BlinkM Version: " + blinkm.getversion());
    
    imp.sleep(blinkInterval);
    blinkm.fadetorgb(0, 0, 0);
    imp.wakeup(blinkInterval, changecolor);
}

function getrssistring() {
    local rssi = imp.rssi();
    
    rssistring <- "";
    
    if (rssi < -87) {
        rssistring = rssi + "dBm (0 bars)";
    }
    else if (rssi < -82) {
        rssistring = rssi + "dBm (1 bar)";
    }
    else if (rssi < -77) {
        rssistring = rssi + "dBm (2 bars)";
    }
    else if (rssi < -72) {
        rssistring = rssi + "dBm (3 bars)";
    }
    else if (rssi < -67) {
        rssistring = rssi + "dBm (4 bars)";
    }
    else {
        rssistring = rssi + "dBm (5 bars)";
    }
    
    return rssistring;
}

initialize();
changecolor();