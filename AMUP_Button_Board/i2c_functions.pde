void requestEvent() {
//  send_string();
  send_bytes();
}

void send_bytes() {
   Wire.send(i2c_transmit_byte_message, I2C_TRANSMIT_MSG_SIZE);
  
//       Serial.print("transmitDataByte(), message sent: ");
//       for (int i = 0; i < I2C_TRANSMIT_MSG_SIZE; i++) { 
//         Serial.print(int(i2c_transmit_byte_message[i]));
//         Serial.print(",");
//       }
//       Serial.println();

   reset_i2c_message_byte(); 
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany) {
  while(1 < Wire.available()) {        // loop through all but the last
      byte new_byte = Wire.receive();  // receive byte as a character
  }
}

