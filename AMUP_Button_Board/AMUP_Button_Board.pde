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
#define transmitMessageSize   35

#define rgbCount              3
#define R                     0
#define G                     1
#define B                     2

const int muxControlPin[4] = {4,5,6,7};
const int muxPosition[4][16] = {0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
                                0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1,
                                0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1};  

int pad_id = -1;         // holds the id number for the button pad, used for i2c communications and data identification
int new_data[inputTotal];
boolean transmit = false;

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
  
  for (int i = 0; i < inputTotal; i++ ) new_data[i] = -1;

  register_mux_and_led_pins();
  register_rgb_button_states();   // register RGB button states and leds 
  request_id_number();            // register id number of the button pad, via user input
  request_air_confirmation();    // register id number of the button pad, via user input

  Wire.begin(pad_id);
  Wire.onRequest(transmitData);

}


void loop() { 
    handle_serial_input();
    handle_rgb_buttons();
    handle_switches();
    handle_analog_switches();
    transmitData();
}

void transmitData() {
   if (transmit) {
     char transmit_message[transmitMessageSize];
     for (int i = 0; i < transmitMessageSize; i++) {
       if (i < transmitMessageSize-1) transmit_message[i] = ' ';
       else transmit_message[i] = '\0';
       
     }
     int transmit_index = 0;
     for(int i = 0; i < inputTotal; i++) {
         char live_message[8] = {'\0','\0','\0','\0','\0','\0'};
         int live_message_counter = 0;
         int live_max_length = 7;
         if (new_data[i] != -1) {

             itoa(i, live_message, 10);
             int msg_len = strlen(live_message);
             for (int j = 0; j < msg_len; j++) {
                 transmit_message[transmit_index] = live_message[j];
                 transmit_index++;
                 if (j == msg_len-1) {
                     transmit_message[transmit_index] = ' ';
                     transmit_index++;
                 }
                 live_message[j] = 0;
             }

             itoa(new_data[i], live_message, 10);
             msg_len = strlen(live_message);
             for (int j = 0; j < msg_len; j++) {
                 transmit_message[transmit_index] = live_message[j];
                 transmit_index++;
                 if (j == msg_len-1) {
                     transmit_message[transmit_index] = ';';
                     transmit_index++;
                 }
             }
         }         
     }
     
     // send the data via wire
     Wire.send(transmit_message);
      
//     if (debug_code) {
         Serial.print("transmitData(), message: ");
         Serial.println(transmit_message);
//     }
     
     // reinitialize the new_data array and trasmit flag
     for(int i = 0; i < inputTotal; i++) new_data[i] = -1;
     transmit = false;

   }
}

int add_message(int number, char * source, char * destination, int counter){
     itoa(number, source, 10);
     int msg_len = strlen(source);
     for (int j = 0; j < msg_len; j++) {
         destination[counter] = source[j];
         counter++;
         if (j == msg_len-1) {
             destination[counter] = ' ';
             counter++;
         }
         source = 0;
     }
     return counter;
}

