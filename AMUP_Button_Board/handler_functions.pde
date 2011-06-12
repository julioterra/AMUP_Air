void handle_rgb_buttons() {
    for (int i = 0; i < inputDigitalRGB; i++) {
        prep_mux(i);
        if (rgb_buttons[i].hasStateChanged()) {
//            new_data[i] = rgb_buttons[i].getState();
//            transmit = true;  
            add_to_message(i, rgb_buttons[i].getState());
        }
    }
    Tlc.update();
}

void handle_switches() {
    for (int i = 0; i < inputDigital; i++) {
      prep_mux(inputOffsetDigital+i);
        if (switches[i].hasStateChanged()) {
            int new_reading = switches[i].getState();
            add_to_message(inputOffsetDigital+i, new_reading);
//            new_data[inputOffsetDigital+i] = switches[i].getState();          
//            transmit = true;
            if (i == 1 && new_reading > 0) Serial.print(lock_on_char);
            else if (i == 1) Serial.print(lock_off_char);
        }
    }
}


void handle_analog_switches() {
    for (int i = 0; i < inputAnalog; i++) {
        prep_mux(inputOffsetAnalog+i);
        if (analog_switches[i].hasStateChanged()) {
//            new_data[inputOffsetAnalog+i] = analog_switches[i].getState();
//            transmit = true;
            add_to_message(inputOffsetAnalog+i, analog_switches[i].getState());
        }
    }
}


void handle_serial_input () {
    if (Serial.available()) {
        char new_serial = Serial.read();
        
//        Serial.print("Serial Available: ");
//        Serial.print(new_serial);
//        Serial.print(" message size ");
//        Serial.println(serial_message_counter);
//        Serial.print(" length ");
//        Serial.println(strlen(message));
        
//        if (new_serial == 'd' || new_serial == 'D') {
//            for (int i = 0; i < inputDigitalRGB; i++) rgb_buttons[i].debugToggle(); 
//        }
        
        if (new_serial >= '0' && new_serial <= '9') {
            serial_message[serial_message_counter] = new_serial;
            serial_last_received = millis();
            serial_message_counter++;
            
        } 
        
        // if message from proximity sensor is too long, then throw it out
        else if (serial_message_counter >= serial_max_length) 
            reset_serial_message();  
            
        else if ((new_serial == '\r' || new_serial == '\n' || new_serial == ';') && serial_message_counter > 0) {
//            new_data[inputOffsetAir] = int(serial_message);
            add_to_message(inputOffsetAir, int(serial_message));
            transmit = true; 
            reset_serial_message();          
        } 
        
    }
    
    // if too much time has passed since data was received then throw it out
    if (millis() - serial_last_received > serial_receive_interval && serial_message_counter > 0) {
        reset_serial_message();
    }
}

void reset_serial_message() {
  if (debug_code) Serial.print("Resetting serial message");

  for (int i = 0; i < serial_message_counter; i++) serial_message[i] = '\0';
  serial_message_counter = 0;
}

