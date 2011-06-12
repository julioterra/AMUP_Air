void receiveI2C(int device_number) {
    Wire.requestFrom(device_number, TRANSMIT_MSG_SIZE);    // request 6 bytes from slave device #2  
    
    if (Wire.available() > 1) {
      Serial.print(device_number);
      Serial.print(":");
    } 

    while(Wire.available())     // slave may send less than requested
    { 
        char c = Wire.receive();  // receive a byte as character
        Serial.print(c);          // print the character
        if (Wire.available() <= 0) Serial.println();
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
