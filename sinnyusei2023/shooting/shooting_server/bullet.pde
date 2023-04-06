class Bullet {
  int id;
  Vector pos;
  float rad;
  float speed;
  color bulletColor;

  Bullet(Ship ship) {
    this.id = ship.id;
    this.pos = ship.head();
    this.rad = ship.rad;
    this.speed = 7.0;
    this.bulletColor = ship.shipColor;
  }

  Bullet(int id, color col, float x, float y, float rad) {
    this.id = id;
    this.pos = new Vector(x, y);
    this.rad = rad;
    this.speed = 5.0;
    this.bulletColor = col;
  }

  void move() {
    Vector movement = new Vector(5.0, 0).rotate(this.rad);
    this.pos.add(movement);
  }

  void render() {
    noStroke();
    fill(this.bulletColor);
    ellipse(this.pos.windowX(), this.pos.windowY(), 5, 5);
    noFill();
    stroke(green);
  }
    
  boolean isAlive() {
    return (this.pos.x >= -width/2 - 60 && this.pos.x <= width/2 + 60 && this.pos.y >= -height/2 - 60 && this.pos.y <= height/2 + 60);
  }

  boolean isHit(Ship ship) {
    return (this.pos.dist(ship.pos) < 12.0);
  }

  String data() {
    return "Bullet," + str(this.id) + ',' + hex(this.bulletColor) + ',' + str(this.pos.x) + ',' + str(this.pos.y) + ',' + str(this.rad) + ',';
  }
}
