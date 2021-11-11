class ENEMY {
  float ex;
  float ey;
  float evely;
  float evelx;
  float ewi;
  float ehe;
  float swei;
  int mode; // 0:通常 1:揺れ

  ENEMY(int m) {
    ex = random(350, width-350);
    ey = 0;
    evely = random(5, 10);
    evelx = random(-5, 5);
    ehe = 50;
    ewi = 50;
    mode = m;
  }

  void move() {
    ey += evely;
    if(mode == 1){
      ex += evelx;
    }
  }

  void display() {
    if(mode == 0){
      image(en, ex, ey);
    }else if(mode == 1){
      image(en2, ex, ey);
    }
  }

  boolean isAlive() {
    if (ex+ewi/2 < 0 || width < ex-ewi/2 || ey+ehe/2 < 0 || height < ey-ehe/2) {
      return false;
    }
    return true;
  }
}
