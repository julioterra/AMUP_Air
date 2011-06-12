#include <Tlc5940.h>
#include <tlc_config.h>
#include <tlc_progmem_utils.h>
#include <AirSensor.h>
#include <AMUPconfig.h>

// ARDUINO PIN DEFINIONS
#define AIR_PIN          A0
#define LED_COUNT         10
#define RGB_COUNT         3
#define LED_VOL_CONVERT  12

// LED PIN DEFINITION (pins on TLC 5940)
int const rgbLED [LED_COUNT][RGB_COUNT] = {28,30,29,25,27,26,22,24,23,19,21,20,
                                         16,18,17,12,14,13,9,11,10,3,5,4,0,2,1};
// IMPORTANT NOTE: five digital pins are used to control the LED drivers (TLC 5940); pins 3, 9, 10, 11, 13.
// Communication uses a synchronized serial protocol

AirSensor air_sensor = AirSensor(AIR_PIN);

int current_vol = 0;
int previous_vol = 0;
int current_color = R;
boolean connection_started = false;
boolean lock_on = false;

void setup() {
  Tlc.init(0);
  Serial.begin(57600);
  Serial.println("send \'c\' to connect.");
  connection_started = false;
}

void loop() {
    handle_serial_input();
    sense_and_send();
}

void handle_serial_input () {
    if (Serial.available()) {
        char new_serial = Serial.read();

       if (new_serial == AIR_CONNECT_CHAR) {
          connection_started = true; 
          Serial.println("connected to air.");
       }
       else if (new_serial == AIR_LOCK_ON_CHAR) {
              lock_on = true; 
              current_color = B;
              update_leds(previous_vol);
       } 
       else if (new_serial == AIR_LOCK_OFF_CHAR){
              lock_on = false;
              current_color = R;
              update_leds(previous_vol);
              air_sensor.reset();
        }
    }
}

void sense_and_send() {
     if (connection_started && !lock_on) {
       // read data and print to serial if appropriate 
       current_vol = air_sensor.play();      

        // if volume has changed then update the leds
        if (current_vol != previous_vol && current_vol != -1) {
            update_leds(current_vol);
            previous_vol = current_vol; 
        }
    }
}

void update_leds(int volume) {
   Tlc.clear();
   for (int i = 0; i < volume/LED_VOL_CONVERT; i ++) {
        if (i == volume/LED_VOL_CONVERT-1) Tlc.set(rgbLED[i][current_color], volume/127*LED_MAX_BRIGHT);     
         Tlc.set(rgbLED[i][current_color], LED_MAX_BRIGHT);    
   }
   Tlc.update();   
}

