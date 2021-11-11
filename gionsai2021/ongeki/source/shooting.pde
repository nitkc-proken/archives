import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;

Minim minim;
AudioPlayer BGMgm, BGMop;
AudioSample laser, hit, mhit, point, click;
FFT fftgm, fftop;
int fftSize = 1024;

PImage pl, en, en2, scopr, gameline, opline, resultline, setting;

float mx = mouseX;
float my = mouseY;
int level = 0;
int bgmlevel = 0;
ME me;
float ex1;
float ey1;
ArrayList<BEAM> beamList = new ArrayList<BEAM>();
ArrayList<E_BEAM> e_beamList = new ArrayList<E_BEAM>();
ArrayList<ENEMY> enemyList = new ArrayList<ENEMY>();
ArrayList<PARTICLE> parList = new ArrayList<PARTICLE>();
float bvel;
float bx;
float by;
float gmGain, opGain;
float bGain, hGain, mhGain, pointGain, clickGain;
int flag;
boolean right;
int score = 0;
int damage = 0;
int totalscore = 0;
int parSize = 10;
int deadlevel = 0;
PFont sc;
int uileft = 300;
int uiright = width - 300;
int basetime;
boolean next = false;
int gametime;
boolean playon = false; // playボタンが押された時
boolean settingon = false; // settingボタンが押された時
boolean backon = false; // 戻るボタンが押された時
int pointlevel = 0;
int startlevel = 0;
int rectc = 0; // 透明度
float reftmegaX = 385;
float reftmegaY = 995; 
float rightmegaX = 1535; 
float rightmegaY = 995; 
int alpha = 0; // 画像の透明度
STAR[] stars = new STAR[300]; // 背景の星の配列


void setup() {
  fullScreen();
  frameRate(144);
  colorMode(RGB);
  rectMode(CENTER);
  me = new ME();
  textAlign(CENTER);
  imageMode(CENTER);
  sc = createFont("Quantum.otf",48);
  textFont(sc, 48);
  pl = loadImage("onpu.png");
  en = loadImage("enemy.png");
  en2 = loadImage("enemy2.png");
  scopr = loadImage("score.png");
  gameline = loadImage("gameline.png");
  opline = loadImage("opline.png");
  resultline = loadImage("resultui.png");
  setting = loadImage("setting.png");
  minim = new Minim(this);
  laser = minim.loadSample("laser1.mp3");
  hit = minim.loadSample("hit.wav");
  mhit = minim.loadSample("mhit.mp3");
  point = minim.loadSample("ボタンポインタ.mp3");
  click = minim.loadSample("ボタンクリック.mp3");
  BGMgm = minim.loadFile("BGM1.mp3");
  BGMop = minim.loadFile("BGM2.mp3");
  gmGain = BGMgm.getGain();
  gmGain = gmGain - 15;
  BGMgm.setGain(gmGain);
  BGMop.loop();
  opGain = BGMop.getGain();
  opGain = opGain - 15;
  BGMop.setGain(opGain);
  bGain  = laser.getGain();
  bGain  = bGain - 40;
  laser.setGain(bGain);
  hGain  = hit.getGain();
  hGain  = hGain - 10;
  hit.setGain(hGain);
  mhGain  = mhit.getGain();
  mhGain  = mhGain - 20;
  mhit.setGain(mhGain);
  pointGain  = point.getGain();
  pointGain  = pointGain - 20;
  point.setGain(pointGain);
  clickGain  = click.getGain();
  clickGain  = clickGain - 20;
  click.setGain(clickGain);
  fftgm = new FFT(BGMgm.bufferSize(), BGMgm.sampleRate());
  fftop = new FFT(BGMop.bufferSize(), BGMop.sampleRate());
    for(int i = 0; i < stars.length; i++){
    stars[i] = new STAR();
  }
}

void draw() {
  background(0);
    for(int i = 0; i < stars.length; i++){
    stars[i].fall();
    stars[i].display();
  }
  // タイトル
  if (level == 0) {
    titleUI();
    for (int m = parList.size()-1; m >= 0; m--) {
      PARTICLE p = parList.get(m);
      if (p.isDead()) {
        p.move();
        p.display();
      } else {
        parList.remove(m);
      }
    }
    if(frameCount % 2 == 0){
      for(int i = 0; i < parSize/5; i++){
        parList.add(new PARTICLE(me.mx, me.my, 2));
      }  
    }
    me.move(random(548, 552), height-200);
    me.display();
    if (bgmlevel == 0) {
      BGMop.rewind();
      BGMop.loop();
      bgmlevel = 1;
    }
    score = 0;
    damage = 0;
    totalscore = 0;
    if(startlevel == 0){ // normal
      if(abs(mouseX-1470) < (10+700)/2 &&
         abs(mouseY-550) < (10+150)/2){
         pointlevel += 1;
        if(pointlevel == 1){
          point.trigger();
        }
        fill(126, 199, 216,100);
        rect(1470, 550, 700, 150);
        noStroke();
        fill(255, 243, 184,100);
        for(int i = 0; i <= 50; i +=10){
          ellipse(1066, 550, i, i);
        }
        playon = true;
      }else if(abs(mouseX-1470) < (10+700)/2 &&
         abs(mouseY-850) < (10+150)/2){
         pointlevel += 1;
        if(pointlevel == 1){
          point.trigger();
        }
        fill(126, 199, 216,100);
        rect(1510, 850, 775, 150);
        noStroke();
        fill(255, 243, 184,100);
        for(int i = 0; i <= 50; i +=10){
          ellipse(1066, 850, i, i);
        }
        settingon = true;
      }else{
        playon = false;
        settingon = false;
        pointlevel = 0;
      }
    }else if(startlevel == 1){ // start
      noStroke();
      fill(0, rectc);
      rect(width/2, height/2, 1920, 1080);
      rectc += 10;
      if(rectc > 255){
        level = 1;
        parList.clear();
        rectc = 0;
      }
    }else if(startlevel == 2){ // setting
      noStroke();
      fill(0, 100);
      rect(width/2, height/2, 1920, 1080);
      image(setting, width/2, height/2);
      if(abs(mouseX-363) < (10+76)/2 &&
         abs(mouseY-840) < (10+28)/2){
         pointlevel += 1;
         if(pointlevel == 1){
          point.trigger();
        }
        fill(126, 199, 216,100);
        rect(363, 840, 76, 28);
        backon = true;
      }else{
        pointlevel = 0;
        backon = false;
      }
    }
    basetime = millis();
  }
  
  // ゲーム開始前・カウントダウン
  if(level == 1){
    if (bgmlevel == 1) {
      BGMgm.rewind();
      BGMgm.loop();
      bgmlevel = 2;
    }
    startlevel = 0;
    int time = millis()-basetime;
    int countdown = 6 -(time/1000);
    me.move(mouseX, mouseY);
    me.display();
    gameUI();
    fill(255);
    textSize(32);
    text("TIME", 400, 50);
    textSize(64);
    text("30",400,100);
    textSize(128);
    fill(126, 199, 216);
    noStroke();
    rect(1000, 64, 1020, 50);
    if(countdown >= 2){
      fill(255);
      text(countdown-1, width/2, height/2);
    }else if(countdown <= 1 && countdown > 0){
      fill(255);
      text("START", width/2, height/2);
    }else{
      next = true;
    }
    if(next){
      level = 2;
      next = false;
    }
    gametime = millis();
  }

  if (level == 2) {
    me.move(mouseX, mouseY);
    me.display();
    int time = millis()-gametime;
    int countdown = 30 - (time/1000);
    for (int m = parList.size()-1; m >= 0; m--) {
      PARTICLE p = parList.get(m);
      if (p.isDead()) {
        p.move();
        p.display();
      } else {
        parList.remove(m);
      }
    }
    // 敵が画面外に出たら消す
    for (int i = enemyList.size()-1; i >= 0; i--) {
      ENEMY e = enemyList.get(i);
      if (e.isAlive()) {
        e.move();
        e.display();
      } else {
        enemyList.remove(i);
      }
    }
    // 自機の弾が画面外に出たら消す
    for (int i = beamList.size()-1; i >= 0; i--) {
      BEAM b = beamList.get(i);
      if (b.isAlive()) {
        b.move();
        b.display();
      } else {
        beamList.remove(i);
      }
    }
    // 敵の弾が画面外に出たら消す
    for (int i = e_beamList.size()-1; i >= 0; i--) {
      E_BEAM eb = e_beamList.get(i);
      if (eb.isAlive()) {
        eb.move();
        eb.display();
      } else {
        e_beamList.remove(i);
      }
    }
    // 弾のと敵当たり判定
    for (int i = 0; i <= enemyList.size()-1; i++) {
      ENEMY e = enemyList.get(i);
      for (int j = 0; j <= beamList.size()-1; j++) {
        BEAM b = beamList.get(j);
        if (abs(e.ex-b.bx) < (e.ewi+b.bwi)/2 &&
          abs(e.ey-b.by) < (e.ehe+b.bhe)/2) {
          enemyList.remove(i);
          beamList.remove(j);
          deadlevel = 1;
          if (deadlevel == 1) {
            for (int k = 0; k <= parSize; k++) {
              parList.add(new PARTICLE(e.ex, e.ey, 0));
            }
            deadlevel = 0;
          }
          hit.trigger();
          score += 100;
        }
      }
    }
    // 敵と自機の当たり判定
    for (int j = 0; j <= enemyList.size()-1; j++) {
      ENEMY e = enemyList.get(j);
      if (abs(e.ex-me.mx) < (e.ewi+me.mwi)/2 &&
        abs(e.ey-me.my) < (e.ehe+me.mhe)/2) {
          damage += 1;
          for (int k = 0; k <= parSize/2; k++) {
            parList.add(new PARTICLE(me.mx, me.my, 1));
          }  
      }
    }
    // 敵の弾と自機の当たり判定
    for (int j = 0; j <= e_beamList.size()-1; j++) {
      E_BEAM eb = e_beamList.get(j);
      if(abs(me.mx-eb.bx) < (me.mwi+eb.bwi)/2 &&
          abs(me.my-eb.by) < (me.mhe+eb.bhe)/2) {
          damage += 1;
          e_beamList.remove(j);
          deadlevel = 1;
          if (deadlevel == 1) {
            for (int k = 0; k <= parSize; k++) {
              parList.add(new PARTICLE(me.mx, me.my, 1));
            }
            deadlevel = 0;
          }
          mhit.trigger();
      }
    }

    if (right) {
      if (frameCount % 4 == 0) {
        laser.trigger();
        beamList.add(new BEAM(me.mx, me.my));
      }
    }
    if (frameCount % 10 == 0) {
      enemyList.add(new ENEMY(0));
    }
    if (frameCount % 10 == 0) {
      enemyList.add(new ENEMY(1));
    }
    if (frameCount % 10 == 0) {
      int ecount = 0;
      while (ecount < 5){
        float eget = random(0, enemyList.size()-1);
        ENEMY e = enemyList.get(int(eget));
        e_beamList.add(new E_BEAM(e.ex, e.ey));
        ecount++;
      }
    }
    
    gameUI();
    fill(255);
    textSize(64);
    text(countdown, 400, 100);
    textSize(32);
    fill(126, 199, 216);
    noStroke();
    rect(1000, 64, countdown*34, 50);
    textSize(128);
    fill(255);
    if(countdown <= 0 && countdown > -1){
      text("FINISH", width/2, height/2);
      enemyList.clear();
      beamList.clear(); 
      parList.clear();
    }else if(countdown <= -1){
      noStroke();
      fill(0, rectc);
      rect(width/2, height/2, 1920, 1080);
      rectc += 10;
      if(rectc > 255){
        rectc = 0;
        level = 3;
      }
    }
  }
  if (level == 3){
    resultUI();
    if(abs(mouseX-960) < (10+470)/2 &&
         abs(mouseY-900) < (10+50)/2){
         pointlevel += 1;
        if(pointlevel == 1){
          point.trigger();
        }
        fill(255, 243, 184, 50);
        noStroke();
        for(int i = 0; i <= 100; i +=10){
          ellipse(960, 860, i, i);
        }
        playon = true;
      }else{
        playon = false;
        pointlevel = 0;
      }
  }
}

void mousePressed() {
  if (level == 0) {
    if (mouseButton == LEFT) {
      if(playon){
        BGMop.pause();
        click.trigger();
        parList.clear();
        playon = false;
        startlevel = 1;
      }
      if(settingon){
        click.trigger();
        settingon = false;
        startlevel = 2;
      }
      if(backon){
        click.trigger();
        backon = false;
        startlevel = 0;
      }
    }
  }
  if (level == 2) {
    if (mouseButton == LEFT) {
      right = true;
      laser.trigger();
      beamList.add(new BEAM(me.mx, me.my));
    }
  }
  if (level == 3) {
    if (mouseButton == LEFT) {
      if(playon){
        BGMgm.pause();
        click.trigger();
        level = 0;
        playon = false;
        bgmlevel = 0;
      }  
    }
  }
}

void mouseReleased() {
  if (level == 2 || level == 3) {
    if (mouseButton == LEFT) {
      right = false;
    }
  }
}

void gameUI(){
  fftgm.forward(BGMgm.mix);
  for (int i = 0; i < fftgm.specSize(); i++) {
    float lineSize = map(fftgm.getBand(i), 0, fftSize, 0, width/2);
    if(lineSize > 112.5){
      alpha = 50;
    }
  }
  if(alpha > 0){
    alpha -= 15;
  }
  noStroke();
  fill(126, 199, 216, alpha);
  for(int i = 0; i < 10; i++){
    float he = i*20;
    rect(145, height - (24+he/2), 288, he);
    rect(1775, height - (24+he/2), 288, he);
  }
  image(gameline, width/2, height/2);
  fill(255);
  textAlign(CENTER);
  textSize(64);
  text(damage, 145, 365);
  text(score, 145, 170);
  text(int(frameRate), 1770, 100);
}

void titleUI(){
  fftop.forward(BGMop.mix);
  for (int i = 0; i < fftop.specSize(); i+= 2) {
    float arcSize = map(fftop.getBand(i), 0, fftSize, 0, width/2);
    noFill();
    stroke(255);
    // 左下のメガホン
    arc(150, 945, arcSize, arcSize, radians(0), radians(30));
    arc(150, 945, arcSize, arcSize, radians(240), radians(360));
    
    // 右下のメガホン
    arc(875, 945, arcSize, arcSize, radians(150), radians(300));
  }
  textSize(64);
  fill(255);
  textAlign(CENTER);
  image(opline, width/2, height/2);
}

void resultUI(){
    int theory = 15000;
    float per = ((float)totalscore / (float)theory) * 100;
    totalscore = score - (damage*100);
    image(resultline, width/2, height/2);
    textSize(64);
    fill(255);
    textAlign(RIGHT);
    text(score, 945, 440);
    text(damage, 945, 590);
    if(totalscore >= 0){
      text(totalscore, 945, 780);
    }else{
      text("GAME OVER", 945, 780);
    }
    textAlign(CENTER);
    if(per > 100){
      text("GOD", 1420, 720);
    }else if(per <= 100 && per > 90){
      text("AA", 1420, 720);
    }else if(per <= 90 && per > 80){
      text("A", 1420, 720);
    }else if(per <= 80 && per > 70){
      text("B", 1420, 720);
    }else if(per <= 70 && per > 60){
      text("C", 1420, 720);
    }else if(per <= 60 && per > 50){
      text("D", 1420, 720);
    }else if(per <= 50 && per > 40){
      text("E", 1420, 720);
    }else if(per <= 40 && per > 30){
      text("F", 1420, 720);
    }else if(per <= 30 && per > 20){
      text("G", 1420, 720);
    }else if(per <= 20 && per > 10){
      text("H", 1420, 720);
    }else{
      text("BAD", 1420, 720);
    }
}

void stop() {
  BGMgm.close();
  BGMop.close();
  minim.stop();
  super.stop();
}
