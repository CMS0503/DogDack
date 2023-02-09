// #include <BH1750.h>
#include <Wire.h>
#include <SoftwareSerial.h>
#include <TinyGPS.h>
#include <LiquidCrystal_I2C.h>
#include <ArduinoJson.h>
#include <Adafruit_NeoPixel.h>

#define LED_PIN 6 // 네

#define LED_COUNT 12 // 네오픽셀 LED 개수
#define BRIGHTNESS 100 // 네오픽셀 LED 밝기(0 ~ 255)

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

// BH1750 lightMeter; // 조도 센서 SCL-A5, DAT-A4
TinyGPS gps;
SoftwareSerial gpsSS(4, 3);
SoftwareSerial bt(8, 9);
LiquidCrystal_I2C lcd(0x27, 16, 2);

unsigned long startMillis;
unsigned long currentMillis;
int gpslLoopTime = 1000;
bool isPnumSet = false;

String phoneNumber = "";
String walkData = "";

void setup() {

  Serial.begin(9600);
  gpsSS.begin(9600);
  bt.begin(9600);
  Wire.begin();
  // lightMeter.begin();
  startMillis = millis();

  // LCD 세팅
  lcd.init();
  lcd.backlight();
  lcd.setCursor(1,0);
  lcd.print("Hello world!");
  lcd.setCursor(0,1);
  lcd.print("Have a nice day!");
  
  // 스트립
  strip.begin(); // 네오픽셀 초기화
  strip.setBrightness(BRIGHTNESS); // 네오픽셀 밝기 설정
  strip.show();
}

void loop() {
  bool newData = false;
  int color_r = 0; // RED
  int color_g = 0; // GREEN
  int color_b = 0; // BLUE
  // LCD
  int receiveData = bt.read();
  // float lux = lightMeter.readLightLevel();

  currentMillis = millis();

  if (receiveData != -1 && !isPnumSet){
    // Serial.println("phone");
    
    setPhoneNum(receiveData);
    
  }
  else if (receiveData != -1) {
    // Serial.println("dist");
    getWalkData(receiveData);
  }

  else{
    // Serial.println(receiveData);
  }
  
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

      // doc["lat"] = flat;
      // doc["lon"] = flon;
      doc["lat"] = 25.3;
      doc["lon"] = 123.5;
      serializeJson(doc, bt);
    }
    
    // Serial.println(lux);    
    
  }
  
  // if(lux < 100) { // 어두우면 백색
  //   color_r = 255;
  //   color_g = 255;
  //   color_b = 255;
  // }

  // for (int i = 0; i < LED_COUNT; i++) {
  //   strip.setPixelColor(i, color_r, color_g, color_b, 0);
  // }
  // strip.show();

}

void setPhoneNum(int data){
  if (data == 'a'){
    // Serial.print(phoneNumber);

    String number = ""; 
    number += phoneNumber.substring(0,3);
    number += "-";
    number += phoneNumber.substring(3,7);
    number += "-";
    number += phoneNumber.substring(7,11);
    lcd.clear();
    lcd.setCursor(1,0);
    lcd.print(number);

    phoneNumber = "";
    isPnumSet = true;
    
  }
  else {
    phoneNumber += String(char(data));
  }
}

void getWalkData(int data){
  if (data == 'm'){
    walkData += String(char(data));
    int markIdx = walkData.indexOf(',');
    String timer = walkData.substring(0,markIdx);
    String dist = walkData.substring(markIdx);
    
    Serial.println(timer);
    Serial.println(dist);

    if (!(walkData.length() > 15)){
      lcd.setCursor(1,1);
      lcd.print(timer);
      lcd.setCursor(9,1);
      lcd.print(dist);
    }
    
    walkData = "";
  }
  else{
    walkData += String(char(data));
  }
}