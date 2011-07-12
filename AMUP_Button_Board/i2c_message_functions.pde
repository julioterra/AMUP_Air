void add_to_i2c_message(int id_number, int value) {
    if (i2c_transmit_index >= I2C_TRANSMIT_MSG_SIZE-7) reset_i2c_message();
    i2c_transmit_index = add_number_to_string(id_number, i2c_transmit_message, i2c_transmit_index);
    i2c_transmit_message[i2c_transmit_index] = ' ';
    i2c_transmit_index++;
    i2c_transmit_index = add_number_to_string(value, i2c_transmit_message, i2c_transmit_index);
    i2c_transmit_message[i2c_transmit_index] = ';';
    i2c_transmit_index++;
    i2c_transmit = true;
    
    if (debug_code) {
        Serial.print("New Data: ");
        Serial.print(pad_id);
        Serial.print(" ");
        Serial.print(id_number);
        Serial.print(" ");
        Serial.println(value);
        Serial.print("Full Message: ");
        Serial.println(i2c_transmit_message);
    }
}

void reset_i2c_message() {
    i2c_transmit = false;
    i2c_transmit_index = 0;
    for (int i = 0; i < I2C_TRANSMIT_MSG_SIZE; i++) {
         i2c_transmit_message[i] = ' ';
         if (i >= I2C_TRANSMIT_MSG_SIZE -1) i2c_transmit_message[i] = '\0';
     } 
}
