/*
 * This is for closed loop olfactometer. Jenny Lu 4/6/2018.
 */

// SET THESE VALUES
int expThreshold = 700;
int expThreshold2 = 100;

int expActivePin = A0;
int expActiveVal = 0;

int ftYawPin = A1;
int ftXPin = A2;
int ftYPin = A3;
int yawVal = 0;

int speakerPin = 10;
int odorAPin = 11;
int odorBPin = 12;
int NOValvePin = 13;

// Set odor window size and location (deg)
int odorWindowYawPos1 = 0;
int odorWindowYawPos2 = 180;
int odorVolt1 = odorWindowYawPos1 * 2.844; //(1024/360);
int odorVolt2 = odorWindowYawPos2 * 2.844; //(1024/360);

void setup() {
  pinMode(odorAPin, OUTPUT);
  pinMode(odorBPin, OUTPUT);
  pinMode(NOValvePin, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

  yawVal = analogRead(ftYawPin);
  expActiveVal = analogRead(expActivePin);
  Serial.println(yawVal);
//  Serial.println(odorVolt1);
//  Serial.println(odorWindowYawPos2);
//  Serial.println(odorVolt2);
  Serial.println(expActiveVal);
  
  if((expActiveVal > expThreshold) && (yawVal > odorVolt1) && (yawVal < odorVolt2))
  {
    Serial.println(1);
    digitalWrite(odorAPin, HIGH);
    digitalWrite(odorBPin, LOW);
    digitalWrite(NOValvePin, HIGH);
    digitalWrite(LED_BUILTIN, HIGH);
//  } else if ((expThreshold2 < expActiveVal < expThreshold) && (panelval > odorVolt1) && (panelval < odorVolt2))
//  {
//    digitalWrite(odorAPin, LOW);
//    digitalWrite(odorBPin, HIGH);
//    digitalWrite(NOValvePin, HIGH);
  } else 
  {
    digitalWrite(odorAPin, LOW);
    digitalWrite(odorBPin, LOW);
    digitalWrite(NOValvePin, LOW);
    digitalWrite(LED_BUILTIN, LOW);
  }

}
