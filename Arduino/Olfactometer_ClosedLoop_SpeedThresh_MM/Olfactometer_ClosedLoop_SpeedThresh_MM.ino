/*
 * This is for closed loop olfactometer with stim triggered by any locomotion.
 * MM adapted from code by Jenny Lu 4/6/2018.
 */
 
 #include <Running_Average.h>

// GLOBAL PARAMETERS
const int expThreshold = 700;
const int spdThresh = 2;  	// Combined movement threshold for stim presentation, in Ain values/sample period
const int sampPeriod = 25; 		// Period for analog read sampling rate in msec
const int jumpTol = 500;    	// Minimum jump size to be considered wrapping (out of 1024 max)
const int avgWin_1 = 8;     	// Smoothing window size (in samples) for running average of integrated position data
const int avgWin_2 = 8; 		// Smoothing window size (in samples) for running average of speed data	
const int minStimTime = 500;    // Minimum time that stim will stay on in msec

// Set pin names
const int expActivePin = A0;
int expActiveVal = 0;
const int ftYawPin = A1;
const int ftXPin = A2;
const int ftYPin = A3;
const int yawVal = 0;
const int speakerPin = 10; 
const int odorAPin = 11;
const int odorBPin = 12;
const int NOValvePin = 13;

// Initialize raw data variables
long oldX = 0;
long oldY = 0;
long oldYaw = 0;
int newX = 0;
int newY = 0;
int newYaw = 0;
float oldXAvg = 0;
float oldYAvg = 0;
float oldYawAvg = 0;
int stimOn = 0;

// Initialize counter timing
unsigned long last_msec = 0L;
unsigned long stimOnTime = 0L;

// Initialize running average objects
Running_Average avgIntX(avgWin_1);
Running_Average avgIntY(avgWin_1);
Running_Average avgIntYaw(avgWin_1);
Running_Average avgSpdX(avgWin_2);
Running_Average avgSpdY(avgWin_2);
Running_Average avgSpdYaw(avgWin_2);

// Set up pins
void setup() {
  pinMode(odorAPin, OUTPUT);
  pinMode(odorBPin, OUTPUT);
  pinMode(NOValvePin, OUTPUT);
  pinMode(speakerPin, OUTPUT);
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
  oldX = newX;
  oldY = newY;
  oldYaw = newYaw;
  newX = analogRead(ftXPin);
  newY = analogRead(ftYPin);
  newYaw = analogRead(ftYawPin);  
  
  // Reset arrays if any of the inputs has looped around at 0 or 1024
  if (abs(oldX - newX) > jumpTol) { avgIntX.clear(); }
  if (abs(oldY - newY) > jumpTol) { avgIntY.clear(); }  
  if (abs(oldYaw - newYaw) > jumpTol) { avgIntYaw.clear(); }
  
  // Put the inputs into position smoothing arrays
  avgIntX.addValue((float)newX);
  avgIntY.addValue((float)newY);
  avgIntYaw.addValue((float)newYaw);
    
  // If running averages have at least 2 inputs in them, convert averaged sample to speed 
  // and add to second set of smoothing arrays
  if (avgIntX.getCount() >= 2) { avgSpdX.addValue(abs(avgIntX.getAvg() - oldXAvg)); }
  if (avgIntY.getCount() >= 2) { avgSpdY.addValue(abs(avgIntY.getAvg() - oldYAvg)); }
  if (avgIntYaw.getCount() >= 2) { avgSpdYaw.addValue(abs(avgIntYaw.getAvg() - oldYawAvg)); }
  
  // Update old position values
  oldXAvg = avgIntX.getAvg(); 
  oldYAvg = avgIntY.getAvg(); 
  oldYawAvg = avgIntYaw.getAvg(); 
  
  // Get averaged speed values 
  float xSpd = avgSpdX.getAvg();
  float ySpd = avgSpdY.getAvg();
  float yawSpd = avgSpdYaw.getAvg();
  
  // Sum axes
  float sumSpd = xSpd + ySpd + yawSpd;
  Serial.println(sumSpd);
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
	stimOnTime = millis();
} else if ((expActiveVal < expThreshold) || (millis() - stimOnTime) > minStimTime)
  {
    digitalWrite(odorAPin, LOW);
    digitalWrite(odorBPin, LOW);
    digitalWrite(speakerPin, LOW);
    digitalWrite(NOValvePin, LOW);
    digitalWrite(LED_BUILTIN, LOW);
  }

}// End read_sample
