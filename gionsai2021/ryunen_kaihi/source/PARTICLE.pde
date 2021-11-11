class PARTICLE {
  float posx, posy;
  float pos;
  float vely, velx;  
  float mvely, mvelx;
  float rad;
  float lifespan;

  PARTICLE(float x, float y) {
    posx = x;
    posy = y;
    rad = 2.0;
    vely = random(-10, 10);
    velx = random(-10, 10);
    rad = 20;
    lifespan = 255;
  }

  void move() {
    posx += velx;
    posy += vely;
    lifespan -= 5.0;
  }

  void display() {
      stroke(126, 199, 216, lifespan);
      fill(126, 199, 216, lifespan);
      rect(posx, posy, rad, rad);
  }

  boolean isDead() {
    if (lifespan < 0) {
      return false;
    } else {
      return true;
    }
  }
}
