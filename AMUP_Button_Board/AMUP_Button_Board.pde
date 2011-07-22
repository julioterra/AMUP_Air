#include <Wire.h>
#include <Tlc5940.h>
#include <tlc_config.h>

#include <AMUPconfig.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <RGBButtonTLC.h>

#define midi_air_start            0
#define midi_air_length           1
#define midi_switch_start         midi_air_start+ midi_air_length
#define midi_switch_length        2
#define midi_analog_start         midi_switch_start + midi_switch_length 
#define midi_analog_length        6
#define midi_rgb_switch_start     midi_analog_start + midi_analog_length
#define midi_rgb_switch_length    8
#define midi_total                midi_rgb_switch_start + midi_rgb_switch_length

#define mux_analog                0
#define mux_analog                10
#define mux_switch                8


#define MIDI_MSG_START           255
#define MIDI_MSG_BLANK           254

const int muxControlPin[4] = {4,5,6,7};
const int muxPosition[4][16] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
                                0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1,
                                0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1};  

int pad_id = -1;         // holds the id number for the button pad, used for i2c communications and data identification

// I2C TRANSMIT MESSAGE VARIABLES
//boolean i2c_transmit = false;
//char i2c_transmit_message[I2C_TRANSMIT_MSG_SIZE];
//int i2c_transmit_index = 0;

boolean i2c_transmit_byte = false;
byte i2c_transmit_byte_message[I2C_TRANSMIT_MSG_SIZE];
int i2c_transmit_byte_index = 0;


// SERIAL RECEIVE MESSAGE VARIABLES
char serial_receive_message[AIR_SERIAL_MSG_SIZE];
int serial_receive_message_counter = 0;   // holds the current position on the 
long serial_last_received = 0;            // holds when a partial serial message was last received 
int serial_receive_interval = 500;        // holds how long to hold a partial message before discarting the contents

Switch switches[midi_switch_length] = {Switch(2, A3), 
                                 Switch(1, A3)}; 

RGBButtonTLC rgb_buttons[midi_rgb_switch_length] = {RGBButtonTLC(12, A3, 5),
                                             RGBButtonTLC(11, A3, 8),
                                             RGBButtonTLC(10, A3, 8),
                                             RGBButtonTLC(9, A3, 8),
                                             RGBButtonTLC(13, A3, 8),
                                             RGBButtonTLC(14, A3, 8),
                                             RGBButtonTLC(15, A3, 8),
                                             RGBButtonTLC(16, A3, 8)};

AnalogSwitch analog_switches[midi_analog_length] = {AnalogSwitch(8, A3),
                                             AnalogSwitch(7, A3),
                                             AnalogSwitch(6, A3),
                                             AnalogSwitch(5, A3),
                                             AnalogSwitch(4, A3),
                                             AnalogSwitch(3, A3)};

void setup() {
  Serial.begin(57600);
  
  register_mux_and_led_pins();        // register the pins for the multiplexer and led driver
  register_rgb_button_states();       // register RGB button states and leds 
  request_id_number();                // register id number of the button pad, via user input
  request_air_confirmation();         // register id number of the button pad, via user input

  Wire.begin(pad_id);                 // initiate the pad connection to console based on button input
  Wire.onRequest(requestEvent);       // register callback method for request events
  Wire.onReceive(receiveEvent);       // register callback method for receive event
}


void loop() { 
    handle_serial_input();
    handle_rgb_buttons();
    handle_switches();
    handle_analog_switches();
}

