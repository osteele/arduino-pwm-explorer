/*
  This sketch simulate an oscilloscope that displays a PWM waveform, using
  serial data from the Arduino sketch in this directory.

  Author: Oliver Steele <steele@osteele.com>
  Source: https://github.com/osteele/arduino-pwm-explorer
  License: MIT
*/

import processing.serial.*;

Serial myPort;

int period = -1;
float dutyCycle;
int lastMillis = 0;

void setup() {
  String portName = findSerialPort();
  //portName = "/dev/cu.usbmodem14301";
  println("Listening on port", portName);
  myPort = new Serial(this, portName, 9600);

  size(800, 350);
}

void draw() {
  serialReadPwmValues();
  float xPeriod = period / 1000.0;
  if (xPeriod <= 0.5) return;

  background(255, 255, 255);

  // draw the graph
  float x = 0;
  int Y_HIGH = 20;
  int Y_LOW = 150;
  beginShape();
  vertex(x, Y_LOW);
  while (x < width) {
    float x1 = x + xPeriod * dutyCycle;
    float x2 = x + xPeriod;
    vertex(x, Y_HIGH);
    vertex(x1, Y_HIGH);
    vertex(x1, Y_LOW);
    vertex(x2, Y_LOW);
    x = x2;
  }
  endShape(CLOSE);

  // draw the labels
  int xLabels = 10;
  int xValues = 260;
  textSize(32);
  fill(0, 102, 153, 100);
  text("Period:", xLabels, 230);
  text("Duty Cycle:", xLabels, 280);
  text("Frequency:", xLabels, 330);
  fill(0, 102, 153);
  text(period / 1000.0 + " ms", xValues, 230);
  text(dutyCycle * 100 + "%", xValues, 280);
  text(1000000.0 / period + " Hz", xValues, 330);
}

void serialReadPwmValues() {
  if (myPort.available() <=0) return;
  String line = myPort.readStringUntil('\n');
  if (line == null) return;

  int lastPeriod = period;
  float lastDutyCycle = dutyCycle;
  String[] fields = line.split( "," );
  try {
    period = Integer.parseInt(fields[0]);
    dutyCycle = Float.parseFloat(fields[1]);
  }
  catch (NumberFormatException e) {
    return;
  }
  if (period != lastPeriod || dutyCycle != lastDutyCycle || millis() > lastMillis + 1000) {
    println(period, dutyCycle);
    lastMillis = millis();
  }
}

String findSerialPort() {
  String[] ports = Serial.list();
  StringList candidates = new StringList();
  String usbModemPort = null;
  for (int i = 0; i < ports.length; i++) {
    String portName = ports[i];
    if (match(portName, "^/dev/tty|^/dev/cu\\.Bluetooth|^/dev/cu\\..*-Wireless") != null) {
      println(portName, " – ignored");
    } else {
      println(portName);
      candidates.append(ports[i]);
    }
    if (match(portName, "^/dev/cu.usbmodem") != null) {
      usbModemPort = portName;
    }
  }
  if (usbModemPort != null) {
    return usbModemPort;
  }
  if (candidates.size() > 0) {
    return candidates.get(0);
  }
  return null;
}
