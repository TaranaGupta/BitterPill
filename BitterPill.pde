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
    float volume = rad*rad*rad; // multiply by sin(angle) ??
    PVector bouyForce = new PVector(0, -l.liquidDensity*volume*0.1);
    applyForce(bouyForce);
  }
  
}

