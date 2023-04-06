import processing.net.*;
Server server;

boolean isPlaying = false;
boolean allowEntry = true;
int allReadyTime = -1000;
int entryNum = 1;
IntList ranking = new IntList();
boolean[] isDead = {false, false, false, false};
final int myID = 0;
PFont f;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color blue = color(0, 128, 255);
color yellow = color(255, 255, 0);
color[] colorList = {green, red, blue, yellow};

ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  try {
    server = new Server(this, 20000);
  } catch (RuntimeException e) {
    e.printStackTrace();
    exit();
  }

  size(600,600);
  background(0);
  ellipseMode(CENTER);
  stroke(green);
  noFill();

  f = loadFont("Ac437_IBM_VGA_8x16-24.vlw");
  textFont(f);
  textAlign(CENTER);

  KeyState.initialize();

  for (int i = 0; i < 4; i++) {
    ships.add(new Ship(i, -150 + 100*i, 0, PI/2, colorList[i]));
  }
}

void draw() {
  // Receive client data
  while (true) {
    Client c = server.available();
    if (c == null) {
      break;
    } else {
      String readStr = c.readString();
      String[] data = split(readStr, ',');

      try {
        int it = 0;
        while (it < data.length) {
          if (data[0].equals("Ship")) {
            ships.get(int(data[1])).move(float(data[2]), float(data[3]), float(data[4]), boolean(data[5]), boolean(data[6]), int(data[7]));
            it += 8;
          } else if (data[0].equals("Bullet")) {
            bullets.add(new Bullet(int(data[1]), unhex(data[2]), float(data[3]), float(data[4]), float(data[5])));
            server.write(readStr);
            it += 6;
          } else if (data[0].equals("JoinReq")) {
            server.write("Join," + data[1] + ',' + str(entryNum) + ',');
            it += 2;
          } else if (data[0].equals("Joined")) {
            entryNum += 1;
            server.write("Entry," + str(entryNum) + ',');
            it += 1;
          } else if (data[0].equals("Ready")) {
            ships.get(int(data[1])).ready();
            server.write(readStr);
            it += 2;
          } else {
            break;
          }
        }
      } catch (NullPointerException e) {
        e.printStackTrace();
      }
    }
  }

  // Game process
  background(0);
  if (!isPlaying) {
    // entry scene
    for (int i = 0; i < entryNum; i++) {
      ships.get(i).render();
    }
    fill(green);
    text("You are Player" + str(myID + 1), width/2, 100);
    text("YOU", 150, 250);
    if (!ships.get(myID).isReady) {
      text("Space to Ready", width/2, 500);
    }
    noFill();

    if (KeyState.get(SPACE) && entryNum >= 2) {
      ships.get(0).ready();
      server.write("Ready,0,");
    }

    boolean isAllReady = true;
    for (int i = 0 ; i < entryNum; i++) {
      if (!ships.get(i).isReady) {
        isAllReady = false;
      }
    }

    if (isAllReady && allowEntry) {
      allowEntry = false;
      allReadyTime = millis();
    }

    if (isAllReady && millis() - allReadyTime > 1000) {
      for (int i = 0; i < entryNum; i++) {
        ships.get(i).entry();
      }
      Ship myShip = ships.get(myID);
      myShip.move(random(-250,250), random(-250,250), random(-PI,PI), myShip.isAccelerating, myShip.isAlive, myShip.lives);
      server.write("Start,");
      isPlaying = true;
    }
  } else {
    // play scene
    String sendStr = "";
    Ship myShip = ships.get(myID);
    if (myShip.fire()) { 
      Bullet b = new Bullet(myShip);
      sendStr += b.data();
      bullets.add(b);
    }

    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = bullets.get(i);
      b.move();
      if (b.isAlive()) {
        b.render();
        if (b.isHit(myShip)) {
          myShip.isAlive = false;
          myShip.lastHitTime = millis();
        }
      } else {
        bullets.remove(i);
        i -= 1;
      }
    }

    myShip.control();
    myShip.respawn(random(-250,250), random(-250,250), random(-PI,PI));
    sendStr += "Ships,";
    for (int i = 0; i < 4; i++) {
      Ship ship = ships.get(i);
      if (ship.lives > 0) {
        ship.render();
      }
      sendStr += ship.data();
    }

    if (myShip.lives <= 0) {
      fill(myShip.shipColor);
      text("GAME OVER", width/2, height/2 - 30);
      text("Please Wait", width/2, height/2 + 30);
      noFill();
    }

    int aliveCount = 0;
    for (int i = 0; i < entryNum; i++) {
      if (ships.get(i).lives > 0) {
        aliveCount += 1;
      }
    }

    for (int i = 0; i < entryNum; i++) {
      Ship ship = ships.get(i);
      if (ship.lives <= 0 && !isDead[i]) {
        ranking.append(i);
        isDead[i] = true;
      }
    }

    if (aliveCount <= 1) {
      for (int i = 0; i < entryNum; i++) {
        if (!isDead[i]) {
          ranking.append(i);
        }
      }
      delay(100);
      String sendEnd = "End,";
      for (int i = 0; i < entryNum; i++) {
        sendEnd += str(ranking.get(i)) + ',';
      }
      server.write(sendEnd);
      displayRanking(ranking);
    }

    server.write(sendStr);
  }
}

void serverEvent(Server s, Client c) {
  if (!allowEntry) {
    s.disconnect(c);
  }
}
