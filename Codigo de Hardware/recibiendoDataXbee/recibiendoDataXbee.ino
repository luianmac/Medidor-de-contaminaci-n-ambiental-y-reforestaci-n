#include <SoftwareSerial.h>
SoftwareSerial Xbee(2,3);
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Xbee.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Xbee.available()>1){
    Serial.println(Xbee.read(),HEX);
    }
}
