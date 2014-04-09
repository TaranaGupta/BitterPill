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
  float liqDensity = 0.05;
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
      
      if (random(1) < 0.05) {
        movers[i].applyBouyancy(liquid);
      }
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

