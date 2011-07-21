void read_and_send_console_data() {
    if (main_vol.available()) print_state(main_vol.ID, main_vol.get_state());
    for (int i = 0; i < 3; i++) 
        if (encoders[i].available()) {
          print_state(encoders[i].ID, encoders[i].get_state());
        }
    for(int i = 0; i < 4; i++) 
        if(switches[i].available()) {
          print_state(switches[i].ID, switches[i].get_state());
        }
    for(int i = 0; i < 4; i++) 
        if(buttons[i].available()) { 
          print_state(buttons[i].ID, buttons[i].get_state());
        }
}

void print_state(int _id, int _state) {
//    Serial.print(MIDI_GLOBAL_CHANNEL);
//    Serial.print(" ");
//    Serial.print(_id);
//    Serial.print(" ");
//    Serial.println(_state); 

    Serial.print(int(MIDI_GLOBAL_CHANNEL));
    Serial.print(" - ");
    Serial.print(int(_id));
    Serial.print(" - ");
    Serial.println(int(_state));

//  MIDI Writing
//    Serial.write(MIDI_GLOBAL_CHANNEL);
//    Serial.write(_id);
//    Serial.write(_state);
//    Serial.write(MIDI_MSG_END);

}

//void add_to_i2c_message(int id_number, int value) {
//    if (i2c_transmit_index >= I2C_TRANSMIT_MSG_SIZE-7) reset_i2c_message();
//    i2c_transmit_index = add_number_to_string(id_number, i2c_transmit_message, i2c_transmit_index);
//    i2c_transmit_message[i2c_transmit_index] = ' ';
//    i2c_transmit_index++;
//    i2c_transmit_index = add_number_to_string(value, i2c_transmit_message, i2c_transmit_index);
//    i2c_transmit_message[i2c_transmit_index] = ';';
//    i2c_transmit_index++;
//    i2c_transmit = true;
//    
////    if (debug_code) {
////        Serial.print("New Data: ");
////        Serial.print(pad_id);
////        Serial.print(" ");
////        Serial.print(id_number);
////        Serial.print(" ");
////        Serial.println(value);
////        Serial.print("Full Message: ");
////        Serial.println(i2c_transmit_message);
////    }
//}
//
//void reset_i2c_message() {
//    i2c_transmit = false;
//    i2c_transmit_index = 0;
//    for (int i = 0; i < I2C_TRANSMIT_MSG_SIZE; i++) {
//         i2c_transmit_message[i] = ' ';
//         if (i >= I2C_TRANSMIT_MSG_SIZE -1) i2c_transmit_message[i] = '\0';
// } 
//}