class BodyPart {
  float x, y;
  boolean isVisible=true;
  
  PVector imgCentre;
  PImage part;
  float boneAngle;
  float originalBoneLength;
  float scaleRatio;
  PVector boneCentre;
  float boneLength;
  float x1,y1,x2,y2;
  boolean isHead = false;
  BodyPart(PImage _part, float _x, float _y) {
    part =_part;
    imgCentre = getImageCentre(part);
    originalBoneLength = getBoneLength(part);
    x=_x;
    y = _y;
  }
  float getBoneLength(PImage img) {
    return img.height;
  }
  PVector getImageCentre(PImage img) {
    float halfWidth = img.width*0.5;
    float halfHeight = img.height*0.5;
    return new PVector(halfWidth, halfHeight);
  }
  void updatePos1(float _x1, float _y1){
    x1=_x1;
    y1=_y1;
  }
  void updatePos2(float _x2, float _y2){
    x2=_x2;
    y2=_y2;
  }
  void update() {
    boneCentre = new PVector( (0.5*(x2-x1))+x1, (0.5*(y2-y1))+y1);
    boneAngle = (0.5*PI)+atan2(y2-y1, x2-x1);
    //pythag to find the hyp length
    boneLength = sqrt( ( (x2-x1) * (x2-x1) )  +  ( (y2-y1) * (y2-y1) )  );
    scaleRatio = boneLength/originalBoneLength;
   // println("scaleRatio", scaleRatio, "boneAngle", boneAngle, "boneCentre", boneCentre);
  }
  void display() {
    pushStyle();
    imageMode(CENTER);
  
    
    if (isVisible) {
      pushMatrix();
      translate(boneCentre.x, boneCentre.y);
      rotate(boneAngle);
      if(isHead) scaleRatio *=2;
      scale(scaleRatio);
      image(part, 0, 0);
      popMatrix();
    }
    popStyle();
  }
  void show() {
    isVisible =true;
  }
  void hide() {
    isVisible =false;
  }
}