class Mover {
  PFont font;

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  //float maxSpeed;
  float rad;

  // for perlin noise
  float increment = 0.05;
  float xoff = random(0,1000);
  float yoff = random(0,1000);
  PImage moverImage;
  //float c; //color
  // PVector hoverOver;


  Mover(float m, float x, float y, PImage _moverImage) {
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    // hoverOver= new PVector (hOx,hOy);
    acceleration = new PVector(0, 0);
    //c = Col;
    moverImage = _moverImage;
    //maxSpeed = 4;
    font = loadFont("AGaramondPro-Bold-15.vlw");
  }

  void setProperties(float _mass, float _radius) {
    mass = _mass;
    rad = _radius;
  }

  void applyForce(PVector force) {
    //[full] Receive a force, divide by mass, and add to acceleration.
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }


  void update() {
    //acceleration = PVector.random2D(); 
    //acceleration.mult(noise(xoff)*2);
    //xoff += increment; 

    velocity.add(acceleration);
    //velocity.limit(maxSpeed);
    location.add(velocity);
    //velocity.add(acceleration);
    //location.add(velocity);
    acceleration.mult(0);
  }


  void display() {
    //fill(255, 70);
    //textFont(font, 500);
    //text("TEST", 10, 10);
    float xPerlin = noise(xoff);
    xoff += increment; 
    float yPerlin = noise(yoff);
    yoff += increment; 


    if ( dist(location.x, location.y, mouseX, mouseY)< mass ) {
      //strokeWeight(5);
      //stroke(255,166,0,100);
      //fill(c);
      //ellipse(location.x,location.y,mass*20,mass*20);
      //image(moverImage, location.x+xPerlin, location.y+yPerlin, mass*1.2, mass*1.2);
      image(moverImage, location.x+xPerlin, location.y+yPerlin, rad*1.2, rad*1.2*1.5);
      //fill(255);
      //textFont(font, 15);
      //text(round(mass), location.x, location.y);
    }

    else {
      noStroke();
      //fill(c);
      //ellipse(location.x,location.y,mass*16,mass*16);
      //image(moverImage, location.x+xPerlin, location.y+yPerlin, mass*0.6, mass*0.6);
      image(moverImage, location.x+xPerlin, location.y+yPerlin, rad*0.6, rad*0.6*1.5);
    }
  }

  void displayText(){
      fill(255);
      textFont(font, 15);
      text(round(mass), location.x, location.y);
  }

  void checkEdges() {
    if (location.x > width-340) {
      location.x = width-340;
      velocity.x *= -1;
    } 
    else if (location.x < 300) {
      velocity.x *= -1;
      location.x =300;
    }

    if (location.y > 650) {
      velocity.y *= -1;
      location.y = 650;
    }
  }


  boolean isInside(Liquid l) {
    //[offset-down] This conditional statement determines if the PVector location is inside the rectangle defined by the Liquid class.
    if (location.x>l.x && location.x<l.x+l.w && location.y>l.y && location.y<l.y+l.h)
    {
      return true;
    } 
    else {
      return false;
    }
  }
  
  
   void drag(Liquid l) {

    float speed = velocity.mag();
    // The force’s magnitude: Cd * v~2~
    float dragMagnitude = l.c * speed * speed;

    PVector drag = velocity.get();
    drag.mult(-1);
    // The force's direction: -1 * velocity
    drag.normalize();

    // Finalize the force: magnitude and direction together.
    drag.mult(dragMagnitude);

    // Apply the force.
    applyForce(drag);
  }
  
  void applyBouyancy(Liquid l){
    float volume = rad*rad*rad;
    PVector bouyForce = new PVector(0, -l.liquidDensity*volume*0.1);
    applyForce(bouyForce);
  }
  
}

int numOfMovers = 8;
Mover[] movers = new Mover[numOfMovers];
PImage[] moverImages = new PImage[numOfMovers];
String[] InsuranceTypes = {
  "Total Covered", "Total Private", "Private Empl", "Private Direct", 
  "Govt Total", "Govt Medicaid", "Govt Medicare", "Govt Military", "Not Covered"
};
String currentInsuranceType = InsuranceTypes[8];
int currInsuranceIndex = 8;

Table InsuranceTable; 
float[] avgByInsuranceType = new float[InsuranceTypes.length];

float coff = random(0, 200);
int colorRange = 50;
PImage img;

Liquid liquid;

void setup() {
  size(1280, 780);
  frameRate(15);



  //loading the data
  InsuranceTable = loadTable("FinalHealthInsuranceTable.csv");
  InsuranceTable.removeTitleRow();
  
  //find average in each insurance type categpry

  
  for(int i = 0; i < InsuranceTypes.length; i++){
      float avg = 0.0;
      for (int j = 0; j < 8; j++) {
        avg = avg + InsuranceTable.getFloat(j+2, InsuranceTypes[i]);
      }
      avgByInsuranceType[i] = avg/8.0;
  }
  

  //loading Images
  img = loadImage("capsule.png");
  moverImages[0] =loadImage("whiteFemale.png");
  moverImages[1]  =loadImage("whiteMale.png");
  moverImages[2]  =loadImage("asianFemale.png");
  moverImages[3]  =loadImage("asianMale.png");
  moverImages[4] =loadImage("blackFemale.png");
  moverImages[5]  =loadImage("blackFemale.png");
  moverImages[6]  =loadImage("hispanicFemale.png");
  moverImages[7]  =loadImage("hispanicMale.png");

  //initializing movers
  float x = 340;
  for (int i = 0; i < numOfMovers; i++) {

    movers[i] = new Mover(random(1, 5), x, 0, moverImages[i]);  //Mover(float m, float x , float y, float Col)
    x+=83;
  }

  //initializing liquid
  float coeffOfDrag = 1.0;
  float liqDensity = 0.0005;
  liquid = new Liquid(300, 205, 660, 455, coeffOfDrag, liqDensity);
}


void draw() {

  //PFont font = loadFont("AGaramondPro-Bold-15.vlw");
  //fill(255);
  //textFont(font, 50);
  //text("TEST",10, 50);
  //background Img
  image(img, 0, 0, width, height);

  for (int i = 0; i < 8; i++) {
    movers[i].setProperties(InsuranceTable.getFloat(i+2, currentInsuranceType), avgByInsuranceType[currInsuranceIndex]);
  }


  for (int i = 0; i < movers.length; i++) {

    float m = movers[i].mass;

    if (movers[i].isInside(liquid)) {
      movers[i].drag(liquid);
      movers[i].applyBouyancy(liquid);
      movers[i].displayText();
    }
    //Scaling gravity by mass to be more accurate
    PVector gravity = new PVector(0, 0.1*m);
    //PVector wind = new PVector(0.001, 0);

    //movers[i].applyForce(wind);
    movers[i].applyForce(gravity);

    movers[i].update();
    movers[i].display();
    movers[i].checkEdges();

    /*
    // draw a line if two circles come close
     for (int k = i+1; k < movers.length; k++) {
     // the distance of 2 vectors
     float distance = PVector.dist(movers[i].location, movers[k].location);    
     
     if (distance<150) {
     pushMatrix();
     colorMode(HSB, 100, 100, 100, 100);
     strokeWeight(0.7);
     stroke(noise(coff)*colorRange, 40, 100, random(100, 150));
     line( movers[i].location.x, movers[i].location.y, movers[k].location.x, movers[k].location.y);
     coff += 0.01; 
     popMatrix();
     }
     }
     */
  }
}

void mousePressed() {

  currentInsuranceType = InsuranceTypes[0];
  currInsuranceIndex = 0;
  for (int i = 0; i <= 8; i++) {
    if (mouseX > 0+i*10 & mouseX < 10+i*10 & mouseY > 0 & mouseY < 10) {
      currentInsuranceType = InsuranceTypes[i];
      currInsuranceIndex = i;
    }
  }
}

class Liquid {
  

  float x,y,w,h;
  float c;
  float liquidDensity;
 
  Liquid(float x_, float y_, float w_, float h_, float coeffOfDrag, float liquidDensity_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = coeffOfDrag;
    liquidDensity = liquidDensity_;
  }
 
  /*
  void display() {
    noStroke();
    fill(175);
    rect(x,y,w,h);
  }
  */
 
}


