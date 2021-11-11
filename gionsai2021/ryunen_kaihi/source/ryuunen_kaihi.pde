import ddf.minim.*;

Minim minim;
AudioPlayer BGMop;
AudioSample hit, click, aka;

ME me;
float mx = mouseX;
float my = mouseY;

ArrayList<AKATEN> akatenList = new ArrayList<AKATEN>();
ArrayList<TANI> taniList = new ArrayList<TANI>();
ArrayList<PARTICLE> parList = new ArrayList<PARTICLE>();

PImage pl, akaten, tani, htp, kekka;
PFont jpfont;

int level = 0;
int startlevel = 0;
int bgmlevel = 0;
boolean playon = false;
boolean htpon = false;
boolean backon = false;
boolean next = false;
boolean tanion = true;
boolean titleon = false;
boolean countend = false;

int rakutan = 0;
int gakunen = 0;
int month = 0;
int rectc = 0;
int parsize = 10;

float opGain, hGain, clickGain, akaGain;

int basetime = 0;
int gametime = 0;

void setup(){
  me = new ME();
  
  fullScreen();
  frameRate(144);
  colorMode(RGB);
  rectMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  jpfont = createFont("03スマートフォントUI", 48, true);
  textFont(jpfont);
  
  pl = loadImage("僕.png");
  akaten = loadImage("赤点.png");
  tani = loadImage("単位.png");
  htp = loadImage("あそびかた.png");
  kekka = loadImage("結果.png");
  
  minim = new Minim(this);
  BGMop = minim.loadFile("09_syokkinng.mp3");
  BGMop.loop();
  opGain = BGMop.getGain();
  opGain = opGain - 10;
  BGMop.setGain(opGain);
  
  click = minim.loadSample("kettei-01.wav");
  clickGain  = click.getGain();
  clickGain  = clickGain - 10;
  click.setGain(clickGain);
  
  hit = minim.loadSample("glass-break4.mp3");
  hGain  = hit.getGain();
  hGain  = hGain - 10;
  hit.setGain(hGain);
  
  aka = minim.loadSample("se_maoudamashii_system45.mp3");
  akaGain  = aka.getGain();
  akaGain  = akaGain - 10;
  aka.setGain(akaGain);
}

void draw(){
  background(255);
  
  // タイトル
  if (level == 0){
    
    fill(255, 0, 0);
    textSize(128);
    text("留年回避", width/2, 400);
    textSize(64);
    fill(0);
    text("入学", width/2, 650);
    text("あそびかた", width/2, 800);
    rakutan = 0;
    gakunen = 0;
    month = 0;
    
    if(bgmlevel == 0){
      BGMop.rewind();
      BGMop.loop();
      bgmlevel = 1;
    }
    
    if (startlevel == 0){
      if(abs(mouseX-width/2) < (10+500)/2 && abs(mouseY-625) < (10+100)/2){
        fill(255, 0, 0, 100);
        noStroke();
        rect(width/2, 625, 500, 100);
        playon = true;
      }else if(abs(mouseX-width/2) < (10+500)/2 && abs(mouseY-775) < (10+100)/2){
        fill(255, 0, 0, 100);
        noStroke();
        rect(width/2, 775, 500, 100);
        htpon = true;
      }else{
        playon = false;
        htpon = false;
      }
    }else if(startlevel == 2){
      image(htp, width/2, height/2);
      if(abs(mouseX-width/2) < (10+300)/2 && abs(mouseY-825) < (10+80)/2){
        fill(255, 0, 0, 100);
        noStroke();
        rect(width/2, 825, 300, 80);
        backon = true;
      }else{
        backon = false;
      }
    }
    basetime = millis();
  }
  
  if(level == 1){   
    startlevel = 0;
    int time = millis()-basetime;
    int countdown = 6 - (time/1000);
    
    if(tanion){
      for(int i = 0; i < 5; i++){
        taniList.add(new TANI());
      }
      tanion = false;
    }
    // 単位を表示
    for (int i = taniList.size()-1; i >= 0; i--) {
      TANI t = taniList.get(i);
      t.display();
    }
    
    me.move(mouseX, mouseY);
    me.display();
    fill(0);
    textSize(32);
    text("TIME", 100, 50);
    textSize(64);
    text("30",100,110);
    
    textSize(32);
    text("落単数", 100, 200);
    textSize(64);
    text("0", 100, 260);
    
    if(countdown >= 2){
      fill(0, 100);
      textSize(256);
      text(countdown-1, width/2, height/2);
    }else if(countdown <= 1 && countdown > 0){
      fill(0, 100);
      textSize(256);
      text("はじめ", width/2, height/2);
    }else{
      next = true;
    }
    if(next){
      next = false;
      level = 2;
    }
    gametime = millis();
  }
  
  if(level == 2){ // ゲームプレイ
    
    int time = millis()-gametime;
    int countdown = 30 - (time/1000);
    
    // パーティクル
    for (int m = parList.size()-1; m >= 0; m--) {
      PARTICLE p = parList.get(m);
      if (p.isDead()) {
        p.move();
        p.display();
      } else {
        parList.remove(m);
      }
    }
    
    // 単位を表示
    for (int i = taniList.size()-1; i >= 0; i--) {
      TANI t = taniList.get(i);
      t.display();
    }
    
    // 赤点が画面外に出たら消す
    for (int i = akatenList.size()-1; i >= 0; i--) {
      AKATEN a = akatenList.get(i);
      if (a.isAlive()) {
        a.move();
        a.display();
      } else {
        akatenList.remove(i);
      }
    }
    
    // 赤点と僕の当たり判定
    for (int j = 0; j <= akatenList.size()-1; j++) {
      AKATEN a = akatenList.get(j);
      if (abs(a.ax-me.mx) < (a.awi+me.mwi)/2 && abs(a.ay-me.my) < (a.ahe+me.mhe)/2) {
          akatenList.remove(j);
          aka.trigger();
      }
    }
    
    // 赤点と単位の当たり判定
    for (int i = 0; i <= akatenList.size()-1; i++) {
      AKATEN a = akatenList.get(i);
      for (int j = 0; j <= taniList.size()-1; j++) {
        TANI t = taniList.get(j);
        if (abs(t.tx-a.ax) < (t.twi+a.awi)/2 &&
          abs(t.ty-a.ay) < (t.the+a.ahe)/2) {
            for (int k = 0; k <= parsize; k++) {
              parList.add(new PARTICLE(t.tx, t.ty));
            }
            akatenList.remove(i);
            taniList.remove(j);
            taniList.add(new TANI());
            hit.trigger();
            rakutan += 1;
        }
      }
    }
    
    // 自機の表示
    me.move(mouseX, mouseY);
    me.display();
    
    fill(0);
    textSize(32);
    text("TIME", 100, 50);
    if(countend == false){
      textSize(64);
      text(countdown,100,110);
    }
    
    textSize(32);
    text("落単数", 100, 200);
    textSize(64);
    text(rakutan, 100, 260);
    
    if (frameCount % 20 == 0){
      akatenList.add(new AKATEN());
    }
    
    if(countdown <= 0 && countdown > -3){
      countend = true;
      text("0",100,110);
      text("おわり", width/2, height/2);
      akatenList.clear();
      taniList.clear(); 
      parList.clear();
    }else if(countdown <= -3){
      countend = false;
      level = 3;
    }
  }
  
  if(level == 3){
    image(kekka, width/2, height/2);
    textSize(64);
    fill(0);
    text(rakutan, width/2, 575);
    
    textSize(100);
    if(rakutan == 0) text("完璧高専生", width/2, 725);
    else if(rakutan <= 4) text("普通の高専生", width/2, 725);
    else if(rakutan <= 6) text("ギリギリ高専生", width/2, 725);
    else if(rakutan <= 12) text("仮進級高専生", width/2, 725);
    else if(rakutan > 12) text("さよなら高専", width/2, 725);
    
    if(abs(mouseX-width/2) < (10+300)/2 && abs(mouseY-825) < (10+80)/2){
      fill(255, 0, 0, 100);
      noStroke();
      rect(width/2, 825, 300, 80);
      titleon = true;
    }else{
      titleon = false;
    }
  }
}

void mousePressed(){
  if(level == 0){
    if(mouseButton == LEFT){
      if(playon){
        click.trigger();
        playon = false;
        level = 1;
      }
      if(htpon){
        click.trigger();
        htpon = false;
        startlevel = 2;
      }
      if(backon){
        click.trigger();
        backon = false;
        startlevel = 0;
      }
    }
  }else if(level == 3){
    if(mouseButton == LEFT){
      if(titleon){
        bgmlevel = 0;
        click.trigger();
        titleon = false;
        tanion = true;
        level = 0;
      }  
    }
  }
}
