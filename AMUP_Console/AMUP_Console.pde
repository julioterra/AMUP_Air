#include <Wire.h>
#include <Tlc5940.h>

#include <AMUPconfig.h>
#include <RotaryEncoder.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <RGBButtonMatrix.h>

#define MIDI_GLOBAL_CHANNEL    191 // midi cc channel 16
#define MIDI_MSG_END           255
#define ENCDDER_COUNT          3
#define SWITCH_COUNT           4
#define RGB_BUTTON_COUNT       4

int const global_midi_channel = 191;
int analog_switch_pin = A10;
int rot_enc_int_pin[ENCDDER_COUNT] = {2,3,18};
int rot_enc_sec_pin[ENCDDER_COUNT] = {4,5,6};
int switch_pins[SWITCH_COUNT] = {A5,A4,A9,A8};
int button_input_pins[RGB_BUTTON_COUNT] = {A0,A1,A2,A3};
int button_led_pins[RGB_BUTTON_COUNT] = {10,11,12,13};
int rgb_pins[] = {7,8,9};

long i2c_last_request_time = 0;
int i2c_request_interval = 0;

AnalogSwitch main_vol = AnalogSwitch(0,analog_switch_pin);

RotaryEncoder encoders[ENCDDER_COUNT] = {RotaryEncoder(1,rot_enc_int_pin[0],rot_enc_sec_pin[0]), 
                                         RotaryEncoder(2,rot_enc_int_pin[1],rot_enc_sec_pin[1]), 
                                         RotaryEncoder(3,rot_enc_int_pin[2],rot_enc_sec_pin[2])};

Switch switches[SWITCH_COUNT] = {Switch(4, switch_pins[0]), 
                                 Switch(5, switch_pins[1]), 
                                 Switch(10, switch_pins[2]), 
                                 Switch(11, switch_pins[3])};

RGBButtonMatrix buttons[RGB_BUTTON_COUNT] = {RGBButtonMatrix(6, button_input_pins[0],4), 
                                             RGBButtonMatrix(7, button_input_pins[1],4), 
                                             RGBButtonMatrix(8, button_input_pins[2],4), 
                                             RGBButtonMatrix(9, button_input_pins[3],4)}; 

// I2C TRANSMIT MESSAGE VARIABLES
boolean midi_transmit = false;
int midi_transmit_message[3];
int midi_transmit_index = 0;

char midi_channel[3];
int midi_channel_index = 0;
char midi_cc[3];
int midi_cc_index = 0;
char midi_val[3];
int midi_val_index = 0;

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
  makeI2Crequests();
  read_and_send_console_data();
  midi_input();
}

void encoder0Event() { encoders[0].event(); }
void encoder1Event() { encoders[1].event(); }
void encoder2Event() { encoders[2].event(); }


