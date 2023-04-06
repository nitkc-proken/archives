class Ship {
  int id;
  Vector pos;
  float rad;
  Vector speed;
  float rotateSpeed;
  float accelFactor, decelFactor;
  boolean isAccelerating;
  int chargeTime;
  int lastFireTime;
  boolean isAlive;
  int lastHitTime;
  int maxLives, lives;
  color shipColor;
  boolean isReady;
  
  Ship(int id, float posX, float posY, float rad, color col) {
    this.id = id;
    this.pos = new Vector(posX, posY);
    this.rad = rad;
    this.speed = new Vector(0.0, 0.0);
    this.rotateSpeed = 0.07;
    this.accelFactor = 0.03;
    this.decelFactor = 0.005;
    this.isAccelerating = false;
    this.chargeTime = 500;
    this.lastFireTime = -this.chargeTime;
    this.isAlive = true;
    this.lastHitTime = -1000;
    this.maxLives = 3;
    this.lives = 0;
    this.shipColor = col;
    this.isReady = false;
  }
  
  void render() {
    stroke(this.shipColor);
    Vector coord = new Vector();

    Vector[] frames = new Vector[4];
    frames[0] = new Vector(15.0,  0.0);
    frames[1] = new Vector(-15.0, 10.0);
    frames[2] = new Vector(-5.0,  0.0);
    frames[3] = new Vector(-15.0, -10.0);
    Vector[] flares = new Vector[4];
    flares[0] = new Vector(-15.0, 7.0);
    flares[1] = new Vector(-22.0, 7.0);
    flares[2] = new Vector(-15.0, -7.0);
    flares[3] = new Vector(-22.0, -7.0);

    if (this.isAlive) {
      // draw a frame
      beginShape();
      for (int i = 0; i < 4; i++) {
        // move and rotate vector
        coord.set(frames[i].x, frames[i].y).rotate(this.rad).add(this.pos);
        vertex(coord.windowX(), coord.windowY());
      }
      ellipse(this.pos.windowX(), this.pos.windowY(), 10, 10);
      endShape(CLOSE);

      // draw flares
      if (this.isAccelerating) {
        for (int i = 0; i < 4; i++) {
          coord.set(flares[i].x, flares[i].y).rotate(this.rad).add(this.pos);
          if (i % 2 == 0) beginShape();
          vertex(coord.windowX(), coord.windowY());
          if (i % 2 == 1) endShape(CLOSE);
        }
      }
      stroke(green);
    } else {
      // draw explosion
      for (int i = 0; i < 8; i++) {
        beginShape();
        coord.set(0.0, 5.0).rotate(PI/4 * i).add(this.pos);
        vertex(coord.windowX(), coord.windowY());
        coord.set(0.0, 10.0).rotate(PI/4 * i).add(this.pos);
        vertex(coord.windowX(), coord.windowY());
        endShape();
      }
    }

    if (this.isReady) {
      fill(this.shipColor);
      text("Ready", this.pos.windowX(), this.pos.windowY() + 40);
      noFill();
    }
  }

  void entry() {
    this.lives = this.maxLives;
    this.isReady = false;
  }
  
  void control() {
    this.isAccelerating = KeyState.get(UP);
    if (this.isAlive) {
      Vector deltaSpeed = new Vector();
      // acceleration
      if (KeyState.get(UP)) {
        deltaSpeed.set(accelFactor, 0).rotate(this.rad);
        this.speed.add(deltaSpeed);
      }
  
      // deceleration
      this.speed.scale(1 - decelFactor);

      // rotate
      if (KeyState.get(LEFT)) {
        this.rad += this.rotateSpeed;
      }
      if (KeyState.get(RIGHT)) {
        this.rad -= this.rotateSpeed;
      }
    }

    // move
    this.pos.add(this.speed);

    if (this.pos.x > width/2 + 15) {
      this.pos.x -= width + 30;
    } else if (this.pos.x < -width/2 - 15) {
      this.pos.x += width + 30;
    }
    if (this.pos.y > height/2 + 15) {
      this.pos.y -= height + 30;
    } else if (this.pos.y < -height/2 - 15) {
      this.pos.y += height + 30;
    }
  }

  void move(float x, float y, float rad, boolean isAccelerating, boolean isAlive, int lives) {
    this.pos.set(x, y);
    this.rad = rad;
    this.isAccelerating = isAccelerating;
    this.isAlive = isAlive;
    this.lives = lives;
    if (this.isAlive) {
      this.lastHitTime = millis();
    }
  }

  boolean fire() {
    boolean canFire = (this.isAlive && KeyState.get(SPACE) && millis() - this.lastFireTime > this.chargeTime);
    if (canFire) {
      this.lastFireTime = millis();
    }
    return canFire;
  }

  Vector head() {
    Vector head = new Vector(15.0, 0);
    head.rotate(this.rad).add(this.pos);

    return head;
  }

  void respawn(float posX, float posY, float rad) {
    if (!this.isAlive && millis() - this.lastHitTime > 1000 && this.lives > 0) {
      this.lives -= 1;

      this.pos.set(posX, posY);
      this.rad = rad;
      this.speed.set(0.0, 0.0);
      this.accelFactor = 0.03;
      this.decelFactor = 0.005;
      this.lastFireTime = -this.chargeTime;
      this.isAlive = (this.lives > 0);
    }
  }
  
  String data() {
    return str(this.id) + ',' + str(this.pos.x) + ',' + str(this.pos.y) + ',' + str(this.rad) + ',' + str(this.isAccelerating) + ',' + str(this.isAlive) + ',' + str(this.lives) + ',';
  }

  void ready() {
    this.isReady = true;
  }
}
