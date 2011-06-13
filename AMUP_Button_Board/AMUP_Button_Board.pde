#include <Wire.h>
#include <Tlc5940.h>
#include <tlc_config.h>

#include <AMUPconfig.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <RGBButtonTLC.h>

#define inputDigitalRGB       8
#define inputOffsetDigital    inputDigitalRGB
#define inputDigital          2
#define inputOffsetAnalog     inputDigitalRGB + inputDigital
#define inputAnalog           6
#define inputOffsetAir        inputOffsetAnalog + inputAnalog
#define inputAir              1
#define inputTotal            inputOffsetAir + inputAir

const int muxControlPin[4] = {4,5,6,7};
const int muxPosition[4][16] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
                                0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1,
                                0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1};  

int pad_id = -1;         // holds the id number for the button pad, used for i2c communications and data identification

// I2C TRANSMIT MESSAGE VARIABLES
boolean i2c_transmit = false;
char i2c_transmit_message[I2C_TRANSMIT_MSG_SIZE];
int i2c_transmit_index = 0;

// SERIAL RECEIVE MESSAGE VARIABLES
char serial_receive_message[AIR_SERIAL_MSG_SIZE];
int serial_receive_message_counter = 0;   // holds the current position on the 
long serial_last_received = 0;            // holds when a partial serial message was last received 
int serial_receive_interval = 500;        // holds how long to hold a partial message before discarting the contents

boolean debug_code = false;

RGBButtonTLC rgb_buttons[inputDigitalRGB] = {RGBButtonTLC(0, A3, 5),RGBButtonTLC(1, A3, 5),RGBButtonTLC(2, A3, 5),
                                             RGBButtonTLC(3, A3, 5),RGBButtonTLC(4, A3, 5),RGBButtonTLC(5, A3, 5),
                                             RGBButtonTLC(6, A3, 5),RGBButtonTLC(7, A3, 5)};
Switch switches[inputDigital] = {Switch(8, A3), Switch(9, A3)}; 
AnalogSwitch analog_switches[inputAnalog] = {AnalogSwitch(10, A3),AnalogSwitch(11, A3),AnalogSwitch(12, A3),
                                             AnalogSwitch(13, A3),AnalogSwitch(14, A3),AnalogSwitch(15, A3)};

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

