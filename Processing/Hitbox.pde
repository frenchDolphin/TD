class Hitbox {
  int x, y, bWidth, bHeight;

  Hitbox(int x, int y, int bWidth, int bHeight) {
    this.x = x;
    this.y = y;
    this.bWidth = bWidth;
    this.bHeight = bHeight;
  }

  boolean contains(int px, int py) {
    boolean inX = px >= x && px <= x + bWidth;
    boolean inY = py >= y && py <= y + bHeight;

    return inX && inY;
  }
}

class Range {
  int min, max;

  Range(JSONArray values) {
    this(values.getInt(0, 0), values.getInt(1, 0));
  }

  Range(int min, int max) {
    this.min = min;
    this.max = max;
  }

  int getRandom() {
    return int(random(min, max));
  }
}