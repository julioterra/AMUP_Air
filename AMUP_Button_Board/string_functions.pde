//int add_number_to_string(int number, char * destination, int counter){
//     char live_message[12];
//     itoa(number, live_message, 10);
//     int msg_len = strlen(live_message);
//     for (int j = 0; j < msg_len; j++) {
//         destination[counter] = live_message[j];
//         counter++;
//     }
//     return counter;
//}
//
//int add_string_to_string(char * source, char * destination, int counter){
//     int msg_len = strlen(source);
//     for (int j = 0; j < msg_len; j++) {
//         destination[counter] = source[j];
//         counter++;
//     }
//     return counter;
//}
//
//int add_char_to_string(char source, char * destination, int counter){
//    destination[counter] = source;
//    counter++;
//    return counter;
//}


//void add_to_i2c_message_string(int id_number, int value) {
//    if (i2c_transmit_index >= I2C_TRANSMIT_MSG_SIZE-7) reset_i2c_message();
//    i2c_transmit_index = add_number_to_string(id_number, i2c_transmit_message, i2c_transmit_index);
//    i2c_transmit_message[i2c_transmit_index] = ' ';
//    i2c_transmit_index++;
//    i2c_transmit_index = add_number_to_string(value, i2c_transmit_message, i2c_transmit_index);
//    i2c_transmit_message[i2c_transmit_index] = ';';
//    i2c_transmit_index++;
//    i2c_transmit = true;
//    if (debug_code) {
//        Serial.print("New Data: ");
//        Serial.print(pad_id);
//        Serial.print(" ");
//        Serial.print(id_number);
//        Serial.print(" ");
//        Serial.println(value);
//        Serial.print("Full Message: ");
//        Serial.println(i2c_transmit_message);
//    }
//}
//
//void reset_i2c_message() {
//    i2c_transmit = false;
//    i2c_transmit_index = 0;
//    for (int i = 0; i < I2C_TRANSMIT_MSG_SIZE; i++) {
//         i2c_transmit_message[i] = ' ';
//         if (i >= I2C_TRANSMIT_MSG_SIZE -1) i2c_transmit_message[i] = '\0';
//     } 
//}


//void send_string() {
//   if (i2c_transmit) {
//       Wire.send(i2c_transmit_message);           // send the data via wire
//       if (debug_code) {
//           Serial.print("transmitData(), message sent: ");
//           Serial.println(i2c_transmit_message);
//       }
//   }
//   else {
//       char no_data_msg[] = {"no data"};
//       add_string_to_string(no_data_msg, i2c_transmit_message, 0);
//       Wire.send(i2c_transmit_message);
//   }
//   reset_i2c_message();  
//}


//void read_serial_strings() {
//      if (Serial.available()) {
//        char new_serial = Serial.read();
//        
//        if (new_serial >= '0' && new_serial <= '9') {
//            serial_receive_message[serial_receive_message_counter] = new_serial;
//            serial_last_received = millis();
//            serial_receive_message_counter++;
//        } 
//        else if ((new_serial == '\r' || new_serial == '\n' || new_serial == ';') && serial_receive_message_counter > 0) {
//            add_to_i2c_message(inputOffsetAir, atoi(serial_receive_message));
//            i2c_transmit = true; 
//            reset_serial_receive_message();          
//        } 
//
//        // if message from proximity sensor is too long, then throw it out
//        if (serial_receive_message_counter >= AIR_SERIAL_MSG_SIZE-1) {
//            reset_serial_receive_message();  
//        }
//    }
//    
//    // if too much time has passed since data was received then throw it out
//    if (millis() - serial_last_received > serial_receive_interval && serial_receive_message_counter > 0) {
//        reset_serial_receive_message();
//    }  
//}
//
//
//void reset_serial_receive_message() {
//    if (debug_code) Serial.print("Resetting serial message");
//    for (int i = 0; i < AIR_SERIAL_MSG_SIZE; i++) serial_receive_message[i] = '\0';
//    serial_receive_message_counter = 0;
//}

//
//void read_serial_strings() {
//      if (Serial.available()) {
//        char new_serial = Serial.read();
//        
//        if (new_serial >= '0' && new_serial <= '9') {
//            serial_receive_message[serial_receive_message_counter] = new_serial;
//            serial_last_received = millis();
//            serial_receive_message_counter++;
//        } 
//        else if ((new_serial == '\r' || new_serial == '\n' || new_serial == ';') && serial_receive_message_counter > 0) {
//            add_to_i2c_message(inputOffsetAir, atoi(serial_receive_message));
//            i2c_transmit = true; 
//            reset_serial_receive_message();          
//        } 
//
//        // if message from proximity sensor is too long, then throw it out
//        if (serial_receive_message_counter >= AIR_SERIAL_MSG_SIZE-1) {
//            reset_serial_receive_message();  
//        }
//    }
//    
//    // if too much time has passed since data was received then throw it out
//    if (millis() - serial_last_received > serial_receive_interval && serial_receive_message_counter > 0) {
//        reset_serial_receive_message();
//    }  
//}
//
//
//void reset_serial_receive_message() {
//    if (debug_code) Serial.print("Resetting serial message");
//    for (int i = 0; i < AIR_SERIAL_MSG_SIZE; i++) serial_receive_message[i] = '\0';
//    serial_receive_message_counter = 0;
//}

