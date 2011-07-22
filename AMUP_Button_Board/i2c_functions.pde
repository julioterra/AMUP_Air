void requestEvent() {
  send_bytes();
}

void send_bytes() {
   Wire.send(i2c_transmit_byte_message, I2C_TRANSMIT_MSG_SIZE);
   reset_i2c_message_byte(); 
}

int const msg_size = 3;

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany) {
  while(1 < Wire.available()) {        // loop through all but the last
        byte new_msg [msg_size] = {0,0};
        bool read_msg = false;
        int msg_index = 0;
        
        while(Wire.available()) { 
            byte new_byte = Wire.receive();  
  
            // If this is a message start byte
            if (int(new_byte) > 127) {
              read_msg = true;
              msg_index = 1;
              
            }
            // if a new_msg has been initiated but not fully read then read it
            else if (read_msg == true  && msg_index < msg_size) {
                new_msg[msg_index] = new_byte;
                msg_index++; 

                // if message has been fully read then set new_msg to false
                if (msg_index >= msg_size) {
                     read_msg = false; 
                     msg_index++; 
                     route_event(new_msg);
                }
            } 
        }
    }
}

void route_event(byte* midi_msg) {
//    for (int i = 0; i < msg_size; i++) {
//      Serial.print(int(midi_msg[i]));
//      Serial.print(", ");
//    }
//    Serial.println();

    int cc_number = int(midi_msg[1]);
    if (cc_number >= midi_rgb_switch_start && cc_number <= (midi_rgb_switch_start+midi_rgb_switch_length)) {
        for (int i = 0; i < midi_rgb_switch_length; i++) {
            if (cc_number == rgb_buttons[i].ID) {
                rgb_buttons[i].set_current_led_state(int(midi_msg[2]));
                break;  
            }         
        }
    }
}
