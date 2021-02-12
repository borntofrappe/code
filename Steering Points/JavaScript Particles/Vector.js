class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  add(v) {
    this.x = this.x + v.x;
    this.y = this.y + v.y;
  }

  subtract(v) {
    this.x = this.x - v.x;
    this.y = this.y - v.y;
  }

  multiply(s) {
    this.x = this.x * s;
    this.y = this.y * s;
  }

  divide(s) {
    if (s !== 0) {
      this.x = this.x / s;
      this.y = this.y / s;
    }
  }

  getMagnitude() {
    return (this.x ** 2 + this.y ** 2) ** 0.5;
  }

  normalize() {
    const magnitude = this.getMagnitude();
    this.divide(magnitude);
  }

  limit(m) {
    const magnitude = this.getMagnitude();
    if (magnitude > m) {
      this.normalize();
      this.multiply(m);
    }
  }
}
