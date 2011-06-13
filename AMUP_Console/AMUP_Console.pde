// Wire Master Reader
// by Nicholas Zambetti <http://www.zambetti.com>
// Demonstrates use of the Wire library
// Reads data from an I2C/TWI slave device
// Refer to the "Wire Slave Sender" example for use with this
// Created 29 March 2006

// This example code is in the public domain.
#include <Wire.h>
#include <Tlc5940.h>

#include <AMUPconfig.h>
#include <RotaryEncoder.h>
#include <AnalogSwitch.h>
#include <Switch.h>

#define CONSOLE_ID          0

int analog_switch_pin = A10;
int switch_pin_1 = A2;
int switch_pins[4] = {A4,A5,A9,A7};

#define ENCDDER_COUNT      3
#define SWITCH_COUNT       4
RotaryEncoder encoders[ENCDDER_COUNT] = {RotaryEncoder(0,0,2,4), RotaryEncoder(0,1,3,5), RotaryEncoder(0,2,18,6)};
AnalogSwitch main_vol = AnalogSwitch(3,analog_switch_pin);
Switch switches[SWITCH_COUNT] = {Switch(4, switch_pins[0]), Switch(5, switch_pins[1]), Switch(6, switch_pins[2]), Switch(7, switch_pins[3])}; 


void setup() {
  Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(57600);  // start serial for output
  
  attachInterrupt(encoders[0].get_interrupt_pin(), encoder0Event, CHANGE);
  attachInterrupt(encoders[1].get_interrupt_pin(), encoder1Event, CHANGE);
  attachInterrupt(encoders[2].get_interrupt_pin(), encoder2Event, CHANGE);
  
  for(int i = 0; i < SWITCH_COUNT; i++) {
      switches[i].invertSwitch(true); 
  }
}

void loop() {
  Serial.print("A6: ");
  Serial.print(digitalRead(A6));
  Serial.print(" A7: ");
  Serial.print(digitalRead(A7));
  Serial.print(" A8: ");
  Serial.print(digitalRead(A8));
  Serial.print(" A9: ");
  Serial.print(digitalRead(A9));
  Serial.print(" A10: ");
  Serial.print(digitalRead(A10));
  Serial.print(" A11: ");
  Serial.print(digitalRead(A11));
  Serial.print(" A12: ");
  Serial.println(digitalRead(A12));
  receiveI2C(20);
  receiveI2C(21);
//  receiveI2C(22);
//  receiveI2C(23);
  for (int i = 0; i < 3; i++) {
      if (encoders[i].available()) encoders[i].get_print_state();
  }
  if (main_vol.hasStateChanged()) {
      Serial.print(CONSOLE_ID);
      Serial.print(" ");
      Serial.print(main_vol.ID);
      Serial.print(" ");
      Serial.println(main_vol.getState()); 
  }
    for(int i = 0; i < 4; i++) {
      if(switches[i].hasStateChanged()) {
          Serial.print(CONSOLE_ID);
          Serial.print(" ");
          Serial.print(switches[i].ID);
          Serial.print(" ");
          Serial.println(switches[i].getState()); 
      } 
  }



  

}

void encoder0Event() { encoders[0].event(); }
void encoder1Event() { encoders[1].event(); }
void encoder2Event() { encoders[2].event(); }

