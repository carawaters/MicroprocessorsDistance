# Microprocessors - Social Distancing Warning Device
Repository for the Physics Year 3 microprocessors lab project, making a social distancing warning device by Cara Waters and Maike Lenz.

An assembly program for PIC18 microprocessor using a PING))) Ultrasonic Distance Sensor 28015.

ultra.s - sends trigger pulse, receives echo pulse, times length of echo pulse

mult.s - carries out 16 bit x 8 bit multiplication

warn.s - sets thresholds and compares calculated distance with them for turning a buzzer and a set of LEDs on/off accordingly

LCD.s - redundant due to LCD using same port as buzzer
