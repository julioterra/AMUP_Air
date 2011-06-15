
#include <Wire.h>
#include <Tlc5940.h>

#include <AMUPconfig.h>
#include <RotaryEncoder.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <RGBButtonMatrix.h>

#define CONSOLE_ID          0
#define BUTTON_COUNT        4

int analog_switch_pin = A10;
int switch_pins[4] = {A4,A5,A9,A8};
int button_input_pins[4] = {A0,A1,A2,A3};
int button_led_pins[BUTTON_COUNT] = {10,11,12,13};
int rgb_pins[] = {7,8,9};


#define ENCDDER_COUNT      3
#define SWITCH_COUNT       4
#define RGB_BUTTON_COUNT   4

RotaryEncoder encoders[ENCDDER_COUNT] = {RotaryEncoder(0,2,4), RotaryEncoder(1,3,5), RotaryEncoder(2,18,6)};
AnalogSwitch main_vol = AnalogSwitch(3,analog_switch_pin);
Switch switches[SWITCH_COUNT] = {Switch(4, switch_pins[0]), Switch(5, switch_pins[1]), Switch(6, switch_pins[2]), Switch(7, switch_pins[3])};
RGBButtonMatrix buttons[RGB_BUTTON_COUNT] = {RGBButtonMatrix(8, button_input_pins[0],4), RGBButtonMatrix(9, button_input_pins[1],4), 
                                             RGBButtonMatrix(10, button_input_pins[2],4), RGBButtonMatrix(11, button_input_pins[3],4)}; 


void setup() {
  Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(57600);  // start serial for output
  
  attachInterrupt(encoders[0].get_interrupt_pin(), encoder0Event, CHANGE);
  attachInterrupt(encoders[1].get_interrupt_pin(), encoder1Event, CHANGE);
  attachInterrupt(encoders[2].get_interrupt_pin(), encoder2Event, CHANGE);
  
  for(int i = 0; i < SWITCH_COUNT; i++) {
      switches[i].invert_switch(true); 
  }
  for(int i = 0; i < RGB_BUTTON_COUNT; i++) {
      buttons[i].set_led_pins(button_led_pins[i], rgb_pins[R], rgb_pins[G], rgb_pins[B]);
      buttons[i].invert_switch(true); 
      buttons[i].set_led_state(0, 0, 0, 0);
      buttons[i].set_led_state(1, 1, random(-1,2), random(-1,2));
      buttons[i].set_led_state(2, random(-1,2), 1, random(-1,2));
      buttons[i].set_led_state(3, random(-1,2), random(-1,2), 1);
      delay(400);
  }
}

void loop() {
  receiveI2C(20);
  receiveI2C(21);
  read_and_send_data();
}

void encoder0Event() { encoders[0].event(); }
void encoder1Event() { encoders[1].event(); }
void encoder2Event() { encoders[2].event(); }

void read_and_send_data() {
    if (main_vol.available())
        print_state(main_vol.ID, main_vol.get_state());
    for (int i = 0; i < 3; i++) 
        if (encoders[i].available()) print_state(encoders[i].ID, encoders[i].get_state());
    for(int i = 0; i < 4; i++) 
        if(switches[i].available()) print_state(switches[i].ID, switches[i].get_state());
    for(int i = 0; i < 4; i++) 
        if(buttons[i].available()) print_state(buttons[i].ID, buttons[i].get_state());
}

void print_state(int _id, float _state) {
    Serial.print(CONSOLE_ID);
    Serial.print(" ");
    Serial.print(_id);
    Serial.print(" ");
    Serial.println(_state); 
}
