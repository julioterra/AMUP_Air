#include <AirSensor.h>
#include <AnalogSwitch.h>
#include <RGBButton.h>
#include <Rotary_Encoder.h>
#include <Switch.h>


// Wire Master Reader
// by Nicholas Zambetti <http://www.zambetti.com>
// Demonstrates use of the Wire library
// Reads data from an I2C/TWI slave device
// Refer to the "Wire Slave Sender" example for use with this
// Created 29 March 2006

// This example code is in the public domain.
#include <Rotary_Encoder.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <Wire.h>

#define TRANSMIT_MSG_SIZE    25
int analog_switch_pin = A0;

Rotary_Encoder encoders[3] = {Rotary_Encoder(0,2,4), Rotary_Encoder(1,3,5), Rotary_Encoder(2,18,6)};
AnalogSwitch main_vol = AnalogSwitch(3,analog_switch_pin);

void setup() {
  Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(57600);  // start serial for output
}

void loop() {
  receiveI2C(20);
  receiveI2C(21);
  receiveI2C(22);
  receiveI2C(23);
//  sendI2C(20, "test test");
}

void event() {
  
}

