#include <Wire.h>
#include <AnalogSwitch.h>
#include <Switch.h>
#include <Tlc5940.h>
#include <tlc_config.h>
#include <RGBButton.h>

#define inputDigitalRGB       8
#define inputOffsetDigital    inputDigitalRGB
#define inputDigital          2
#define inputOffsetAnalog     inputDigitalRGB + inputDigital
#define inputAnalog           6
#define inputOffsetAir        inputOffsetAnalog + inputAnalog
#define inputAir              1
#define inputTotal            inputOffsetAir + inputAir
#define transmitMessageSize   26

#define rgbCount              3
#define R                     0
#define G                     1
#define B                     2

const char connect_char = 'c';
const char lock_on_char = 60;
const char lock_off_char = 62;
const int muxControlPin[4] = {4,5,6,7};
const int muxPosition[4][16] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
                                0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1,
                                0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1};  

int pad_id = -1;         // holds the id number for the button pad, used for i2c communications and data identification

//int new_data[inputTotal];
boolean transmit = false;
char transmit_message[transmitMessageSize];
//char transmit_message[transmitMessageSize] = {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
//                                              ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
//                                              ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
//                                              ' ',' ',' ',' '};
int transmit_index = 0;
  

char serial_message[6] = {'\0','\0','\0','\0','\0','\0'};
int serial_message_counter = 0;
int serial_max_length = 5;
long serial_last_received = 0;
int serial_receive_interval = 500;
boolean debug_code = false;

RGBButton rgb_buttons[inputDigitalRGB] = {RGBButton(0, A3, 5),RGBButton(1, A3, 5),RGBButton(2, A3, 5),RGBButton(3, A3, 5),
                                          RGBButton(4, A3, 5),RGBButton(5, A3, 5),RGBButton(6, A3, 5),RGBButton(7, A3, 5)};
Switch switches[inputDigital] = {Switch(8, A3), Switch(9, A3)}; 
AnalogSwitch analog_switches[inputAnalog] = {AnalogSwitch(10, A3),AnalogSwitch(11, A3),AnalogSwitch(12, A3),AnalogSwitch(13, A3),
                                             AnalogSwitch(14, A3),AnalogSwitch(15, A3)};

void setup() {
  Serial.begin(57600);
  
//  for (int i = 0; i < inputTotal; i++ ) new_data[i] = -1;

  register_mux_and_led_pins();
  register_rgb_button_states();   // register RGB button states and leds 
  request_id_number();            // register id number of the button pad, via user input
  request_air_confirmation();    // register id number of the button pad, via user input

//  Wire.begin(20);
  Wire.begin(pad_id);
  Wire.onRequest(requestEvent);
  Wire.onReceive(receiveEvent); // register event


}


void loop() { 
    handle_serial_input();
    handle_rgb_buttons();
    handle_switches();
    handle_analog_switches();
}

void requestEvent() {
   if (transmit) {
     // send the data via wire
     Wire.send(transmit_message);
      
     if (debug_code) {
         Serial.print("transmitData(), message: ");
         Serial.println(transmit_message);
     }
     reset_message();
   }
   else {
         char no_data_msg[transmitMessageSize] = {"no data                  "};
         Wire.send(no_data_msg);
   }
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany)
{
  while(1 < Wire.available()) // loop through all but the last
  {
    char c = Wire.receive(); // receive byte as a character
    Serial.print(c);         // print the character
  }
  int x = Wire.receive();    // receive byte as an integer
  Serial.println(x);         // print the integer
}


