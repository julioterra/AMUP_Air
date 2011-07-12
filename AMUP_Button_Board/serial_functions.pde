void handle_serial_input () {
    if (Serial.available()) {
        char new_serial = Serial.read();
        
        if (new_serial >= '0' && new_serial <= '9') {
            serial_receive_message[serial_receive_message_counter] = new_serial;
            serial_last_received = millis();
            serial_receive_message_counter++;
        } 
        else if ((new_serial == '\r' || new_serial == '\n' || new_serial == ';') && serial_receive_message_counter > 0) {
            add_to_i2c_message(inputOffsetAir, atoi(serial_receive_message));
            i2c_transmit = true; 
            reset_serial_receive_message();          
        } 

        // if message from proximity sensor is too long, then throw it out
        if (serial_receive_message_counter >= AIR_SERIAL_MSG_SIZE-1) {
            reset_serial_receive_message();  
        }
    }
    
    // if too much time has passed since data was received then throw it out
    if (millis() - serial_last_received > serial_receive_interval && serial_receive_message_counter > 0) {
        reset_serial_receive_message();
    }
}

void reset_serial_receive_message() {
    if (debug_code) Serial.print("Resetting serial message");
    for (int i = 0; i < AIR_SERIAL_MSG_SIZE; i++) serial_receive_message[i] = '\0';
    serial_receive_message_counter = 0;
}

