#include <SoftwareSerial.h>
#include <ArduinoJson.h>

#include <TinyGPS.h>

/* This sample code demonstrates the normal use of a TinyGPS object.
   It requires the use of SoftwareSerial, and assumes that you have a
   4800-baud serial GPS device hooked up on pins 4(rx) and 3(tx).
*/

TinyGPS gps;
SoftwareSerial gpsSS(4, 3);
SoftwareSerial bt(8, 9);

bool isConnected = false;
unsigned long startMillis;
unsigned long currentMillis;
int gpslLoopTime = 1000;

String phoneNumber = "";

void setup()
{
  Serial.begin(9600);
  gpsSS.begin(9600);
  bt.begin(9600);

  Serial.print("Simple TinyGPS library v. "); Serial.println(TinyGPS::library_version());
  Serial.println("by Mikal Hart");
  Serial.println();

  startMillis = millis();

}

void loop()
{
  bool newData = false;
  unsigned long chars;
  unsigned short sentences, failed;

  // if (bt.available() && isConnected)
  // {
  //   isConnected = true;
  //   // write to LCD
  // }
  int receiveData = bt.read();
  if (receiveData != -1){
    Serial.print(char(receiveData));
    
    receiveData = bt.read();
  }
  
  currentMillis = millis();
  if (currentMillis - startMillis > gpslLoopTime){
    startMillis = currentMillis;

    while (gpsSS.available())
    {
      char gpsData = gpsSS.read();
    
      if (gps.encode(gpsData)) // Did a new valid sentence come in?
        newData = true;
    }

    if (true)
    {
      float flat, flon;
      unsigned long age;
      DynamicJsonDocument doc(200);

      gps.f_get_position(&flat, &flon, &age);

      doc["lat"] = flat;
      doc["lon"] = flon;

      serializeJson(doc, bt);
   }
  }



  

  // Serial.println(bt.read()); 

  
  
  
}