class ME {
  float mx = width/2, my = height/2;
  float mwi = 25;
  float mhe = 25;

  void move(float x, float y) {
    mx = x;
    my = y;
    mx = constrain(mx, 330, width - 330);
  }

  void display() {
    fftgm.forward(BGMgm.mix);
    for (int i = 0; i < fftgm.specSize(); i++) {
      float elSize = map(fftgm.getBand(i), 0, fftSize, 0, width/2);
      float green = elSize*1.5;

      fill(260, 131, 40);
      noStroke();
      image(pl, mx, my);


      fill(0, 255-green, 0);
      noStroke();
      ellipse(mx, my, elSize, elSize);
    }
  }
}
