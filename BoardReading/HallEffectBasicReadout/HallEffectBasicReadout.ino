#include <Arduino.h>
#include <Wire.h>
#include "TMAG5273.h"

#define TMAG_SDA 19
#define TMAG_SCL 18

TMAG5273 tmag5273(&Wire);

void setup() {
  Wire.begin();
  
  Serial.begin(115200);
  while (!Serial);
  Serial.println("connected");

  tmag5273.modifyI2CAddress(0x35);
  
  tmag5273.configOperatingMode(TMAG5273_OPERATING_MODE_MEASURE);
  tmag5273.configReadMode(TMAG5273_READ_MODE_STANDARD);
  tmag5273.configMagRange(TMAG5273_MAG_RANGE_40MT);
  tmag5273.configLplnMode(TMAG5273_LOW_NOISE);
  tmag5273.configMagTempcoMode(TMAG5273_MAG_TEMPCO_NdBFe);
  tmag5273.configConvAvgMode(TMAG5273_CONV_AVG_1X);
  tmag5273.configTempChEnabled(true);
  tmag5273.init();
}

void loop() {
  delay(100);
  float Bx, By, Bz, T;
  uint8_t res;

  res = tmag5273.readMagneticField(&Bx, &By, &Bz, &T);
  
  Serial.print(String(Bx));
  Serial.print(", ");
  Serial.print(String(By));
  Serial.print(", ");
  Serial.println(String(Bz));
}
