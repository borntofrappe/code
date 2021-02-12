class VectorLib {
  new(x, y) {
    return new Vector(x, y);
  }

  add(v1, v2) {
    const v = new Vector(0, 0);
    v.add(v1);
    v.add(v2);

    return v;
  }

  subtract(v1, v2) {
    const v = new Vector(0, 0);
    v.add(v1);
    v.subtract(v2);

    return v;
  }

  copy(v) {
    return new Vector(v.x, v.y);
  }
}
