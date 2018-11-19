//from https://blog.ktbyte.com/2018/08/16/randomly-generating-trees/
class Tree {
   

  float x ; //Where the base of the tree is
  int branchesAtBreak; //How many branches at each break
  int numberOfBreaks ; //How many breaks
  float trunkWidth ; //Width of trunk
  float branchSpread ; //How much should the branches spread out
  float branchSplay ; //The lower the number the shorter the outer branches are
  float branchLengthMulti; //How much branches shrink length wise each break
  float branchWidthMulti; // Same as above except with width
  float breezeStrength ; //How strong is the "breeze" that sways the tree
  float leafSize ; //Size of the leaves
  
  Branch trunk;
  //
  
  Tree(int _x){
     x = _x; //Where the base of the tree is
   branchesAtBreak = (int) random(3, 5); //How many branches at each break
   numberOfBreaks = (int) random(4, 6); //How many breaks
   trunkWidth = random(3, 4) * (float) numberOfBreaks; //Width of trunk
   branchSpread = random(5, 7); //How much should the branches spread out
   branchSplay = random(0.2, 1.1); //The lower the number the shorter the outer branches are
   branchLengthMulti = random(0.6, 0.95); //How much branches shrink length wise each break
   branchWidthMulti = random(0.4, 0.7); // Same as above except with width
   breezeStrength = random(1)+3; //How strong is the "breeze" that sways the tree
   leafSize = random(15, 30); //Size of the leaves
    trunk = new Branch(this, PI, 0, height/random(2,2.1), trunkWidth, branchesAtBreak, numberOfBreaks); //Creates tree trunk and provides tree info to the rest of the tree

    println("new tree",branchesAtBreak,numberOfBreaks,trunkWidth,branchSpread,branchSplay,branchLengthMulti,branchWidthMulti,breezeStrength,leafSize);
  }
}
 
class Branch {
  float frame = 0;
  boolean endOfBranch = false;
  float xpos, globalAngle, localAngle, branchLength;
  int branchesAtBreak, numberOfBreaks;
  float trunkWidth;
  Branch[] branches = new Branch[0];
  Tree tree;
  float waveOffset = random(-1, 1);
   
  Branch(Tree tempT, float tempGA, float tempLA, float tempL, float tempTW, int tempBAB, int tempNOB) {
    tree = tempT;branchesAtBreak = tempBAB;numberOfBreaks = tempNOB;trunkWidth = tempTW;globalAngle = tempGA;localAngle = tempLA;branchLength = tempL;
    
    if (numberOfBreaks == 0) {
     endOfBranch = true; //Lets tree know once it has hit the end of the branch
    } else {
     endOfBranch = false;
     branches = new Branch[branchesAtBreak];
     float minimumAngle = -((tree.branchSpread*(branchesAtBreak-1))/2); //Calculates minimum angle of a branch
     for (int i=0; i<branches.length;i++) {
       float thisBranchAngle = ((tree.branchSpread * i) + minimumAngle + random(-0.5,0.5))*(tree.branchSplay/numberOfBreaks); //Randomizes angle of branch
       float thisBranchLenDiv = (float) abs(i - ((tree.branchesAtBreak - 1 ) / 2)) + 1; //Number that length of branches are divided by
         branches[i] = new Branch(tree, globalAngle + thisBranchAngle, thisBranchAngle,                     //
                                    (branchLength*tree.branchLengthMulti)/thisBranchLenDiv,                 // Adds child branch
                                    trunkWidth * tree.branchWidthMulti, branchesAtBreak, numberOfBreaks-1); //
     }
    }
    branchLength *= random(0.2, 1.2); //Randomizes trunk length after finishing all other branches
  }
  
  void display(float startX, float startY){
    frame += 0.05;
     float breeze = (sin(frame+waveOffset)/branchLength)*tree.breezeStrength; //Calculates the offset caused by the breeze
     float endX = (float)(startX + (sin((globalAngle+breeze))*branchLength)); //Determines the end position of the branch
     float endY = (float)(startY + (cos((globalAngle+breeze))*branchLength)); // /\
     
     //Draws Branches
     pushMatrix();
     stroke(0);
     strokeWeight(trunkWidth + 1);
     line(startX,startY,endX,endY);
     popMatrix();
 
    //Draws all child branches
     for (int i = 0; i < branches.length; i++){
       branches[i].display(endX,endY);
     }
     
     
     //Draws leaves once you hit the end of the branch
     if (branches.length == 0) { 
       pushMatrix();
       stroke(0);
       strokeWeight(1);
       fill(0);
       ellipse(endX,endY,tree.leafSize,tree.leafSize);
       popMatrix();
     }
   }
}