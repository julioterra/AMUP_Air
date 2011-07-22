void read_i2c_sensors() {
    if (millis() - i2c_last_request_time > i2c_request_interval) {
        receiveI2C(20);
        receiveI2C(21);
        i2c_last_request_time = millis();
    }
}

void receiveI2C(int device_number) {
    int adj_device_number = device_number + 157;             // midi cc channel 1 is number 177, midi cc channel 2 is number 178
    Wire.requestFrom(device_number, I2C_RECEIVE_MSG_SIZE);    // request 6 bytes from slave device #2  
    readI2C_sendMIDI(adj_device_number);
}

void readI2C_sendMIDI(byte _adj_device_number) {
    if (Wire.available() > 1) {
        bool read_msg = false;
        int msg_index = 0;
        while(Wire.available()) { 
          byte c = Wire.receive();  

          // If this is a message start byte
          if (c == byte(MIDI_MSG_END)) {
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
             msg_index++; 
          } 
          // if message has been fully read then set new_msg to false
          else if (msg_index == 2) {
             read_msg = false; 
             msg_index++; 
          }
        }
    }   
}


