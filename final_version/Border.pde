// simple class to make the borders
class Border {
  float x, y, diam;
  boolean show;

  Border(float _x, float _y, float _diam) {
    x = _x;
    y = _y;
    diam = _diam;
  }

  void display() {

    if (show) {
      noFill();
      stroke(255);
      strokeWeight(5);
      ellipse(x, y, diam, diam);
    }
  }
}
