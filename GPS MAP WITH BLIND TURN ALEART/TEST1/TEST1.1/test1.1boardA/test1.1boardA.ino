#include <SoftwareSerial.h>
#include <Adafruit_GPS.h>

SoftwareSerial BTSerial(10, 11); // RX | TX
Adafruit_GPS GPS(&Serial1);

void setup() {
  GPS.begin(9600);
  BTSerial.begin(9600);
}

void loop() {
  GPS.read();

  if (GPS.newNMEAreceived()) {
    if (!GPS.parse(GPS.lastNMEA())) return;
  }

  String data = String(GPS.latitude, 6) + "," + String(GPS.longitude, 6);
  BTSerial.println(data);

  delay(500);
}
