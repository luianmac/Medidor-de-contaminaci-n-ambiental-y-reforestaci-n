#include <WaspXBeeZB.h>
#include <WaspFrame.h>

// Destination MAC address
char* MAC_ADDRESS="000000000000FFFF";
//////////////////////////////////////////
// Define the Waspmote ID
char WASPMOTE_ID[] = "Router";
//Pointer to an XBee packet structure
packetXBee* packet; 
// define variable
//int error;
uint16_t size;

void setup()
{
  USB.ON(); // init USB port
   USB.println(F("enviar paquete"));
   
   xbeeZB.ON();// Turn on XBee
   delay(3000);
   frame.setID( WASPMOTE_ID ); // store Waspmote identifier in EEPROM memory


}


void loop()
{
  frame.createFrame(ASCII);  
  //modelo: void getMaxSizeForXBee(uint8_t protocol,uint8_t addressing,uint8_t linkEncryption,uint8_t AESEncryption)
  //size=frame.getMaxSizeForXBee(ZIGBEE, BROADCAST_MODE, DISABLED, DISABLED);
  // XBee-ZigBee, Broadcast addressing, XBee encryption Enabled, AES encryption Disabled
   // frame.setFrameSize(size);
    
  //agregando data del sensor de CO2
  frame.addSensor(SENSOR_STR, "hola");
// Set parameters to packet:
 packet=(packetXBee*) calloc(1,sizeof(packetXBee)); // Memory allocation
 packet->mode=BROADCAST; // Choose transmission mode: UNICAST or BROADCAST
 // Set destination XBee parameters to packet
 xbeeZB.setDestinationParams( packet, MAC_ADDRESS, frame.buffer, frame.length);
 // Send XBee packet
 xbeeZB.sendXBeePriv(packet);
 // Check TX flag
 
 if( xbeeZB.error_TX == 0)
 {
 USB.println(F("ok"));
 }
 else
 {
 USB.println(F("error"));
 USB.println(xbeeZB.error_TX);
 }
 // Free variables
 free(packet);
 packet=NULL;
  
  frame.showFrame();
  
  ///////////////////////////////////////////
  // 2. Send packet
  ///////////////////////////////////////////  
  /*error = xbeeZB.send( RX_ADDRESS, frame.buffer, frame.length);
  USB.println(char(error));
  // check TX flag
  if( error == 0 )//‘0’ → OK: The command has been executed with no errors
  {
    USB.println(F("send ok"));
    
    // blink green LED
    Utils.blinkGreenLED();
    
  }
  else 
  {
    USB.println(F("send error"));
    
    // blink red LED
    Utils.blinkRedLED();
  }*/


}
