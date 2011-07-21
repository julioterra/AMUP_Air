void requestEvent() {
  send_bytes();
}

void send_bytes() {
   Wire.send(i2c_transmit_byte_message, I2C_TRANSMIT_MSG_SIZE);
   reset_i2c_message_byte(); 
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany) {
    while(1 < Wire.available()) {        // loop through all but the last
        byte new_msg [2] = {0,0};
        bool read_msg = false;
        int msg_index = 0;
        
        while(Wire.available()) { 
            byte new_byte = Wire.receive();  
  
            // If this is a message start byte
            if (new_byte == byte(MIDI_MSG_START)) {
              read_msg = true;
              msg_index = 0;
              
//              Serial.println();
//              Serial.print("msg received: ");
            }
            // if a new_msg has been initiated but not fully read then read it
            else if (read_msg == true  && msg_index < 2) {
                new_msg[msg_index] = new_byte;
                msg_index++; 

//                Serial.print(" - ");
//                Serial.print(int(new_msg[msg_index-1]));

                // if message has been fully read then set new_msg to false
                if (msg_index >= 2) {
                     read_msg = false; 
                     msg_index++; 
                     route_event(new_msg);
                }
            } 
        }
    }
}

void route_event(byte* midi_msg) {
    for (int i = 0; i < 2; i++) {
      Serial.print(int(midi_msg[i]));
      Serial.print(", ");
    }
    Serial.println();
  
}
