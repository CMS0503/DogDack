#include <Adafruit_NeoPixel.h>
#include <BH1750.h>
#include <Wire.h>

#define LED_PIN 6 // 네오픽셀 D핀과 연결한 아두이노 핀 번호
#define LED_COUNT 12 // 네오픽셀 LED 개수
#define BRIGHTNESS 100 // 네오픽셀 LED 밝기(0 ~ 255)

BH1750 lightMeter; // 조도 센서 SCL-A5, DAT-A4

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRBW + NEO_KHZ800);

void setup() {
  strip.begin(); // 네오픽셀 초기화
  strip.setBrightness(BRIGHTNESS); // 네오픽셀 밝기 설정
  strip.show();

  Serial.begin(9600);
  Wire.begin();
  lightMeter.begin();
}

void loop() {

  float lux = lightMeter.readLightLevel();
  Serial.print(lux);
  
  // 네오픽셀 LED 색(0~255)
  int color_r = 0; // RED
  int color_g = 0; // GREEN
  int color_b = 0; // BLUE
  if(lux < 100) { // 어두우면 백색
        color_r = 255;
        color_g = 255;
        color_b = 255;
    }

  // 모든 네오픽셀에 색 설정하기
  for (int i = 0; i < LED_COUNT; i++) {
    strip.setPixelColor(i, color_r, color_g, color_b, 0);
  }
  // 네오픽셀 설정값 적용하기
  strip.show();

  delay(1000); //1초마다 변경
}