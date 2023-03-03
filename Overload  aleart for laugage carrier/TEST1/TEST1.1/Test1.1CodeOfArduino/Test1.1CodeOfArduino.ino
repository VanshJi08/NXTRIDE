#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <HX711.h>

#define OLED_RESET 4
#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define BUTTON_PIN 12
#define BUZZER_PIN 11
#define THRESHOLD 5000 // adjust this value to set the maximum weight in grams

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire);
HX711 scale;

void setup() {
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0,0);
  display.println("Vehicle Weight");
  display.display();
  scale.begin(3, 2);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(BUZZER_PIN, OUTPUT);
  Serial.begin(9600); // initialize serial communication for debugging
}

void loop() {
  float weight = getWeight();
  display.setCursor(0, 20);
  display.println("Weight: ");
  display.print(weight, 0);
  display.println("g    ");
  display.display();
  if (weight > THRESHOLD) {
    digitalWrite(BUZZER_PIN, HIGH);
    delay(500);
    digitalWrite(BUZZER_PIN, LOW);
  }
  if (digitalRead(BUTTON_PIN) == LOW) {
    tare();
  }
}

float getWeight() {
  float weight = scale.get_units(5); // read the weight in grams
  if (isnan(weight)) {
    return 0;
  }
  return weight;
}

void tare() {
  scale.tare(5); // set the current weight as zero
  display.clearDisplay();
  display.setCursor(0, 20);
  display.println("Tare Done");
  display.display();
  delay(1000);
  display.clearDisplay();
}
