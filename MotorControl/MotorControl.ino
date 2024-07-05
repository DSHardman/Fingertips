
char inByte = 's';

int toolchangeA = 4;
int toolchangeB = 5;
int fingerjointA = 2;
int fingerjointB = 3;

void setup() {
  pinMode(toolchangeA, OUTPUT);
  digitalWrite(toolchangeA, 0);
  pinMode(toolchangeB, OUTPUT);
  digitalWrite(toolchangeB, 0);
  pinMode(fingerjointA, OUTPUT);
  digitalWrite(fingerjointA, 0);
  pinMode(fingerjointB, OUTPUT);
  digitalWrite(fingerjointB, 0);
  
  // start serial port at 9600 bps:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  establishContact();  // send a byte to establish contact until receiver responds
}

void loop() {
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    Serial.print(inByte);

    switch (inByte) {
      case 'a': // attach
        digitalWrite(toolchangeA, 0);
        digitalWrite(toolchangeB, 1);
        break;
      case 'r': // release
        digitalWrite(toolchangeA, 1);
        digitalWrite(toolchangeB, 0);
        break;
      case 's': // straighten
        digitalWrite(fingerjointA, 1);
        digitalWrite(fingerjointB, 0);
        break;
      case 'b': // bend
        digitalWrite(fingerjointA, 0);
        digitalWrite(fingerjointB, 1);
        break;
      case 'o':
        digitalWrite(toolchangeA, 0);
        digitalWrite(toolchangeB, 0);
        digitalWrite(fingerjointA, 0);
        digitalWrite(fingerjointB, 0);
        break;
      default:
        break;
    }
    delay(10);
  }
}


void establishContact() {
  while (Serial.available() <= 0) {
    delay(300);
  }
}
