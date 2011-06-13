
void receiveI2C(int device_number) {
    int adj_device_number = device_number - 19;
    Wire.requestFrom(device_number, I2C_RECEIVE_MSG_SIZE);    // request 6 bytes from slave device #2  
    bool  new_wire_data = false;
    
    if (Wire.available() > 1) {
        char c = Wire.receive();  

        if(c >= '0' && c <= '9') {
          new_wire_data = true; 
          Serial.print(adj_device_number);
          Serial.print(" ");
          Serial.print(c);
        }

//
// UPDATE CONSIDERATION: TEST NOT READING WIRE DATA IF IT IS NOT VALID
//
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

void sendI2C(int device_number, char* _message) {
    char temp_time[20];
    itoa(millis(), temp_time, 10);

    Wire.beginTransmission(device_number); // transmit to device #4
    Wire.send(temp_time);        // sends five bytes
    Wire.send(" - ");        // sends five bytes
    Wire.send(_message);        // sends five bytes
    Wire.endTransmission();    // stop transmitting
}
