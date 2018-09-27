/*
 * This is for closed loop olfactometer with stim triggered by any locomotion.
 * MM adapted from code by Jenny Lu 4/6/2018.
 */
 
 #include <Running_Average.h>
 #include <Unwrapper.h>

// GLOBAL PARAMETERS
const int expThreshold = 700;
const int spdThresh = 100;  // Combined movement threshold for stim presentation, in rad/sampPeriod (suggested: 0.05 total abs(radian) across 3 axes per 200 msec)
const int sampPeriod = 25; // Period for analog read sampling rate in msec
const int jumpTol = 500;    // Minimum jump size to be considered wrapping (out of 1024 max)
const int avgWin_1 = 8;     // Smoothing window size for running average of integrated position data
const int avgWin_2 = 4; 	// Smoothing window size for running average of speed data	

// Set pin names
const int expActivePin = A0;
const int expActiveVal = 0;
const int ftYawPin = A1;
const int ftXPin = A2;
const int ftYPin = A3;
const int yawVal = 0;
const int speakerPin = 10; 
const int odorAPin = 11;
const int odorBPin = 12;
const int NOValvePin = 13;

// Initialize raw data variables
long newX = 0;
long newY = 0;
long newYaw = 0;
long oldX = 0;
long oldY = 0;
long oldYaw = 0;

// Initialize counter timing
unsigned long last_msec = 0L;

// Initialize unwrapper objects
Unwrapper unwrapperX(jumpTol, 1024);  
Unwrapper unwrapperY(jumpTol, 1024);
Unwrapper unwrapperYaw(jumpTol, 1024);

// Initialize arrays for running averages
Running_Average avgIntX(avgWin_1);
Running_Average avgIntY(avgWin_1);
Running_Average avgIntYaw(avgWin_1);
Running_Average avgSpdX(avgWin_2);
Running_Average avgSpdY(avgWin_2);
Running_Average avgSpdYaw(avgWin_2);

// Initialize comparison variables
float xSpd = 0;
float ySpd = 0;
float yawSpd = 0;

// Initialize summing variable
float sumSpd = 0;

// Set up pins
void setup() {
  pinMode(odorAPin, OUTPUT);
  pinMode(odorBPin, OUTPUT);
  pinMode(NOValvePin, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
}

// Run main loop at a fixed sampling rate
void loop() {
  
  if (millis() - last_msec >= sampPeriod)
  {
    last_msec += sampPeriod;
    read_sample();
  }
  
} // end loop

void read_sample() {
  
  // Read new input data 
  newX = analogRead(ftXPin);
  newY = analogRead(ftYPin);
  newYaw = analogRead(ftYawPin);
  
  // Unwrap if necessary
  newX = unwrapperX.unwrap(newX);
  newY = unwrapperY.unwrap(newY);
  newYaw = unwrapperYaw.unwrap(newYaw);
  
  // Decrement numbers if needed so they don't get too big for floating point math
  if (newX > 500000){
	  avgIntX.decrement(500000);
	  newX -= 500000;
	  oldXAvg -= 500000;
  }
  if (newY > 500000){
	  avgIntY.decrement(500000);
	  newY -= 500000;
	  oldYAvg -= 500000;
  }  
  if (newYaw > 500000){
	  avgIntYaw.decrement(500000);
	  newYaw -= 500000;
	  oldYawAvg -= 500000;
  }  
  
  // Put unwrapped inputs into position smoothing arrays
  avgIntX.addValue((float)newX);
  avgIntY.addValue((float)newY);
  avgIntYaw.addValue((float)newYaw);
  
  // Convert averaged sample to speed and add to second smoothing arrays
  avgSpdX.addValue(avgIntX.getAvg() - oldXAvg);
  avgSpdY.addValue(avgIntY.getAvg() - oldYAvg);
  avgSpdYaw.addValue(avgIntYaw.getAvg() - oldYawAvg);
  
  // Get averaged speed values 
  xSpd = avgSpdX.getAvg();
  YSpd = avgSpdY.getAvg();
  YawSpd = avgSpdYaw.getAvg();
  
  // Update old position values
  oldXAvg = avgIntX.getAvg();
  oldYAvg = avgIntY.getAvg();
  oldYawAvg = avgIntYaw.getAvg(); 
  
  // Sum axes
  sumSpd = oldXAvg + oldYAvg + oldYawAvg;
  
  // Convert speed threshold into rad/sampPeriod
  
  // See if CL is activated
  expActiveVal = analogRead(expActivePin);

  // Set olfactometer command pins to appropriate values
  if((expActiveVal > expThreshold) && (sumSpd > spdThresh))
  {
//    Serial.println(1);
    digitalWrite(odorAPin, HIGH);
    digitalWrite(odorBPin, LOW);
    digitalWrite(speakerPin, LOW);
	digitalWrite(NOValvePin, HIGH);
    digitalWrite(LED_BUILTIN, HIGH);
  } else 
  {
    digitalWrite(odorAPin, LOW);
    digitalWrite(odorBPin, LOW);
    digitalWrite(speakerPin, LOW);
    digitalWrite(NOValvePin, LOW);
    digitalWrite(LED_BUILTIN, LOW);
  }

}// End read_sample
