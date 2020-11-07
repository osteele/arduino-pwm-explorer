/*
  PWM Explorer

  Software-controlled LED PWM.
  Turn one pot to control the frequency.
  Turn the other pot to control the duty cycle.
  The frequency and duty cycle are sent to the serial connection, where they can
  be plotted or by Serial Plotter or used to simulate an oscilloscope by the
  Processing sketch in this directory.

  Circuit:
  - Connect pots to pins A0 and A1.
  - Optionally connect LED to PIN 13 and ground (in series with 220Ω resistor).

  Author: Oliver Steele <steele@osteele.com>
  Source: https://github.com/osteele/arduino-pwm-grapher
  License: MIT
 */

const int buttonPin = 2;
const int ledPin = LED_BUILTIN;

int lastTransitionTime = 0;
int nextTransitionValue = HIGH;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);
}

void loop() {
  static long period = 100;
  static float dutyCycle = 0.5;
  static long lastSensorReadTime = -1;

  if (millis() - lastSensorReadTime > 250) {
    lastSensorReadTime = millis();

    period = analogRead(A0) * 1000L / 3 + 10;
    dutyCycle = analogRead(A1) / 1024.0;

    Serial.print(period);
    Serial.print(",");
    Serial.print(map(analogRead(A0), 0, 1000, 10, 300));
    Serial.print(",");
    Serial.println(dutyCycle);
  }

  // Use this instead of %, so that we don't get weird flickering patterns
  // when the pot is moved or drifts
  while (lastTransitionTime > micros() + period) {
    lastTransitionTime -= period;
  }
  int value = micros() - lastTransitionTime < dutyCycle * period ? HIGH : LOW;
//  if (micros() >= lastTransitionTime + ) {
//    int value = micros() % period < period * dutyCycle ? HIGH : LOW;
    digitalWrite(ledPin, value);
//  }
}
