void handle_rgb_buttons() {
    for (int i = 0; i < inputDigitalRGB; i++) {
        prep_mux(i);
        if (rgb_buttons[i].hasStateChanged()) {
            add_to_i2c_message(i, rgb_buttons[i].getState());
        }
    }
    Tlc.update();
}

void handle_switches() {
    for (int i = 0; i < inputDigital; i++) {
      prep_mux(inputOffsetDigital+i);
        if (switches[i].hasStateChanged()) {
            int new_reading = switches[i].getState();
            add_to_i2c_message(inputOffsetDigital+i, new_reading);
            if (i == 1 && new_reading == ON) Serial.print(AIR_LOCK_ON_CHAR);
            else if (i == 1) Serial.print(AIR_LOCK_OFF_CHAR);
        }
    }
}


void handle_analog_switches() {
    for (int i = 0; i < inputAnalog; i++) {
        prep_mux(inputOffsetAnalog+i);
        if (analog_switches[i].hasStateChanged()) {
            add_to_i2c_message(inputOffsetAnalog+i, analog_switches[i].getState());
        }
    }
}



