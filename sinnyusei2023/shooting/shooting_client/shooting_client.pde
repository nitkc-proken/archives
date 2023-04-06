import processing.net.*;
Client myClient;

boolean isCompletedSetup = false;
boolean isConnected = false;
boolean wasJoined = false;
int lastRequestTime = -1000;
float idNum;

int myID;
boolean isPlaying = false;
boolean isStarted = false;
boolean isEnded = false;
int entryNum = 0;
IntList ranking = new IntList();
PFont f;

color green = color(0, 255, 0);
color red = color(255, 0, 0);
color blue = color(0, 128, 255);
color yellow = color(255, 255, 0);
color[] colorList = {green, red, blue, yellow};

ArrayList<Ship> ships = new ArrayList<Ship>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  String[] ipAddr;
  ipAddr = loadStrings("ip.txt");

  try {
    myClient = new Client(this, ipAddr[0], 20000);
  } catch (NullPointerException e) {
    e.printStackTrace();
    noLoop();
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
  isCompletedSetup = true;
}

void draw() {
  background(0);
  if (!isPlaying) {
    // entry scene
    if (!isConnected) {
      if (millis() - lastRequestTime > 2000) {
        idNum = random(Float.MAX_VALUE);
        myClient.write("JoinReq," + str(idNum));
        lastRequestTime = millis();
      }
      if (wasJoined) {
          myClient.write("Joined");
          isConnected = true;
      }
    } else {
      for (int i = 0; i < entryNum; i++) {
        ships.get(i).render();
      }
      fill(colorList[myID]);
      text("You are Player" + str(myID + 1), width/2, 100);
      text("YOU", 150 + myID*100, 250);
      if (!ships.get(myID).isReady) {
        text("Space to Ready", width/2, 500);
      }
      noFill();
      if (!ships.get(myID).isReady && KeyState.get(SPACE)) {
        myClient.write("Ready," + str(myID));
      }
    }

    if (isStarted) {
      for (int i = 0; i < entryNum; i++) {
        ships.get(i).entry();
      }
      Ship myShip = ships.get(myID);
      myShip.move(random(-250,250), random(-250,250), random(-PI,PI), myShip.isAccelerating, myShip.isAlive, myShip.lives);
      isPlaying = true;
    }
  } else {
    // play scene
    String sendStr = "";
    Ship myShip = ships.get(myID);
    if (myShip.fire()) {
      Bullet b = new Bullet(myShip);
      // myClient.write(b.data());
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
    sendStr += "Ship," + myShip.data();
    for (int i = 0; i < 4; i++) {
      Ship ship = ships.get(i);
      if (ship.lives > 0) {
        ship.render();
      }
    }

    if (myShip.lives <= 0) {
      fill(myShip.shipColor);
      text("GAME OVER", width/2, height/2 - 30);
      text("Please Wait", width/2, height/2 + 30);
      noFill();
    }

    if (isEnded) {
      displayRanking(ranking);
    }

    myClient.write(sendStr);
  }
}

void clientEvent(Client c) {
  if (!isCompletedSetup) {
    return;
  }

  String readStr = c.readString();
  String[] data = split(readStr, ',');

  try {
    int it = 0;
    while (it < data.length-1) {
      if (data[0].equals("Bullet")) {
        if (int(data[1]) != myID) {
          bullets.add(new Bullet(int(data[1]), unhex(data[2]), float(data[3]), float(data[4]), float(data[5])));
        }
        it += 6;
        break;   // Load reduction
      } else if (data[0].equals("Ships")) {
        for (int i = 0; i < 4; i++) {
          if (i == myID) continue;
          ships.get(int(data[i*7+1])).move(float(data[i*7+2]), float(data[i*7+3]), float(data[i*7+4]), boolean(data[i*7+5]), boolean(data[i*7+6]), int(data[i*7+7]));
        }
        it += 29;
      } else if (data[0].equals("Join")) {
        if (float(data[1]) == idNum) {
          myID = int(data[2]);
          wasJoined = true;
        }
        it += 3;
      } else if (data[0].equals("Entry")) {
        entryNum = int(data[1]);
        it += 2;
      } else if (data[0].equals("Ready")) {
        ships.get(int(data[1])).ready();
        it += 2;
      } else if (data[0].equals("Start")) {
        isStarted = true;
        it += 1;
      } else if (data[0].equals("End")) {
        for (int i = 0; i < entryNum; i++) {
          ranking.append(int(data[i+1]));
        }
        isEnded = true;
        it += entryNum + 1;
      } else {
        break;
      }
    }
  } catch (NullPointerException e) {
    e.printStackTrace();
  }
}
