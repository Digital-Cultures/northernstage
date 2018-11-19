class Snowdrop {
  float x;
  float y;
  float speed;
  float rad;
  color col;
  
  //i've added an index, and ID so that we know where this drop is in the list
  int index;
  //this is a constructor - it's like setup but for an object - see I'm PASSING the index in from outside
  Snowdrop(int _index) {
    y = random(-height);;
    //set the x position as a random number between zero and the screen width
    x = random(-height*2,height*2);
    
    //I've added a variable for the radius to make things neater
    rad = random(10,15);
    speed = random(2.0,2.4);//random(2, 5);
    //starting with a random color
    //col = color( random(255), random(255), random(255));
    col=color(230,random(50,100));
    index = _index;
  }

  //this function is taking a list of raindrops as an argument/parameter
  void checkOtherDrops(Snowdrop [] otherDrops) {
    
    //go through all the other drops
    for (int i=0; i<otherDrops.length; i++) {
      
      //this looks complicated but it's checking whether this particular other drop overlaps with me
      if (otherDrops[i].x >= x-rad && otherDrops[i].x<= x+rad && otherDrops[i].y>=y-rad && otherDrops[i].y<=y+rad) {
        
        //I need to make sure that I'm not comparing the same two drops
        //if ( i!=index) {
        //  //here's where the magic happens. In this example I'm randomising the color when the drops overlap
        //  col = color( random(255), random(255), random(255));
        //}
      }
    }
  }

  void move(float wind) {
    //increase (increment) the y position by the speed each time
    y+=speed;
    x+=wind;
    //if y gets bigger than the height make y zero again (cycle repeats)
    if (y>=height) {
      y=0;
      x = random(-height*2,height*2);
    }
  }

  void display() {
    pushStyle();
    //because the color is now in a variable each drop has its own
    fill(col);
    noStroke();
    ellipse(x, y, rad, rad);
    ellipse(x, y, rad*0.8, rad*0.8);
    int numLayers=3;
    //fill(255);
    ellipse(x, y, rad*0.6, rad*0.6);
    
    
    //for(int i=1;i<=numLayers;i++){
    //  ellipse(x, y, rad/i, rad/i);
    //}
    //ellipse(x, y, 2*rad, 2*rad);
    
    //ellipse(x, y, 1.5*rad, 1,5rad);
    //ellipse(x, y, 0.5*rad, 0.5*rad);
    popStyle();
  }
}