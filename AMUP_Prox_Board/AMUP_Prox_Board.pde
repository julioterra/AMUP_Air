#include <HighpassFilter.h>
#include <AMUP_Air_Sensor.h>
#include <Tlc5940.h>


// CONSTANT DEFINITIONS
#define R                0
#define G                1
#define B                2
#define ledCount         10
#define rgbCount         3
#define ledVolConverter  12
#define maxLEDbright     1000

// ARDUINO PIN DEFINIONS
#define airPin          A0
// IMPORTANT NOTE: five digital pins are used to control the LED drivers (TLC 5940); pins 3, 9, 10, 11, 13.
// Communication uses a synchronized serial protocol

// LED PIN DEFINITION (TLC 5940)
int const rgbLED [ledCount][rgbCount] = {28,30,29,
                                         25,27,26,
                                         22,24,23,
                                         19,21,20,
                                         16,18,17,
                                         12,14,13,
                                         9,11,10,
                                         6,8,7,
                                         3,5,4,
                                         0,2,1};
                                       

// LED STATUS VARIABLES
int currentLED = 0;
int currentRGB = 0;
long RGBupdateInterval = 1000;
long lastRGBupdate;
AMUP_Air_Sensor air_sensor = AMUP_Air_Sensor(airPin);

int current_vol = 0;
int previous_vol = 0;
int current_color = R;
boolean connection_started = false;
boolean lock_on = false;

void setup() {
  Tlc.init(0);
  Serial.begin(57600);
  lastRGBupdate = millis();
  Serial.println("waiting for initialization");
  connection_started = true;
}

void loop() {
    handle_serial_input();
    sense_and_send();
}

void handle_serial_input () {
    if (Serial.available()) {
        char new_serial = Serial.read();
        if (new_serial == 's' || new_serial == 'S') {
          connection_started = true; 
          Serial.print('s');
        }

        else if (new_serial == 'k') {
            if (!lock_on) {
              lock_on = true; 
              current_color = B;
              update_leds(previous_vol);
              Serial.println("lock switched to true");
            }
            else {
              lock_on = false;
              current_color = R;
              update_leds(previous_vol);
              air_sensor.reset();
              Serial.println("lock switched to false");
            }
        }
    }
}

void sense_and_send() {
     if (connection_started && !lock_on) {
        current_vol = air_sensor.play();
        if (current_vol != previous_vol && current_vol != -1) {
            previous_vol = current_vol; 
            update_leds(current_vol);
        }
    }
}


void read_data() {
        int new_data = analogRead(airPin);        
        Serial.print(" - DATA: ");
        Serial.println(new_data);
}

void update_leds(int volume) {
   Tlc.clear();
//   delayMicroseconds(400);
   for (int i = 0; i < volume/ledVolConverter; i ++) {
        if (i == volume/ledVolConverter-1) Tlc.set(rgbLED[i][current_color], volume/127*maxLEDbright);     
         Tlc.set(rgbLED[i][current_color], maxLEDbright);    
   }
   Tlc.update();   
}


void light_test() {
    if (millis() - lastRGBupdate > RGBupdateInterval) {
        Tlc.clear();
        Tlc.set(rgbLED[currentLED][currentRGB], maxLEDbright);
        Tlc.update();   
        lastRGBupdate = millis();
        currentRGB++;  
        if (currentRGB >= rgbCount) {
            currentRGB = 0;
            currentLED++;            
            if (currentLED >= ledCount) currentLED = 0;
        }
    }
}

