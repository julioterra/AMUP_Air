byte new_msg[3];

void midi_input() {
    if (Serial.available()){
        int byte_count = 0;
        while(Serial.available()) {
            new_msg[byte_count] = Serial.read();
            byte_count++;
            if (byte_count >= 3) {
                sendI2C_MIDI(new_msg);
                byte_count = 0;
            }
        } 
    }
}
