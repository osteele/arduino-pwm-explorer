# PWM Visualizer

This is a pair of programs for the Arduino and Processing, to help students
develop an understanding of Pulse Width Modulation (PWM).

## Instructions

Wire an Arduino to a couple of pots, as described in `pwm_explorer.ino`. Upload
`pwm_explorer.ino` to the Arduino. One pot controls the frequency, and the other
controls the duty cycle. They flash the on-board LED. For greater visibility,
connect an external LED to pin 13.

Open `seril2pwm.pde` in Processing. Edit line 22 to specify the location of the
serial port. This code shows a simulation of the waveform, using the actual PWM
frequency and duty cycle from a connected Arduino.

## Related

[PWM Explorer](https://osteele.github.io/pwm-explorer/) is a similar
visualization tool that runs entirely in simulation, without requiring a
physical connection to an Arduino.

## License

MIT