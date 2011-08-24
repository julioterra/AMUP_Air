void read_i2c_sensors() {
    if (millis() - i2c_last_request_time > i2c_request_interval) {
        receiveI2C(20);
        receiveI2C(21);
        i2c_last_request_time = millis();
    }
}

void receiveI2C(int device_number) {
    int adj_device_number = device_number + midi_cc_channel_offset;             // midi cc channel 1 is number 176, midi cc channel 2 is number 177
    Wire.requestFrom(device_number, I2C_RECEIVE_MSG_SIZE);                       
    readI2C_sendMIDI(adj_device_number);
}

void readI2C_sendMIDI(byte _adj_device_number) {
    if (Wire.available() > 1) {
        bool mod_msg = false;
        bool read_msg = false;
        int msg_index = 0;
        while(Wire.available()) { 
          byte c = Wire.receive();  

          // If this is a message start byte
          if (c == byte(MIDI_MSG_START)) {
            read_msg = true;
            msg_index = 0;
//            Serial.println();
//            Serial.print(int(_adj_device_number));
            Serial.write(_adj_device_number);
          }
          // if a new_msg has been initiated but not fully read then read it
          else if (read_msg == true  && msg_index < 2) {
//             Serial.print(" - ");
//             Serial.print(int(c));
             Serial.write(c);
             if (msg_index == 0 && c == BUT_PAN_MODE_BUTTON) mod_msg = true;
             msg_index++; 
          } 
          // if message has been fully read then set new_msg to false
          else if (msg_index == 2) {
             if (mod_msg) {
                Serial.write(_adj_device_number);
                Serial.write(byte(127));
                Serial.write(byte(1));
                mod_msg = false;
             }
             read_msg = false; 
             msg_index = 0; 
          }
        }
    }   
}


