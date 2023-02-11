#include <BH1750.h>
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

BH1750 lightMeter; // 조도 센서 SCL-A5, DAT-A4
TinyGPS gps;
SoftwareSerial gpsSS(4, 3);
SoftwareSerial bt(8, 9);
LiquidCrystal_I2C lcd(0x27, 16, 2);

unsigned long startMillis;
unsigned long currentMillis;

int gpslLoopTime = 1000;

bool isPnumSet = false;

float flat =  37.500596;
float flon = 127.037037;

bool isLed = true;
String phoneNumber = "";
String walkData = "";

DynamicJsonDocument readDoc(200);
DynamicJsonDocument sendDoc(200);

bool newData = false;


// LCD
String pn = "";
String timer = "";
String dist = "";

void setup() {
  Serial.begin(9600);
  gpsSS.begin(9600);
  bt.begin(9600);
  Wire.begin();
  lightMeter.begin();
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
  float lux = lightMeter.readLightLevel();
  Serial.println(lux);    

  currentMillis = millis();
  if (bt.available()) {        // clears out any junk
      do {byte junk = bt.read();}
      while (bt.available() > 0);
  }

    int color_r = 0; // RED
    int color_g = 0; // GREEN
    int color_b = 0; // BLUE

    if(lux < 100 && isLed) { // 어두우면 백색
      color_r = 255;
      color_g = 255;
      color_b = 255;
    }

    for (int i = 0; i < LED_COUNT; i++) {
      strip.setPixelColor(i, color_r, color_g, color_b, 0);
    }

    strip.show();
    // LCD
    
    String readData = bt.readStringUntil('\n');
    Serial.println(readData);
    auto error = deserializeJson(readDoc, readData);
    if (error) {
      Serial.print(F("deserializeJson() failed with code "));
      Serial.println(error.c_str());
      return;
    }
    Serial.print("==>");
    pn = (const char*) readDoc["phoneNumber"];
    timer = (const char*) readDoc["timer"];
    dist = (const char*) readDoc["distance"];
    isLed = readDoc["isLedOn"] == "1" ? true : false;
    
    
    
    
    Serial.print(pn);
    Serial.print(", ");
    Serial.print(timer);
    Serial.print(", ");
    Serial.print(dist);
    Serial.print(", ");
    Serial.println(isLed);

    lcd.clear();
    // Serial.println(lux);
    // pn
    lcd.setCursor(1,0);
    lcd.print(pn.substring(0,3));
    lcd.print("-");
    lcd.print(pn.substring(3,7));
    lcd.print("-");
    lcd.print(pn.substring(7));

    // timer
    lcd.setCursor(1,1);
    lcd.print(timer);

    // dist
    lcd.setCursor(10,1);
    lcd.print(dist);
    lcd.print("m");

  // }

    // GPS
  if (currentMillis - startMillis > gpslLoopTime){
    startMillis = currentMillis;
    
    while (gpsSS.available())
    {
      char gpsData = gpsSS.read();
    
      if (gps.encode(gpsData)) // Did a new valid sentence come in?
        newData = true;
    }

    if (newData)
    {
      unsigned long age;

      gps.f_get_position(&flat, &flon, &age);

      sendDoc["lat"] = flat;
      sendDoc["lon"] = flon;
      // sendDoc["lat"] = 25.3;
      // sendDoc["lon"] = 123.5;
      String aaa;
      auto error2 = serializeJson(sendDoc, bt);

    }
  }

}
  
  