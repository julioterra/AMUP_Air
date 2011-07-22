byte new_msg[3];
bool new_msg_flag = false;
int byte_count = 0;

void handle_midi_input() {
    if (Serial.available()){
        while(Serial.available()) {          
            byte new_byte = Serial.read();
            if (int(new_byte) > 127) {
                byte_count = 0;
                new_msg[byte_count] = new_byte;
                byte_count++;
                new_msg_flag = true;
            } else if (new_msg && byte_count < 3 && int(new_byte) < 128) {
                new_msg[byte_count] = new_byte;  
                byte_count++;
                if (byte_count == 3) {
                    parse_MIDI(new_msg);
                    byte_count = 0;
                    new_msg_flag = false;
                }
            }
        } 
    }
}

void parse_MIDI(byte* new_msg) {
  int midi_channel_number = int(new_msg[0]) - 175;
  if (midi_channel_number == 16) route_MIDI_local(new_msg);
  else if (midi_channel_number == 1 && midi_channel_number == 2) route_MIDI_i2c(new_msg);
}

void route_MIDI_local(byte* midi_msg) {
    int cc_number = int(midi_msg[1]);
    if (cc_number >= RGB_BUTTON_START && cc_number <= (RGB_BUTTON_START + RGB_BUTTON_COUNT)) {
        for (int i = 0; i < RGB_BUTTON_COUNT; i++) {
            if (cc_number == rgb_buttons[i].ID) {
                rgb_buttons[i].set_current_led_state(int(midi_msg[2]));
                break;  
            }         
        }
    }
}

void route_MIDI_i2c(byte* new_msg) {
    int adj_device_number = int(new_msg[0]) - 157;
    Wire.beginTransmission(adj_device_number); // transmit to device #4
    Wire.send(byte(255));          // sends end byte
    Wire.send(new_msg[1]);           // sends cc number
    Wire.send(new_msg[2]);          // sends cc value
    Wire.endTransmission();  // stop transmitting

      // Human-Readable Serial Out Code
//    Serial.println();
//    Serial.print("send MIDI to panel");
//    Serial.print(adj_device_number);
//    Serial.print(" - ");
//    Serial.print(int(new_msg[1]));
//    Serial.print(" - ");
//    Serial.println(int(new_msg[2]));
}

