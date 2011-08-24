#include <Wire.h>
#include <Tlc5940.h>
#include <AMUPconfig.h>
#include <RotaryEncoder.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <RGBButtonMatrix.h>

#define MIDI_GLOBAL_CHANNEL    191 // midi cc channel 16
#define MIDI_MSG_START           255
#define ENCDDER_COUNT          3
#define SWITCH_COUNT           4
#define RGB_BUTTON_COUNT       4
#define RGB_BUTTON_START       6


byte const BUT_PAN_MODE_BUTTON = byte(2);
int const analog_switch_pin = A10;
int const rot_enc_int_pin[ENCDDER_COUNT] = {18,3,2};
int const rot_enc_sec_pin[ENCDDER_COUNT] = {6,5,4};
int const switch_pins[SWITCH_COUNT] = {A5,A4,A9,A8};
int const button_input_pins[RGB_BUTTON_COUNT] = {A0,A1,A2,A3};
int const button_led_pins[RGB_BUTTON_COUNT] = {10,11,12,13};
int const rgb_pins[] = {7,8,9};
int const midi_cc_channel_offset = 156;

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

RGBButtonMatrix rgb_buttons[RGB_BUTTON_COUNT] = {RGBButtonMatrix(6, button_input_pins[0],8), 
                                             RGBButtonMatrix(7, button_input_pins[1],8), 
                                             RGBButtonMatrix(8, button_input_pins[2],8), 
                                             RGBButtonMatrix(9, button_input_pins[3],8)}; 


// ** SET_UP FUNCTIOM **
// initialize all switches, sensors, and communication channels
void setup() {
    Wire.begin();        // join i2c bus (address optional for master)
    Serial.begin(57600);  // start serial for output
    
    // initialize encoders
    attachInterrupt(encoders[0].get_interrupt_pin(), encoder0Event, CHANGE);
    attachInterrupt(encoders[1].get_interrupt_pin(), encoder1Event, CHANGE);
    attachInterrupt(encoders[2].get_interrupt_pin(), encoder2Event, CHANGE);
    
    // initialize switches
    for(int i = 0; i < SWITCH_COUNT; i++) {
        switches[i].invert_switch(true); 
    }
  
    // initialize rgb buttons and states
    for(int i = 0; i < RGB_BUTTON_COUNT; i++) {
        rgb_buttons[i].set_led_pins(button_led_pins[i], rgb_pins[R], rgb_pins[G], rgb_pins[B]);
        rgb_buttons[i].set_midi_control(true); 
        rgb_buttons[i].invert_switch(true); 
        rgb_buttons[i].set_led_state(0, 0, 0, 0);
        rgb_buttons[i].set_led_state(1, 1, 0, 1);
        rgb_buttons[i].set_led_state(2, 0, 1, 1);
        rgb_buttons[i].set_led_state(3, 1, 1, 0);
        rgb_buttons[i].set_led_state(4, 1, 0, 0);
        rgb_buttons[i].set_led_state(5, 0, 1, 0);
        rgb_buttons[i].set_led_state(6, 0, 0, 1);
        rgb_buttons[i].set_led_state(7, 0, 0, 0);
        delay(400);
    }
}

// ** LOOP FUNCTIOM **
// read sensors and send midi data as appropriate
void loop() {
    read_i2c_sensors();
    read_local_sensors();
    handle_midi_input();
}

// ** ENCODER CALLBACK METHODS **
// callback methods used when encoder is moved
void encoder0Event() { encoders[0].event(); }
void encoder1Event() { encoders[1].event(); }
void encoder2Event() { encoders[2].event(); }


