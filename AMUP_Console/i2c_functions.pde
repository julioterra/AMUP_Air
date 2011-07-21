void makeI2Crequests() {
    if (millis() - i2c_last_request_time > i2c_request_interval) {
        receiveI2C(20);
        receiveI2C(21);
        i2c_last_request_time = millis();
    }
}


void receiveI2C(int device_number) {
    int adj_device_number = device_number + 157;             // midi cc channel 1 is number 177, midi cc channel 2 is number 178
    Wire.requestFrom(device_number, I2C_RECEIVE_MSG_SIZE);    // request 6 bytes from slave device #2  
//    readI2C_sendSerial(adj_device_number);
    readI2C_sendMIDI(adj_device_number);
}

void readI2C_sendSerial(byte _adj_device_number) {
    bool new_wire_data = false;    
    if (Wire.available() > 1) {
        char c = Wire.receive();  

        if(c >= '0' && c <= '9') {
          new_wire_data = true; 
          Serial.print(_adj_device_number);
          Serial.print(" ");
          Serial.print(c);
        }

        while(Wire.available()) { 
            char c = Wire.receive();  
            if (new_wire_data) {
                if ((c >= '0' && c <= '9')) Serial.print(c);
                else if (c == ' ' || c == ';') Serial.print(c);
                if (!Wire.available()) Serial.println();
            }
        }  
    } 
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
            Serial.println();
            Serial.print(int(_adj_device_number));
//            Serial.write(_adj_device_number);
          }
          // if a new_msg has been initiated but not fully read then read it
          else if (read_msg == true  && msg_index < 2) {
             Serial.print(" - ");
             Serial.print(int(c));
//             Serial.write(c);
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

void sendI2C_MIDI(int device_number, byte cc, byte val) {
    int adj_device_number = device_number - 157;
    Wire.beginTransmission(adj_device_number); // transmit to device #4
    Wire.send(byte(255));          // sends end byte
    Wire.send(cc);           // sends cc number
    Wire.send(val);          // sends cc value
    Wire.endTransmission();  // stop transmitting
}

void sendI2C_MIDI(byte* new_msg) {
    int adj_device_number = int(new_msg[0]) - 157;
    Wire.beginTransmission(adj_device_number); // transmit to device #4
    Wire.send(byte(255));          // sends end byte
    Wire.send(byte(new_msg[1]));           // sends cc number
    Wire.send(byte(new_msg[2]));          // sends cc value
    Wire.endTransmission();  // stop transmitting

    Serial.println();
    Serial.print("send MIDI to panel");
    Serial.print(adj_device_number);
    Serial.print(" - ");
    Serial.print(int(new_msg[1]));
    Serial.print(" - ");
    Serial.println(int(new_msg[2]));
}


void sendI2C_str(int device_number, char* _message) {
    char temp_time[20];
    itoa(millis(), temp_time, 10);
    Wire.beginTransmission(device_number); // transmit to device #4
    Wire.send(temp_time);        // sends five bytes
    Wire.send(" - ");        // sends five bytes
    Wire.send(_message);        // sends five bytes
    Wire.endTransmission();    // stop transmitting
}
