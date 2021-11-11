class ME {
  float mx = width/2, my = height/2;
  float mwi = 100;
  float mhe = 100;
  
  void move(float x, float y) {
    mx = x;
    my = y;
  }
  
  void display(){
    image(pl, mx, my, mwi, mhe);
  }
}
