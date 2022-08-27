#include <WaspXBeeZB.h>
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>

//**********parametros Sensor CO2*********************

// CO2 Sensor must be connected physically in SOCKET_2
CO2SensorClass CO2Sensor;

// Concentratios used in calibration process (PPM Values)
#define POINT1_PPM_CO2 350.0  //   <-- Normal concentration in air
#define POINT2_PPM_CO2 1000.0
#define POINT3_PPM_CO2 3000.0

// Calibration vVoltages obtained during calibration process (Volts)
#define POINT1_VOLT_CO2 0.300
#define POINT2_VOLT_CO2 0.350
#define POINT3_VOLT_CO2 0.380

// Define the number of calibration points
#define numPoints 3

float concentrations[] = { POINT1_PPM_CO2, POINT2_PPM_CO2, POINT3_PPM_CO2 };
float voltages[] =       { POINT1_VOLT_CO2, POINT2_VOLT_CO2, POINT3_VOLT_CO2 };

//*************parametros XBEE************************
// Destination MAC address
//////////////////////////////////////////
char RX_ADDRESS[] = "000000000000FFFF";
//////////////////////////////////////////
// Define the Waspmote ID
char WASPMOTE_ID[] = "Router";
// define variable
int error;
uint16_t size;


void setup()
{
 
   USB.ON(); // init USB port
   USB.println(F("enviar paquete"));
   frame.setID( WASPMOTE_ID ); // store Waspmote identifier in EEPROM memory
   xbeeZB.ON();// Turn on XBee
   delay(3000);
   // Calculate the slope and the intersection of the logarithmic function
   CO2Sensor.setCalibrationPoints(voltages, concentrations, numPoints);
   // Switch ON and configure the Gases Board
   Gases.ON();  
   // Switch ON the CO2 Sensor SOCKET_2
   CO2Sensor.ON();
  
}

void loop()
{
  ///////////////////////////////////////////
  // 1.Read sensors
  ///////////////////////////////////////////  

  // Voltage value of the sensor
  float CO2Vol = CO2Sensor.readVoltage();
  // PPM value of CO2
  float CO2PPM = CO2Sensor.readConcentration();

  // Print of the results
  USB.print(F("CO2 Sensor Voltage: "));
  USB.print(CO2Vol);
  USB.print(F("volts |"));
  
  USB.print(F(" CO2 concentration estimated: "));
  USB.print(CO2PPM);
  USB.println(F(" ppm"));
  ///////////////////////////////////////////
  //2.Create ASCII frame
  ///////////////////////////////////////////  

  // create new frame
  frame.createFrame(ASCII);  
  //modelo: void getMaxSizeForXBee(uint8_t protocol,uint8_t addressing,uint8_t linkEncryption,uint8_t AESEncryption)
  size=frame.getMaxSizeForXBee(ZIGBEE, BROADCAST_MODE, DISABLED, DISABLED);
  // XBee-ZigBee, Broadcast addressing, XBee encryption Enabled, AES encryption Disabled
    frame.setFrameSize(size);
    
  //agregando data del sensor de CO2
  frame.addSensor(SENSOR_GASES_CO2, CO2PPM);
  frame.showFrame();
  
  ///////////////////////////////////////////
  // 2. Send packet
  ///////////////////////////////////////////  
  error = xbeeZB.send( RX_ADDRESS, frame.buffer, frame.length);
  USB.println(char(error));
  // check TX flag
  /*if( error == 0 )//‘0’ → OK: The command has been executed with no errors
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

  // wait for five seconds
  delay(5000);
   
}
