void read_local_sensors() {
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
        if(rgb_buttons[i].available()) { 
          print_state(rgb_buttons[i].ID, rgb_buttons[i].get_state());
        }
}

void print_state(int _id, int _state) {
    Serial.write(MIDI_GLOBAL_CHANNEL);
    Serial.write(_id);
    Serial.write(_state);

    // human-readable serial output
//    Serial.print(int(MIDI_GLOBAL_CHANNEL));
//    Serial.print(" - ");
//    Serial.print(int(_id));
//    Serial.print(" - ");
//    Serial.println(int(_state));
}
