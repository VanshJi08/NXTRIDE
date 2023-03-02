//Please note that you will need to replace the "COM3" and "COM4" in `myPort1
import processing.serial.*;

Serial myPort1;
Serial myPort2;
String lat1, lon1, lat2, lon2;
float distance;

void setup() {
  size(800, 600);
  myPort1 = new Serial(this, "COM3", 9600);
  myPort2 = new Serial(this, "COM4", 9600);
}

void draw() {
  background(255);

  while (myPort1.available() > 0) {
    String data = myPort1.readStringUntil('\n');
    if (data != null) {
      String[] coords = split(data, ",");
      lat1 = coords[0];
      lon1 = coords[1];
    }
  }

  while (myPort2.available() > 0) {
    String data = myPort2.readStringUntil('\n');
    if (data != null) {
      String[] coords = split(data, ",");
      lat2 = coords[0];
      lon2 = coords[1];
    }
  }

  if (lat1 != null && lon1 != null) {
    fill(255, 0, 0);
    ellipse(map(Float.parseFloat(lon1), -180, 180, 0, width), map(Float.parseFloat(lat1), 90, -90, 0, height), 20, 20);
    text("Device 1", map(Float.parseFloat(lon1), -180, 180, 0, width) + 10, map(Float.parseFloat(lat1), 90, -90, 0, height) - 10);
  }

  if (lat2 != null && lon2 != null) {
    fill(0, 255, 0);
    ellipse(map(Float.parseFloat(lon2), -180, 180, 0, width), map(Float.parseFloat(lat2), 90, -90, 0, height), 20, 20);
    text("Device 2", map(Float.parseFloat(lon2), -180, 180, 0, width) + 10, map(Float.parseFloat(lat2), 90, -90, 0, height) - 10);
  }

  if (lat1 != null && lon1 != null && lat2 != null && lon2 != null) {
    distance = calculateDistance(Float.parseFloat(lat1), Float.parseFloat(lon1), Float.parseFloat(lat2), Float.parseFloat(lon2));
    if (distance < 0.1) { // Check if distance is less than 0.1 km (100 meters)
      fill(255, 0, 0);
      ellipse(width/2, height/2, 100, 100);
      textSize(32);
      text("ALARM!", width/2 - 50, height/2 + 10);
    }
  }
}

// Function to calculate distance between two GPS coordinates
float calculateDistance(float lat1, float lon1, float lat2, float lon2) {
  float R = 6371; // Earth's radius in km
  float dLat = radians(lat2 - lat1);
  float dLon = radians(lon2 - lon1);
  float a = sin(dLat/2) * sin(dLat/2) + cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon/2) * sin(dLon/2);
  float c = 2 * atan2(sqrt(a), sqrt(1-a));
  float distance = R * c;
  return distance;
}
