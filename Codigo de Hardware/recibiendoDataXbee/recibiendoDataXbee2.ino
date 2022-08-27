/*#include <SoftwareSerial.h>
SoftwareSerial Xbee(2,3);//rx,tx
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Xbee.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Xbee.available()>0){
    
    Serial.print(Xbee.read(),HEX);
    Serial.print(",");   
  }
  //Serial.println();
}*/

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}
void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available()>0){
    
    Serial.print(Serial.read(),HEX);
    Serial.print(",");   
  }
  //Serial.println();
}
