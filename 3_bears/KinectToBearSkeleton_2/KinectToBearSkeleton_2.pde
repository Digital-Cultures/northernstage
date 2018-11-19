/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 Skeleton color map example.
 Skeleton (x,y) positions are mapped to match the color Frame
 */

import KinectPV2.KJoint;
import KinectPV2.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

KinectPV2 kinect;
boolean sendOSC = true;

void setup() {
  size(1920, 1080, P3D);

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  
  //open receiving sketch
  //processing-java --sketch=/Users/tomschofieldart/Dropbox/RESEARCH/NORTHERN_STAGE_KTP/3_bears/animata/processing_code/BearFromKinect/ --force --run
}

void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      color col  = skeleton.getIndexColor();
      fill(col);
      stroke(col);
      drawBody(joints);
      if(sendOSC)  sendBodyOverOSC(joints, i);
    
    }
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}



void sendBodyOverOSC(KJoint[] joints, int index) {
  //head
  sendJointMsg(joints, KinectPV2.JointType_Head, "Head", index);

  //spine
  sendJointMsg(joints, KinectPV2.JointType_Neck, "Neck", index);
  sendJointMsg(joints, KinectPV2.JointType_SpineMid, "SpineMid", index);
  sendJointMsg(joints, KinectPV2.JointType_SpineBase, "SpineBase", index);

  //left arm
  sendJointMsg(joints, KinectPV2.JointType_HandTipLeft, "HandTipLeft", index);
  sendJointMsg(joints, KinectPV2.JointType_WristLeft, "WristLeft", index);
  sendJointMsg(joints, KinectPV2.JointType_ElbowLeft, "ElbowLeft", index);
  sendJointMsg(joints, KinectPV2.JointType_ShoulderLeft, "ShoulderLeft", index);

  //right arm
  sendJointMsg(joints, KinectPV2.JointType_HandTipRight, "HandTipRight", index);
  sendJointMsg(joints, KinectPV2.JointType_WristRight, "WristRight", index);
  sendJointMsg(joints, KinectPV2.JointType_ElbowRight, "ElbowRight", index);
  sendJointMsg(joints, KinectPV2.JointType_ShoulderRight, "ShoulderRight", index);

  //left leg
  sendJointMsg(joints, KinectPV2.JointType_HipLeft, "HipLeft", index);
  sendJointMsg(joints, KinectPV2.JointType_KneeLeft, "KneeLeft", index);
  sendJointMsg(joints, KinectPV2.JointType_FootLeft, "FootLeft", index);

  //right leg
  sendJointMsg(joints, KinectPV2.JointType_HipRight, "HipRight", index);
  sendJointMsg(joints, KinectPV2.JointType_KneeRight, "KneeRight", index);
  sendJointMsg(joints, KinectPV2.JointType_FootRight, "FootRight", index);
}

//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}
void sendJointMsg(KJoint[] joints, int jointType, String name, int index) {
  OscMessage myMessage = new OscMessage("/joint");
  float x = joints[jointType].getX();
  float y = joints[jointType].getY();
  myMessage.add(name);
  myMessage.add(x);
  myMessage.add(y);
  myMessage.add(index);
  oscP5.send(myMessage, myRemoteLocation);
}


//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}