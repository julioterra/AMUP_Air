void handle_serial_input () {
  read_serial_bytes();
}

void read_serial_bytes() {
    if (Serial.available()) {
        byte new_serial = Serial.read();
        add_to_i2c_message(0, int(new_serial));
    } 
}


