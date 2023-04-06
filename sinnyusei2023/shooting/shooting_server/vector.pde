class Vector {
  float x, y;

  Vector() {
    this.x = 0;
    this.y = 0;
  }

  Vector(float x, float y) {
    this.x = x;
    this.y = y;
  }

  Vector set(float x, float y) {
    this.x = x;
    this.y = y;
    return this;
  }

  Vector add(float x, float y) {
    this.x += x;
    this.y += y;
    return this;
  }

  Vector add(Vector v) {
    this.x += v.x;
    this.y += v.y;
    return this;
  }

  Vector scale(float a) {
    this.x *= a;
    this.y *= a;
    return this;
  }

  Vector rotate(float rad) {
    float temp = this.x;
    this.x = this.x*cos(rad) - this.y*sin(rad);
    this.y = temp*sin(rad) + this.y*cos(rad);
    return this;
  }

  float dist(Vector v) {
    return sqrt(pow(this.x - v.x, 2) + pow(this.y - v.y, 2));
  }

  float windowX() {
    return this.x + width/2;
  }
  float windowY() {
    return -this.y + height/2;
  }
}
