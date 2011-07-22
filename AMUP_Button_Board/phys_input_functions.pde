void handle_rgb_buttons() {
    for (int i = 0; i < midi_rgb_switch_length; i++) {
        prep_mux(i);
        if (rgb_buttons[i].available()) {
            add_to_i2c_message(rgb_buttons[i].ID, rgb_buttons[i].get_state());
        }
    }
    Tlc.update();
}

void handle_switches() {
    for (int i = 0; i < midi_switch_length; i++) {
      prep_mux(mux_switch+i);
        if (switches[i].available()) {
            int new_reading = switches[i].get_state();
            add_to_i2c_message(switches[i].ID, new_reading);
            if (i == 1 && new_reading == ON) Serial.print(AIR_LOCK_ON_CHAR);
            else if (i == 1) Serial.print(AIR_LOCK_OFF_CHAR);
        }
    }
}


void handle_analog_switches() {
    for (int i = 0; i < midi_analog_length; i++) {
        prep_mux(mux_analog+i);
        if (analog_switches[i].available()) {
            add_to_i2c_message(analog_switches[i].ID, analog_switches[i].get_state());
        }
    }
}



