void add_to_i2c_message(int id_number, int value) {
    i2c_transmit_byte_message[i2c_transmit_byte_index] = byte(MIDI_MSG_START);
    i2c_transmit_byte_index++;    
    i2c_transmit_byte_message[i2c_transmit_byte_index] = byte(id_number);
    i2c_transmit_byte_index++;
    i2c_transmit_byte_message[i2c_transmit_byte_index] = byte(value);
    i2c_transmit_byte_index++;
    if (i2c_transmit_byte_index >= I2C_TRANSMIT_MSG_SIZE-3) reset_i2c_message_byte();    

//        Serial.print("New Data: ");
//        Serial.print(int(i2c_transmit_byte_message[i2c_transmit_byte_index-2]));
//        Serial.print(" ");
//        Serial.print(int(i2c_transmit_byte_message[i2c_transmit_byte_index-1]));
//        Serial.print(" ");
//        Serial.println(int(i2c_transmit_byte_message[i2c_transmit_byte_index]));

}

void reset_i2c_message_byte() {
    i2c_transmit_byte = false;
    i2c_transmit_byte_index = 0;
    for (int i = 0; i < I2C_TRANSMIT_MSG_SIZE; i++) {
         i2c_transmit_byte_message[i] = byte(MIDI_MSG_BLANK);
     } 
}
