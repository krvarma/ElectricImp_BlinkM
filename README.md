Electric Imp and BlinkM sample
------------------------------

A simple Electric Imp application that controls BlinkM Smart LED. This is only simple port of BlinKM functions. Not all the functions are included, only functions to set and fade RGB and HSB is included in this sample. The application does not include Script and other functionality. This will be added in future.

**Wiring**

 1. BlinkM SCL to Pin 1 
 2. BlinkM SDA to Pin 2 
 3. BlinkM Vcc to 3.3V 
 4. BlinkM GND to GND

![enter image description here][1]

**Sample Application**
The sample application defines a class BlinkM which contains which defines the BlinkM functions. The application simply fade Red, Green and Blue.


  [1]: https://raw.githubusercontent.com/krvarma/ElectricImp_BlinkM/master/IMG_0069.JPG