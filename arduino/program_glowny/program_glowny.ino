
#include <Servo.h>

#define potPin 0
#define ledPin 3
#define buttonPin 4
#define servoPin 9
#define echoPin 11
#define trigPin 12

Servo servo;

int buttonState = 0; 
int pos = 0;
int change = 1;
 
void setup() 
{ 
  servo.attach(servoPin);
  servo.write(pos);
  pinMode(ledPin, OUTPUT);
  pinMode(potPin, INPUT);
  pinMode(buttonPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
} 
 
void loop() 
{ 
  int pos = servo.read();
  if(digitalRead(buttonPin)==HIGH)
  {
    buttonState=!buttonState;
  }
  if(buttonState == 0)
  {
    digitalWrite(ledPin, LOW);    
    pos+=change;
    if(pos >= 180 || pos <= 0)
      change=change*-1;
    servo.write(pos);
  }
  if(buttonState == 1)
  {
    digitalWrite(ledPin, HIGH);
    int reading = analogRead(potPin);     // 0 to 1023
    int pos = map(reading, 0, 1023, 1, 180);
    servo.write(pos);
  }
  pos = servo.read();
  long time, dis;  
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW); 
  time = pulseIn(echoPin, HIGH);
  dis = time / 58;
  String Position = String(pos);
  String Distance = String(dis);
  String Output;
  Output+='p';
  Output+=Position;
  Output+='d';
  Output+=Distance;
  Serial.println(Output);
  delay(1000/60);
}

