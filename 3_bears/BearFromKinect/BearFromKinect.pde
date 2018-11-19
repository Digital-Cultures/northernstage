/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;

BodyPart [] parts;

Eye eye;
Eye eye2;
Eye birdEye;
Tree trees [];

Body [] bears;
Snowdrop [] drops;
float wind=0;
float windChangeSpeed = 0.005;

int rad = 20;

int LEFT_ARM=0;
int RIGHT_ARM=1;
int LEFT_LEG=2;
int RIGHT_LEG=3;
int HEAD =4;
int BODY=5;
int TUMMY =6;
PImage scene;

PVector targetBearCentre;

void setup() {
  size(1920, 1080, P3D);
  oscP5 = new OscP5(this, 7110);
  //daddy =  new Body("daddy_bear/");

  drops = new Snowdrop[105];
  for (int i=0; i<drops.length; i++) {
    //make a new raindrop to fill up the list
    drops[i] = new Snowdrop(i);
  }
  scene = loadImage("backdrop RIGHT PSD.png");
  bears = new Body[3];
  bears[0] =  new Body("Mammy/", 0);
  bears[1] =  new Body("Daddy/", 1);
  bears[2] =  new Body("Baby/", 2);


  eye = new Eye(490, 456, 8, 8);
  eye2 = new Eye(523, 439, 8, 8);
  birdEye = new Eye(961, 131, 4, 4);
  targetBearCentre = new PVector(0, 0);
  trees = new Tree[3];
  for(int i=0;i<trees.length;i++){
      trees[i] = new Tree(width);
  }
  
  smooth();
}

void draw() {
  background(0);
  image(scene, 0, 0, width, height);
  updateDropsFront();
  for (int i=0; i<bears.length; i++) {
    bears[i].update();
    bears[i].display();
  }
  updateAndDrawAnimatedElements(mouseX,mouseY);
  updateDropsRear();
  for(int i=0;i<trees.length;i++){
      trees[i].trunk.display(tree.x, height*0.8);
  }
  
  println(mouseX,mouseY);
}
void updateWind(float degree) {
  wind+=windChangeSpeed;
  if (wind>=degree||wind<=-degree) {
    windChangeSpeed*=-1;
  }
  println(wind, windChangeSpeed);
}

void updateDropsFront() {
  for (int i=int(drops.length*0.5); i<drops.length; i++) {
    drops[i].checkOtherDrops(drops);
    drops[i].move(wind);
    drops[i].display();
  }
}
void updateDropsRear() {
  for (int i=0; i<drops.length*0.5; i++) {
    drops[i].checkOtherDrops(drops);
    drops[i].move(wind);
    drops[i].display();
  }
}
void updateAndDrawAnimatedElements(int targetX, int targetY) {
  eye.update(targetX,targetY);
  eye.display();
  eye2.update(targetX,targetY);
  eye2.display();
  birdEye.update(targetX,targetY);
  birdEye.display();
}
void updateTargetBearCentre(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/joint")) {
    String name = theOscMessage.get(0).stringValue();
    float x = theOscMessage.get(1).floatValue();
    float y = theOscMessage.get(2).floatValue();
    int index = theOscMessage.get(3).intValue();
    println(name, x, y);
    if (index==0) {
      if (name.equals("Head")) {
        targetBearCentre.x=x;
        targetBearCentre.y=y;
      }
    }
  }
}
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());

  for (int i=0; i<bears.length; i++) {
    bears[0].parseOSCAndScale(theOscMessage);
  }
  updateTargetBearCentre(theOscMessage);
}