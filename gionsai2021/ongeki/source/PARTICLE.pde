class PARTICLE {
  float posx, posy;
  float pos;
  float vely, velx;  
  float mvely, mvelx;
  float rad;
  float lifespan;
  int mode;

  PARTICLE(float x, float y, int m) {
    posx = x;
    posy = y;
    rad = 2.0;
    mvely = random(5, 10);
    mvelx = random(-5, 5);
    vely = random(15, 25);
    velx = random(-2, 2);
    rad = 20;
    lifespan = 255;
    mode = m;
  }

  void move() {
    if (mode == 1){
      posx += mvelx;
      posy += mvely;
    }else{
      posx += velx;
      posy += vely;
    }
    lifespan -= 5.0;
  }

  void display() {
    if(mode == 0){ // enemy
      stroke(188, 2, 11, lifespan);
      fill(188, 2, 11, lifespan);
      rect(posx, posy, rad, rad);
    }else if(mode == 1){ // me
      stroke(126, 199, 216, lifespan);
      fill(126, 199, 216, lifespan);
      rect(posx, posy, rad, rad);
    }else if(mode == 2){ // op
      stroke(255, lifespan);
      fill(255, lifespan);
      rect(posx, posy, rad, rad);
    }
  }

  boolean isDead() {
    if (lifespan < 0) {
      return false;
    } else {
      return true;
    }
  }
}
