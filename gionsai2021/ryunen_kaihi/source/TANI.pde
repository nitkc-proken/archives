class TANI {
  float tx;
  float ty;
  float twi;
  float the;
  
  TANI(){
    tx = random(350, width-350);
    ty = random(350, height-350);
    the = 100;
    twi = 200;
  }
  
  void display() {
    image(tani, tx, ty, twi, the);
  }
  
}
