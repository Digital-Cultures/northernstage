class Body {
  BodyPart [] parts;
  float spineLength;
  int JOINT_LEFT_SHOULDER = 0;
  int JOINT_LEFT_ELBOW = 1;
  int JOINT_LEFT_HANDTIP = 2;
  int JOINT_RIGHT_SHOULDER = 3;
  int JOINT_RIGHT_ELBOW = 4;
  int JOINT_RIGHT_HANDTIP = 5;
  int JOINT_HEAD = 6;
  int JOINT_NECK = 7;
  int JOINT_SPINE_SHOULDER = 8;
  int JOINT_SPINE_MID = 9;
  int JOINT_SPINE_BASE = 10;
  int JOINT_LEFT_HIP = 11;
  int JOINT_LEFT_KNEE = 12;
  int JOINT_LEFT_FOOT = 13;
  int JOINT_RIGHT_HIP = 14;
  int JOINT_RIGHT_KNEE = 0;
  int JOINT_RIGHT_FOOT = 0;


  PVector leftHip = new PVector(0, 0);
  PVector leftFoot = new PVector(0, 0);
  PVector rightHip = new PVector(0, 0);
  PVector rightFoot = new PVector(0, 0);
  PVector leftShoulder = new PVector(0, 0);
  PVector leftHandTip = new PVector(0, 0);
  PVector rightShoulder = new PVector(0, 0);
  PVector rightHandTip = new PVector(0, 0);
  PVector spineShoulder = new PVector(0, 0);
  PVector spineMid = new PVector(0, 0);
  PVector spineBase = new PVector(0, 0);
  PVector head = new PVector(0, 0);
  PVector neck = new PVector(0, 0);

  int bearIndex;
  Body(String path, int _bearIndex) {
    bearIndex = _bearIndex;
    PImage img  = loadImage(path+"left_arm.png");
    parts = new BodyPart[6];
    parts[0]  = new BodyPart(img, 0, 0); 

    img  = loadImage(path+"right_arm.png");
    parts[1]  = new BodyPart(img, 0, 0); 

    img  = loadImage(path+"right_leg.png");
    parts[2]  = new BodyPart(img, 0, 0); 

    img  = loadImage(path+"left_leg.png");
    parts[3]  = new BodyPart(img, 0, 0); 

    img  = loadImage(path+"head.png");
    parts[4]  = new BodyPart(img, 0, 0); 
    parts[4].isHead = true;

    img  = loadImage(path+"body.png");
    parts[5]  = new BodyPart(img, 0, 0); 

  }
  void parseOSC(OscMessage theOscMessage) {
    if (theOscMessage.addrPattern().equals("/joint")) {
      String name = theOscMessage.get(0).stringValue();
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();
      int index = theOscMessage.get(3).intValue();
      println(name, x, y);
      if (index==bearIndex) {
        if (name.equals("ShoulderLeft")) {
          parts[LEFT_ARM].updatePos1(x, y);
        } else if (name.equals("HandTipLeft")) {
          parts[LEFT_ARM].updatePos2(x, y);
        } else if (name.equals("ShoulderRight")) {
          parts[RIGHT_ARM].updatePos1(x, y);
        } else if (name.equals("HandTipRight")) {
          parts[RIGHT_ARM].updatePos2(x, y);
        } else if (name.equals("FootLeft")) {
          parts[LEFT_LEG].updatePos1(x, y);
        } else if (name.equals("HipLeft")) {
          parts[LEFT_LEG].updatePos2(x, y);
        } else if (name.equals("FootRight")) {
          parts[RIGHT_LEG].updatePos1(x, y);
        } else if (name.equals("HipRight")) {
          parts[RIGHT_LEG].updatePos2(x, y);
        } else if (name.equals("Neck")) {
          parts[BODY].updatePos2(x, y);
          parts[HEAD].updatePos1(x, y);
        } else if (name.equals("Neck")) {
        } else if (name.equals("Head")) {
          parts[HEAD].updatePos2(x, y);
        } else if (name.equals("SpineMid")) {
          // parts[TUMMY].updatePos1(x, y);
        } else if (name.equals("SpineBase")) {
          //  parts[TUMMY].updatePos2(x, y);
          parts[BODY].updatePos1(x, y);
        }
      }
    }
  }
  void parseOSCAndScale(OscMessage theOscMessage) {
    if (theOscMessage.addrPattern().equals("/joint")) {
      String name = theOscMessage.get(0).stringValue();
      float x = theOscMessage.get(1).floatValue();
      float y = theOscMessage.get(2).floatValue();



      //println(name, x, y);
      if (name.equals("ShoulderLeft")) {
        parts[LEFT_ARM].updatePos1(x, y);
        leftShoulder.x =x;
        leftShoulder.y =y;
      } else if (name.equals("HandTipLeft")) {
        leftHandTip.x=x;
        leftHandTip.y=y;
        //parts[LEFT_ARM].updatePos2(x, y);
      } else if (name.equals("ShoulderRight")) {
        parts[RIGHT_ARM].updatePos1(x, y);
        rightShoulder.x = x;
        rightShoulder.y = y;
      } else if (name.equals("HandTipRight")) {
        //parts[RIGHT_ARM].updatePos2(x, y);
        rightHandTip.x=x;
        rightHandTip.y=y;
      } else if (name.equals("FootLeft")) {
        //parts[LEFT_LEG].updatePos1(x, y);
        leftFoot.x =x;
        leftFoot.y =y;
      } else if (name.equals("HipLeft")) {
        parts[LEFT_LEG].updatePos2(x, y);
        leftHip.x = x;
        leftHip.y =y;
      } else if (name.equals("FootRight")) {
        rightFoot.x =x;
        rightFoot.y =y;
      } else if (name.equals("HipRight")) {
        parts[RIGHT_LEG].updatePos2(x, y);
        rightHip.x = x;
        rightHip.y =y;
      } else if (name.equals("Neck")) {
        parts[BODY].updatePos2(x, y);
        parts[HEAD].updatePos1(x, y);
      } else if (name.equals("Neck")) {
        neck.x=x;
        neck.y=y;
      } else if (name.equals("Head")) {
        parts[HEAD].updatePos2(x, y);
      } else if (name.equals("SpineMid")) {

        // parts[TUMMY].updatePos1(x, y);
      } else if (name.equals("SpineBase")) {
        //     parts[TUMMY].updatePos2(x, y);
        parts[BODY].updatePos1(x, y);
        spineBase.x = x;
        spineBase.y = y;
      } else if (name.equals("SpineShoulder")) {
        spineShoulder.x = x;
        spineShoulder.y = y;
      }
    }
  }
  void update() {
    //parts[RIGHT_ARM].updatePos1(x, y);
    spineLength = spineBase.y - spineShoulder.y;



    float armLength = 0.6 * spineLength;
    float legLength = 0.6 * spineLength;
    //TODO May need to flip what substracts from what on opposite sides of body



    float leftArmAngle = atan2(leftHandTip.x-leftShoulder.x, leftHandTip.y-leftShoulder.y);
    float rightArmAngle = atan2(rightHandTip.x-rightShoulder.x, rightHandTip.y-rightShoulder.y);
    float leftLegAngle = atan2(leftFoot.x-leftHip.x, leftFoot.y-leftHip.y);
    float rightLegAngle = atan2(rightFoot.x-rightHip.x, rightFoot.y-rightHip.y);

    float scaledLeftHandTipX = armLength * sin(leftArmAngle);
    float scaledLeftHandTipY = armLength * cos(leftArmAngle);
    //ellipse(rightShoulder.x+scaledLeftHandTipX, rightShoulder.y+ scaledLeftHandTipY, 50, 50);
    parts[LEFT_ARM].updatePos2(leftShoulder.x+scaledLeftHandTipX, leftShoulder.y+ scaledLeftHandTipY);

    float scaledRightHandTipX = armLength * sin(rightArmAngle);
    float scaledRightHandTipY = armLength * cos(rightArmAngle);
    //ellipse(rightShoulder.x+scaledrightHandTipX, rightShoulder.y+ scaledrightHandTipY, 50, 50);
    parts[RIGHT_ARM].updatePos2(rightShoulder.x+scaledRightHandTipX, rightShoulder.y+ scaledRightHandTipY);


    //move legs up into body to make squat little bears!
    // leftHip.y = spineMid.y;
    //rightHip.y = spineMid.y;
    float legShiftFactor = 0.9;

    float scaledLeftLegX = legLength * sin(leftLegAngle);
    float scaledLeftLegY = legLength * cos(leftLegAngle);
    //ellipse(rightShoulder.x+scaledLeftLegTipX, rightShoulder.y+ scaledLeftLegTipY, 50, 50);
    parts[LEFT_LEG].updatePos1(leftHip.x+scaledLeftLegX, legShiftFactor*(leftHip.y+ scaledLeftLegY));
    parts[LEFT_LEG].updatePos2(leftHip.x, legShiftFactor*leftHip.y);

    float scaledRightLegX = legLength * sin(rightLegAngle);
    float scaledRightLegY = legLength * cos(rightLegAngle);
    //ellipse(rightShoulder.x+scaledRightLegTipX, rightShoulder.y+ scaledRightLegTipY, 50, 50);
    parts[RIGHT_LEG].updatePos1(rightHip.x+scaledRightLegX, legShiftFactor*(rightHip.y+ scaledRightLegY));
    parts[RIGHT_LEG].updatePos2(rightHip.x, legShiftFactor*rightHip.y);
    for (int i=0; i<parts.length; i++) {
      parts[i].update();
    }
  }

  void display() {

    for (int i=0; i<parts.length; i++) {
      parts[i].display();
    }
  }
}