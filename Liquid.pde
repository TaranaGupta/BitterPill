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

