#include <Tlc5940.h>
#include <tlc_config.h>
#include <tlc_progmem_utils.h>

#include <AirSensor.h>
#include <AMUPconfig.h>

// ARDUINO PIN DEFINIONS
#define AIR_PIN           A0
#define LED_COUNT         10
#define LED_VOL_CONVERT   12
#define LOCK_ON_COLOR     B
#define LOCK_OFF_COLOR    R

// LED PIN DEFINITION (pins on TLC 5940)
int const rgbLED [LED_COUNT][RGB_COUNT] = {28,30,29,25,27,26,22,24,23,19,21,20,
                                         16,18,17,12,14,13,9,11,10,3,5,4,0,2,1};
// IMPORTANT NOTE: five digital pins are used to control the LED drivers (TLC 5940); pins 3, 9, 10, 11, 13.
// Communication uses a synchronized serial protocol

AirSensor air_sensor = AirSensor(16, AIR_PIN);

int current_vol;              // holds the current output volume
int previous_vol;             // holds the previous output volume, to determine if volume has changed
int current_color;            // holds the current color of the volume display leds
volatile boolean connection_started;   // 
boolean lock_on;

void setup() {
  Tlc.init(0);
  Serial.begin(57600);
  connection_started = false;
  lock_on = false;
  current_color = LOCK_OFF_COLOR;
  previous_vol = 0;
  current_vol = 0;
  Serial.println("init complete. send \'c\' to connect.");
}

void loop() {
    handle_serial_input();   // listens to serial input for connect and lock messages
    sense_and_send();        // reads air sensor, processes data, and writes results to serial
}

