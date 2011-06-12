void add_to_message(int id_number, int value) {
    if (transmit_index >= transmitMessageSize-7) reset_message();
    transmit_index = add_to_string(id_number, transmit_message, transmit_index);
    transmit_message[transmit_index] = ' ';
    transmit_index++;
    transmit_index = add_to_string(value, transmit_message, transmit_index);
    transmit_message[transmit_index] = ';';
    transmit_index++;
    transmit = true;
    
    if (debug_code) {
        Serial.print("New Data: ");
        Serial.print(pad_id);
        Serial.print(" ");
        Serial.print(id_number);
        Serial.print(" ");
        Serial.println(value);

        Serial.print("Full Message: ");
        Serial.println(transmit_message);
    }
  
}

void reset_message() {
    transmit = false;
    transmit_index = 0;
    for (int i = 0; i < transmitMessageSize; i++) {
         transmit_message[i] = ' ';
         if (i >= transmitMessageSize -1) transmit_message[i] = '\0';
     } 
}

int add_to_string(int number, char * destination, int counter){
     char live_message[12];
     itoa(number, live_message, 10);
     int msg_len = strlen(live_message);
     for (int j = 0; j < msg_len; j++) {
         destination[counter] = live_message[j];
         counter++;
     }
     return counter;
}

