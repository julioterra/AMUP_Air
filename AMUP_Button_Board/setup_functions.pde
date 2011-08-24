void register_mux_and_led_pins() {
  for (int i = 0; i < 4; i++) 
      pinMode(muxControlPin[i], OUTPUT);
  Tlc.init(0);
}

void register_rgb_button_states() {
  int switchRGB [midi_rgb_switch_length][RGB_COUNT] = {2,1,0,      
                                                5,4,3,        
                                                8,7,6,      
                                                11,10,9,    
                                                16,17,18,   
                                                19,20,21,    
                                                22,23,24,    
                                                25,26,27};
                                                   
  for (int i = 0; i < midi_rgb_switch_length; i++) {
      rgb_buttons[i].set_midi_control(true); 
      rgb_buttons[i].set_led_pins(switchRGB[i][R], switchRGB[i][G], switchRGB[i][B]); 
      rgb_buttons[i].set_led_state(0, 0,0,0);
      rgb_buttons[i].set_led_state(1, 2000, 0, 2000);
      rgb_buttons[i].set_led_state(2, 0, 2000, 2000);
      rgb_buttons[i].set_led_state(3, 2000, 2000, 0);
      rgb_buttons[i].set_led_state(4, 2500, 0, 0);
      rgb_buttons[i].set_led_state(5, 0, 2500, 0);
      rgb_buttons[i].set_led_state(6, 0, 0, 2500);
      rgb_buttons[i].set_led_state(7, 1500,1500,1500);
  }
}

void request_id_number() {
  long last_change = millis();
  int change_interval = 100;
  int current_led = 0;

  while (pad_id == -1) {

     // control LED light blinking
     if (millis() - last_change > change_interval) {
          Tlc.clear();
          rgb_buttons[current_led].set_current_led_state(1);
          rgb_buttons[current_led].turn_on_leds();
          rgb_buttons[current_led].update_leds();
          Tlc.update();

          last_change = millis();
          current_led++;
          if (current_led > 7) current_led = 0; 
      }

      // read input from pad to determine ID number of this button pad
      for (int i = 0; i < midi_rgb_switch_length; i++) {
          prep_mux(i);
          if (rgb_buttons[i].available()) {
            if (i == 3 || i == 4) pad_id = 20;
            else if (i == 2 || i == 5) pad_id = 21;
            else if (i == 1 || i == 6) pad_id = 20;
            else if (i == 0 || i == 7) pad_id = 21;
          }
      }
  }
  
}

void request_air_confirmation() {
    long last_change = millis();
    int change_interval = 100;
    int current_led = 7;
    char new_serial = '\0';
//    reset_serial_receive_message();
    
    while (new_serial != AIR_CONNECT_ACCEPT_CHAR) {
       
        // scroll LED lights to request input from user and via serial, until input is received
       if (millis() - last_change > change_interval) {
            Tlc.clear();
            rgb_buttons[current_led].turn_on_leds();
            rgb_buttons[current_led].update_leds();

            Tlc.update();
            
            last_change = millis();
            current_led--;
            if (current_led < 0) current_led = 7; 
            Serial.println(AIR_CONNECT_REQUEST_CHAR);
            prep_mux(8);
            if (switches[1].available()) new_serial = AIR_CONNECT_ACCEPT_CHAR;

        }
  
        if (Serial.available()) new_serial = Serial.read();  
    }
    
    // blink the led lights on the button panel to demonstrate that pad has been initialized
    int notify_counter = 0;
    change_interval = 100;
    while (notify_counter < 10) {
       if (millis() - last_change > change_interval) {
          Tlc.clear();
          if (notify_counter % 2 == 1) {
              for (int i = 0; i < 8; i++) {
                rgb_buttons[i].turn_on_leds(0,500,0);
                rgb_buttons[i].update_leds();
              }
          } else {
              for (int i = 0; i < 8; i++) {
                rgb_buttons[i].turn_off_leds();
                rgb_buttons[i].update_leds();
              }
          }
          Tlc.update();

          last_change = millis();
          notify_counter++;
        }        
    }

    // turn on all led lights for the current button states
    for (int i = 0; i < midi_rgb_switch_length; i++) {
      rgb_buttons[i].set_current_led_state(0);
      rgb_buttons[i].turn_on_leds();
    }
    Tlc.update();
}

void prep_mux(int i) {
    digitalWrite(muxControlPin[0], muxPosition[0][i]);    
    digitalWrite(muxControlPin[1], muxPosition[1][i]);    
    digitalWrite(muxControlPin[2], muxPosition[2][i]);    
    digitalWrite(muxControlPin[3], muxPosition[3][i]);    
}
