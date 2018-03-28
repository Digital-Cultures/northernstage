//works with messages from http://sensors2.org
import ddf.minim.*;

import oscP5.*;
import netP5.*;

Minim minim;
AudioPlayer groove;



OscP5 oscP5;
NetAddress myRemoteLocation;

PFont font;

float val = 0;
float threshold = 0.5;

boolean isSlave = false;

void setup () {

  size(1200, 800);        
  setupSound();
  /* start oscP5, listening for incoming messages at port 12000 */
  if(isSlave){
    oscP5 = new OscP5(this, 1210);
    
  }
  else{
    oscP5 = new OscP5(this, 9999);
    myRemoteLocation = new NetAddress("localhost", 1210);
  }
  
  
  
  font = loadFont("Dialog-48.vlw");
  textFont(font, 18);
}
void draw () {
  background(0);
  
  //the most recent value for debugging purposes.
  text(val, 50, 50);

  //if the current value is bigger than 0.5
  if (val>threshold) {
    //map to a range of 0-1
    panSound(2*(val-0.5));
    
    //if the track isn't already playing
    if (!groove.isPlaying()) {
      
      //start again from the beginning
      groove.rewind();
      groove.play();
    }
    else{
     //otherwise just play the track from the point we left off
    groove.play(); 
    }
    //also send a message so the other app remains paused
    if(!isSlave) sendMessage(val-0.5);
  } else {
    //if the value is over the threshold then pause this track and message the other one.
    groove.pause();
    if(!isSlave) sendMessage(val+0.5);
  }
}

//send a message to the slave
void sendMessage(float value) {
  OscMessage myMessage = new OscMessage("/value");
  myMessage.add(value); /* add an int to the osc message */
  oscP5.send(myMessage, myRemoteLocation);
}

///pan left right and draw a bar indiciator
void panSound(float pan) {
  groove.setPan(map(pan, 0, 1, -1.0, 1.0));
  drawPan(pan);
}

//draw a balance indiciator
void drawPan(float pan) {
  stroke(255);
  int inset = 100;
  line(inset, height/2, width-inset, height/2);
  float xPos = map(pan, 0, 1, inset, width-inset  );
  rect(xPos, height/2, 5, 20);
}
//load the audio
void setupSound() {
  minim = new Minim(this);
  groove = minim.loadFile("fire_stereo.wav", 2048);
  groove.loop();
}

//listen for both messages from the sensors2OSC app and also from the master
void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage);
  if (theOscMessage.addrPattern().equals("/value") && theOscMessage.typetag().equals("f")) {
    val = theOscMessage.get(0).floatValue();
    println("Got val");
  }
  //or select accelerometer data in sensors2OSC
  if (theOscMessage.addrPattern().equals("/georotationvector") && theOscMessage.typetag().equals("fffff")) {
    val = map(theOscMessage.get(2).floatValue(), -1, 1, 0, 1);//theOscMessage.get(2).floatValue();//
    println("val", val);
  }
}