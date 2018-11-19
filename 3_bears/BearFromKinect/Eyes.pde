class Eye {
  PVector eyeCentre;
  float angle;
  float pupilSize;
  float eyeRad;
    Eye(int eyeCentreX, int eyeCentreY, float _pupilSize, float _eyeRad) {
    eyeCentre = new PVector(eyeCentreX, eyeCentreY);
    pupilSize =_pupilSize;
    eyeRad = _eyeRad;
  }

  void update(int targetX, int targetY) {
    angle = atan2(targetX-eyeCentre.x,targetY- eyeCentre.y );
  }
  void display() {
    float x = eyeRad/2 * sin(angle);
    float y = eyeRad/2 * cos(angle);
    
    stroke(0);
    fill(255);
    ellipse(eyeCentre.x,eyeCentre.y, 2*eyeRad,2*eyeRad);
    
    fill(0);
    ellipse(eyeCentre.x+x,eyeCentre.y+y, eyeRad,eyeRad);
    
  }
}