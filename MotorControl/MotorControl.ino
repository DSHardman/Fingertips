
char inByte = 's';
char readmode = 'e';

int toolchangeA = 6;
int toolchangeB = 7;
int fingerjointA = 4;
int fingerjointB = 5;
int mountjointA = 2;
int mountjointB = 3;

void setup() {
  pinMode(toolchangeA, OUTPUT);
  digitalWrite(toolchangeA, 0);
  pinMode(toolchangeB, OUTPUT);
  digitalWrite(toolchangeB, 0);
  pinMode(fingerjointA, OUTPUT);
  digitalWrite(fingerjointA, 0);
  pinMode(fingerjointB, OUTPUT);
  digitalWrite(fingerjointB, 0);
  pinMode(mountjointA, OUTPUT);
  digitalWrite(mountjointA, 0);
  pinMode(mountjointB, OUTPUT);
  digitalWrite(mountjointB, 0);

  // Ensure analog pins are floating at first
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  pinMode(A5, INPUT);

  // digitalWrite(A0, HIGH);
  
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
      case 'd': // down
        digitalWrite(mountjointA, 0);
        digitalWrite(mountjointB, 1);
        break;
      case 'u': // up
        digitalWrite(mountjointA, 1);
        digitalWrite(mountjointB, 0);
        break;
      case 'f': // FSR mode;
        pinMode(A0, OUTPUT);
        pinMode(A1, INPUT);
        pinMode(A2, OUTPUT);
        pinMode(A3, INPUT);
        pinMode(A4, INPUT);
        pinMode(A5, INPUT);

        digitalWrite(A0, HIGH);
        digitalWrite(A2, HIGH);
        readmode = 'f';
        break;
      case 'p': // pneumatic mode;
        pinMode(A0, OUTPUT);
        pinMode(A1, INPUT);
        pinMode(A2, INPUT);
        pinMode(A3, INPUT);
        pinMode(A4, INPUT);
        pinMode(A5, OUTPUT);
        digitalWrite(A0, LOW);
        digitalWrite(A5, HIGH);
        readmode = 'p';
        break;
      case 'e': // EIT mode;
        pinMode(A0, INPUT);
        pinMode(A1, INPUT);
        pinMode(A2, INPUT);
        pinMode(A3, INPUT);
        pinMode(A4, INPUT);
        pinMode(A5, INPUT);
        readmode = 'e';
        break;
      case 'o': // Motors off
        digitalWrite(toolchangeA, 0);
        digitalWrite(toolchangeB, 0);
        digitalWrite(fingerjointA, 0);
        digitalWrite(fingerjointB, 0);
        digitalWrite(mountjointA, 0);
        digitalWrite(mountjointB, 0);
        break;
      default:
        break;
    }
    delay(10);
  }
  
  if (readmode=='p') {
    Serial.println(analogRead(A4));;
    delay(10);
  } else if (readmode=='f') {
    Serial.print(analogRead(A1));
    Serial.print(", ");
    Serial.println(analogRead(A3));
    delay(10);
  }
}


void establishContact() {
  while (Serial.available() <= 0) {
    delay(300);
  }
}
