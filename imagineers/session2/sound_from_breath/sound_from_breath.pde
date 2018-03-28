import processing.sound.*;

SoundFile soundfile;
Delay delay;

import processing.serial.*;
PFont font;
Serial myPort;        // The serial port

int inByteA=0;

// a circular buffer for holding smoothed values
int smoothedValues [];
int index = 0;
int numVals = 20;

//our mapping range whcih will dynamically adjust
float lowBound = 1023;
float highBound = 0;
int numResults = 0;


void setup () {
    // set the window size:
  size(1200, 800);   
  font = loadFont("Dialog-48.vlw");
  textFont(font, 18);
  smoothedValues = new int [numVals];
  for (int i=0; i<smoothedValues.length; i++) {
    smoothedValues[i] =0;
  }
     
  setupSound();
 
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
}
void draw () {
  // set inital background:

  background(0);
  // println(inByteA, inByteB);
  fill(255);
  
  float meanVal = getMean(smoothedValues);
  
  //dynamically collapse the mapping range
  lowBound *=1.0001;
  highBound *=0.9999;
  
  //adjust the boundaries of the mapping range
  if (meanVal < lowBound) lowBound = meanVal;
  if (meanVal > highBound) highBound = meanVal;

  //map the smoothed value to our range
  float normalised  = map(meanVal, lowBound, highBound, 0.0, 1.0);

  //println(lowBound, highBound);
  
  //draw a representation
  ellipse(width/2, height/2, normalised * 300, normalised * 300);
  
  //delaySound(map(meanVal, 100, 200, 0, 1));
  //pan the sound left or right depending on the breath
  panSound(normalised);
  
  //show some debugging info
  text("num results "+str(numResults), 50, 100);
  text("normalised value "+str(normalised), 50, 150);
}


void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  //println(inString);
  if (inString != null) {

    // trim off any whitespace:
    inString = trim(inString);

    if (inString.length()>0) {
      if (inString.charAt(0)=='A') {
        // convert to an int and map to the screen height:

        inByteA = int(inString.substring(1, inString.length()));

        smoothedValues[index] = inByteA;
        index++;
        numResults++;
        if (index>=smoothedValues.length) {
          index =0;
        }
      } else if (inString.charAt(0)=='B') {
        inByteB = int(inString.substring(1, inString.length()));
      }
    }
  }
}
void panSound(float pan){
  soundfile.pan(map(pan, 0, 1, -1.0, 1.0));  
}

void setupSound() {
  //soundfile = new SoundFile(this, "ChicksInCart_2.WAV");
  //soundfile = new SoundFile(this, "vibraphon.aiff");
  
  soundfile = new SoundFile(this, "rain_mono.wav");


  // create a Delay Effect
  delay = new Delay(this);

  // These methods return useful infos about the file
  println("SFSampleRate= " + soundfile.sampleRate() + " Hz");
  println("SFSamples= " + soundfile.frames() + " samples");
  println("SFDuration= " + soundfile.duration() + " seconds");

  // Play the file in a loop
  soundfile.loop();

  // Patch the delay
  delay.process(soundfile, 5);
}
void delaySound(float input) {
  // Map mouseY from 0.2 to 1.0 for amplitude  
  soundfile.amp(map(input, 0, 1, 0.2, 1.0)); 

  // Map mouseY from -1.0 to 1.0 for left to right 
  //soundfile.pan(map(input, 0, height, -1.0, 1.0));  

  // Map mouseY from 0.001 to 2.0 seconds for the delaytime 
  delay.time(map(input, 0, 1, 0.001, 2.0));

  // Map mouseX from 0 to 0.8 for the delay feedback 
  delay.feedback(map(input, 0, 1, 0.0, 0.8));
}

//utility function to get mean of int array
float getMean(int [] vals) {
  int total=0;
  for (int i=0; i<vals.length; i++) {
    total+=vals[i];
  }
  return total/vals.length;
}