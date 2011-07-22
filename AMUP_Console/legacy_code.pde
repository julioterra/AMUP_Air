//void readI2C_sendSerial(byte _adj_device_number) {
//    bool new_wire_data = false;    
//    if (Wire.available() > 1) {
//        char c = Wire.receive();  
//
//        if(c >= '0' && c <= '9') {
//          new_wire_data = true; 
//          Serial.print(_adj_device_number);
//          Serial.print(" ");
//          Serial.print(c);
//        }
//
//        while(Wire.available()) { 
//            char c = Wire.receive();  
//            if (new_wire_data) {
//                if ((c >= '0' && c <= '9')) Serial.print(c);
//                else if (c == ' ' || c == ';') Serial.print(c);
//                if (!Wire.available()) Serial.println();
//            }
//        }  
//    } 
//}
//
//void sendI2C_str(int device_number, char* _message) {
//    char temp_time[20];
//    itoa(millis(), temp_time, 10);
//    Wire.beginTransmission(device_number); // transmit to device #4
//    Wire.send(temp_time);        // sends five bytes
//    Wire.send(" - ");        // sends five bytes
//    Wire.send(_message);        // sends five bytes
//    Wire.endTransmission();    // stop transmitting
//}
