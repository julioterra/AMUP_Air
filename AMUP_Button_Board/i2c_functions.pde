void requestEvent() {
   if (i2c_transmit) {
       Wire.send(i2c_transmit_message);           // send the data via wire
       if (debug_code) {
           Serial.print("transmitData(), message sent: ");
           Serial.println(i2c_transmit_message);
       }
   }
   else {
       char no_data_msg[] = {"no data"};
       add_string_to_string(no_data_msg, i2c_transmit_message, 0);
       Wire.send(i2c_transmit_message);
   }
   reset_i2c_message();
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany)
{
  while(1 < Wire.available()) // loop through all but the last
  {
    char c = Wire.receive(); // receive byte as a character
    Serial.print(c);         // print the character
  }
  int x = Wire.receive();    // receive byte as an integer
  Serial.println(x);         // print the integer
}


