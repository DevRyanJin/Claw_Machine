//arm 
float armBoxX; 
float armBoxY; 
float armBoxAngleX; 
float armBoxAngleY; 
float armBoxSpeedY; 
float armBoxAngleZ; 
final int armWidth = 400; 
final int armheight = 20;

//first box right below arm 
float box1X; 
float box1XSpeed; 
float box1Y;
final int box1Width = 40;
final int box1Height= 40;
final int box1Depth= 40;

//second box hanging from the line 
final int box2Width = 20;
final int box2Height= 20;
final int box2Depth= 20;

//line between two box
float interLineY; 
float interLineYSpeed; 
int   inilLength = 30;
int   maxLength = 200;
float interLineStart =box1Height+inilLength; 

//gripper 
float rotClawAngle = 0;
float rotClawSpeed = 0;
//gripper1
float clawAngle =0; 
float clawAngleSpeed  = 0;
//gripper2
float clawAngle2 =0;
float claw2AngleSpeed = 0;

//prize color and size 
color[] prizeColor = new color[110];
int[] prizeSize = new int[110];

//these variables to control and store if the correspoding key has been pressed. 
int isQpressed =0;
int isWpressed =0; 
int isEpressed =0; 
int isRpressed =0; 
int isApressed =0; 
int isZpressed =0; 
int isXpressed =0; 
int isCpressed =0; 
int isSpressed =0; 
int isDpressed =0; 

boolean isSpacePressed = false;
float startTime; //store the time when spacebar is is pressed 

void setup() {
  size(640, 640, P3D);
  
  //setting initial position and proper value 
  armBoxX = width/2; 
  armBoxY = 30;
  armBoxAngleX = -0.5;
  armBoxAngleY = 0.5; 
  armBoxSpeedY = 0;
  armBoxAngleZ = 0;
  box1X = -armWidth/2; 
  box1XSpeed =0;
  box1Y = 30;
  interLineY =30; 
  interLineYSpeed =0;
  clawAngle =0.5;
  clawAngle2 =0;


  for (int i=0; i<110; i++) {
    prizeColor[i] = color(random(0, 255), random(0, 255), random(0, 255));
    prizeSize[i] = (int)random(10, 30);
  }
  
}
void draw() {
  background(0, 50, 150);
  
  // changing view 
  if(key =='1'){
    beginCamera();
    camera();
    endCamera(); 
  } else if(key == '2'){
     camera(width/2+40, -600, -armWidth/2, width/2+40, height/2, -armWidth/2-0.1, 0.0, -1, 0.0);
  }else if(key == '3'){
     camera(-500, 500, 300, width/2, height/2, -300, -1, 1, 0);
  }

  //changing either ortho or perspective projection 
  if(key == 'o'){
   ortho(-450.0, 450.0, -450.0, 450.0,-1500,1500);
  }else if(key == 'p'){
    float viewAngle = PI/3;
    float Z = (height) / tan(viewAngle);
    perspective(viewAngle, float(width)/float(height-100), 
            Z/10.0, Z*10.0);

  }
  

//draw the claw machine 
  stroke(255, 255, 255);
  strokeWeight(1);
  pushMatrix();
  rotateX(-0.5);
  pushMatrix();
  translate(width/2, 40, -armWidth/2+30);
  drawTopBox();
  popMatrix();
  translate(armBoxX, armBoxY+50, -armWidth/2);
  drawArm();
  translate(box1X, box1Y);
  drawBox1();
  translate(0, interLineStart);
  drawInterLine();
  translate(0, interLineY);
  rotateY(rotClawAngle);
  drawClaw();  
  drawBox2();
  popMatrix(); 


//when correspoding key invoking the event has been pressed, start animation if it satisfies the condition 
//if spacebar was pressed and its seqeunce did not finish yet, any keypressed is not allowed 
if(!isSpacePressed){

  armBoxAngleY += armBoxSpeedY;
  armBoxAngleZ += armBoxSpeedY; 

  box1X += box1XSpeed;

  if (box1X == armWidth/2 ||box1X == -armWidth/2)
    box1XSpeed =0;

  interLineY += interLineYSpeed;

  if (interLineY <= -inilLength || interLineY >= maxLength )
    interLineYSpeed =0;


  rotClawAngle += rotClawSpeed;


  clawAngle += clawAngleSpeed;
  clawAngle2 += claw2AngleSpeed;

  if (clawAngle>=1.1) {
    clawAngleSpeed =0;
    claw2AngleSpeed =0;
  }

  if (clawAngle<=0.5) {
    clawAngleSpeed =0;
    claw2AngleSpeed =0;
  }
}


// if space is pressed, then cause the sequece of jobs based on the time.  
if(isSpacePressed){

  // gripper open will take 2.5 sec 
  if(millis() <startTime +2500){

   if (clawAngle >= 0.5) {
      clawAngle -= 0.005;
      clawAngle2 -= 0.008;
    }
  }
 
 // cable drop will take 4 sec 
  if(millis()>= startTime+2500 && millis()<startTime+6000){

   if (interLineY <=maxLength) {
      interLineY += 1;
    }
  }

 // gripper close will take 2.5 sec
  if(millis()>= startTime+6000 && millis()<startTime+8500){
   
    if (clawAngle <= 1.1) {
      clawAngle += 0.005;
      clawAngle2 += 0.008;
    }
  }
  
  //cable back will take 4 sec 
 if(millis()>= startTime+8500 && millis()<startTime+12500){
   
    if (interLineY >= -inilLength) {
      interLineY -=1;
    }
  }
  
  //after finishing all required operations, set back spacePressed to false
  if(millis()>= startTime+13000){
   
    isSpacePressed = false;
  }
  
}


//draw prizes 
 int prizesX = 150; 
  for (int i=0; i<100; i++)
  {
    pushMatrix();
        rotateX(-0.5);

    if (i<10)
      translate(prizesX+(40*i), height-160, -armWidth/2); 
    else if (i<20)
      translate(prizesX+(40*(i%10)), height-160, -armWidth/2+40 );
    else if (i<30)
      translate(prizesX+(40*(i%10)), height-160, -armWidth/2+80 );
    else if (i<40)
      translate(prizesX+(40*(i%10)), height-160, -armWidth/2+120 );
    else if (i<50)
      translate(prizesX+(40*(i%10)), height-160, -armWidth/2+160);
    else if (i<60)
      translate(prizesX+(40*(i%10)), height-160, 0 );  
    else if (i<70)
      translate(prizesX+(40*(i%10)), height-160, 40 );
    else if (i<80)
      translate(prizesX+(40*(i%10)), height-160, 80 );
    else if (i<90)
      translate(prizesX+(40*(i%10)), height-160, 120 );
    else if (i<100)
      translate(prizesX+(40*(i%10)), height-160, 160 );
     else if (i<110)
      translate(prizesX+(40*(i%10)), height-160, 200 );
    prizes(i);
    popMatrix();
  }

}

void drawTopBox() {
  strokeWeight(1);
  fill(0);
  box(110, 50, 50);
}

void drawArm() {
  strokeWeight(1);
  stroke(255);
  fill(150, 150, 150);
  //rotateX(-0.5);
  rotateY(armBoxAngleY);
  box(armWidth, 20, 20);
}

void drawBox1() {
  strokeWeight(1);
  stroke(255);
  fill(10, 10, 150);
  box(box1Width, box1Height, box1Depth);
}


void drawInterLine() {
  stroke(255, 255, 0);
  strokeWeight(5);
  beginShape(LINE_STRIP);
  vertex(0, -interLineStart);
  vertex(0, interLineY);
  endShape();
}


void drawBox2() { 
  strokeWeight(1);
  noStroke();
  fill(180, 50, 50);
  beginShape(QUADS);
  fill(255,0,0);
  vertex(-box2Width,-box2Height,box2Depth);
  vertex(-box2Width,box2Height,box2Depth);
  vertex(box2Width,box2Height,box2Depth);
  vertex(box2Width,-box2Height,box2Depth);

  fill(0,255,0);
  vertex(box2Width,-box2Height,box2Depth);
  vertex(box2Width,-box2Height,-box2Depth);
  vertex(box2Width,box2Height,-box2Depth);
  vertex(box2Width,box2Height,box2Depth);

  fill(0,0,255);
  vertex(box2Width,-box2Height,-box2Depth);
  vertex(-box2Width,-box2Height,-box2Depth);
  vertex(-box2Width,box2Height,-box2Depth);
  vertex(box2Width,box2Height,-box2Depth);

  fill(0,255,255);
  vertex(-box2Width,-box2Height,-box2Depth);
  vertex(-box2Width,-box2Height,box2Depth);
  vertex(-box2Width,box2Height,box2Depth);
  vertex(-box2Width,box2Height,-box2Depth);

  fill(255,0,255);
  vertex(-box2Width,box2Height,box2Depth);
  vertex(box2Width,box2Height,box2Depth);
  vertex(box2Width,box2Height,-box2Depth);
  vertex(-box2Width,box2Height,-box2Depth);

  fill(200,100,150);
  vertex(box2Width,-box2Height,box2Depth);
  vertex(-box2Width,-box2Height,box2Depth);
  vertex(-box2Width,-box2Height,-box2Depth);
  vertex(box2Width,-box2Height,-box2Depth);

  endShape();

}

void drawClaw() {
  strokeWeight(1);
  noStroke();
  fill(200, 200, 200);

  pushMatrix();
  rotateZ(clawAngle-clawAngleSpeed);
  translate(30, 0);
  box(40, 10, 10);
  translate(30, 0);
  sphere(10);
  rotateZ(clawAngle2-claw2AngleSpeed);
  translate(30, 0);
  box(40, 10, 10);
  popMatrix();
  
  
  pushMatrix();
  rotateZ(-clawAngle+clawAngleSpeed);
  translate(-30, 0);
  box(40, 10, 10);
  translate(-30, 0);
  sphere(10);
  rotateZ(-clawAngle2+claw2AngleSpeed);
  translate(-30, 0);
  box(40, 10, 10);
  popMatrix();
}



void prizes(int i) {
  strokeWeight(0.3);
  stroke(255);
  fill(prizeColor[i]);
  rotateY(-2);
  box(prizeSize[i], prizeSize[i], 20);
}

void keyPressed() {
  if(key == ' '){
    isSpacePressed = true;   
    startTime =millis(); // save the time when space is pressed 
  }


if(!isSpacePressed){
  if (key =='q') {
    if (isQpressed == 0) {
      armBoxSpeedY = -0.01;
      isQpressed =1;
    } else {
      armBoxSpeedY = 0;
      isQpressed =0;
    }
  }

  if (key =='w') {
    if (isWpressed == 0) {
      armBoxSpeedY = +0.01;
      isWpressed =1;
    } else {
      armBoxSpeedY = 0;
      isWpressed =0;
    }
  }

  if (key =='e') {
    if (box1X == -armWidth/2)
      box1XSpeed =0; 
    else if (isEpressed == 0) {
      box1XSpeed = -1; 
      isEpressed =1;
    } else {
      box1XSpeed = 0; 
      isEpressed =0;
    }
  }

  if (key =='r') {
    if (box1X == armWidth/2)
      box1XSpeed =0; 
    else if (isRpressed == 0) {
      box1XSpeed = 1; 
      isRpressed =1;
    } else {
      box1XSpeed = 0; 
      isRpressed =0;
    }
  }

  if (key =='a') {
    if (isApressed == 0) {
      interLineYSpeed = -1;
      isApressed =1;
    } else {
      interLineYSpeed=0;
      isApressed =0;
    }
  }

  if (key =='z') {
    if (isZpressed == 0) {
      interLineYSpeed =1;
      isZpressed =1;
    } else {
      interLineYSpeed=0;
      isZpressed =0;
    }
  }

  if (key =='s') {
    if (isSpressed == 0) {
      rotClawSpeed = -0.01;
      isSpressed =1;
    } else {
      rotClawSpeed = 0;
      isSpressed =0;
    }
  }

  if (key =='d') {
    if (isDpressed == 0) {
      rotClawSpeed = +0.01;
      isDpressed =1;
    } else {
      rotClawSpeed = 0;
      isDpressed =0;
    }
  }



  if (key =='c') {
    if (clawAngle >= 1) {
      clawAngleSpeed =0;
      claw2AngleSpeed =0;
    } else if (isCpressed == 0) {
      clawAngleSpeed = 0.005;
      claw2AngleSpeed = 0.008;
      isXpressed =1;
    } else {
      clawAngleSpeed=0;
      claw2AngleSpeed =0;
      isCpressed =0;
    }
  }

  if (key =='x') {
    if (clawAngle <= 0.5) {
      clawAngleSpeed =0;
      claw2AngleSpeed =0;
    } else if (isXpressed == 0) {
      clawAngleSpeed = -0.005;
      claw2AngleSpeed = -0.008;
      isXpressed =1;
    } else {
      clawAngleSpeed=0;
      claw2AngleSpeed =0;
      isXpressed =0;
    }
  }
}
}