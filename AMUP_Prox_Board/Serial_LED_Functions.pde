void handle_serial_input () {
    if (Serial.available()) {
        char new_serial = Serial.read();

       if (new_serial == AIR_CONNECT_REQUEST_CHAR) {
          connection_started = true; 
          Serial.print(AIR_CONNECT_ACCEPT_CHAR);
          Serial.println(": connection to air sensor established.");
       }

       else if (new_serial == AIR_LOCK_ON_CHAR) {
              lock_on = true; 
              current_color = LOCK_ON_COLOR;
              update_leds(previous_vol);
//             Serial.println("lock on ");
//             Serial.print(current_color);

       } 
       else if (new_serial == AIR_LOCK_OFF_CHAR){
              lock_on = false;
              current_color = LOCK_OFF_COLOR;
              update_leds(previous_vol);
              air_sensor.reset();
//             Serial.println("lock off ");
//             Serial.print(current_color);
        }
    }
}

unsigned long last_led_update = 0;
long update_interval = 20;

void sense_and_send() {
     if (connection_started && !lock_on) {
       // read data and print to serial if appropriate 
        if (air_sensor.available()) {
            current_vol = int(air_sensor.get_print_byte_state());
        }

        // if volume has changed then update the leds
        if (current_vol != -1 && ((millis() - last_led_update) > update_interval)) {
            update_leds(int(current_vol));
            previous_vol = current_vol; 
            last_led_update = millis();
        }
    }
}

void update_leds(int volume) {
//             Serial.println("update light ");
//             Serial.println(current_color);
   Tlc.clear();
   for (int i = 0; i < volume/LED_VOL_CONVERT; i ++) {
        if (i == volume/LED_VOL_CONVERT-1) Tlc.set(rgbLED[i][current_color], volume/127*LED_MAX_BRIGHT_TLC);     
        Tlc.set(rgbLED[i][current_color], LED_MAX_BRIGHT_TLC);    
   }
   Tlc.update();   
}
