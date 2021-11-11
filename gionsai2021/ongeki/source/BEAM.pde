class BEAM {
  float bx;
  float by;
  float bvel;
  float bwi;
  float bhe;
  float ex;
  float ey;
  float ehe;

  BEAM(float x, float y) {
    bx = x;
    by = y;
    bwi = 5;
    bhe = 50;
    bvel = 30;
  }

  void move() {
    by -= bvel;
  }

  void display() {
    noFill();
    strokeWeight(1);
    stroke(37, 149, 199);
    rect(bx, by, bwi, bhe);
  }

  boolean isAlive() {
    if (bx+bwi/2 < 0 || width < bx-bwi/2 || by+bhe/2 < 0 || height < by-bhe/2) {
      return false;
    }
    return true;
  }
}

class E_BEAM {
  float bx;
  float by;
  float bvel;
  float bwi;
  float bhe;
  float ex;
  float ey;
  float ehe;

  E_BEAM(float x, float y) {
    bx = x;
    by = y;
    bwi = 10;
    bhe = 50;
    bvel = 20;
  }

  void move() {
    by += bvel;
  }

  void display() {
    stroke(255, 0, 0);
    strokeWeight(1);
    noFill();
    rect(bx, by, bwi, bhe);
  }

  boolean isAlive() {
    if (bx+bwi/2 < 0 || width < bx-bwi/2 || by+bhe/2 < 0 || height < by-bhe/2) {
      return false;
    }
    return true;
  }
}
