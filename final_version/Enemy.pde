// class to make an enemy. The enemies move within the borders, in a circle path
class Enemy {

  float x, y;
  float a = 0;
  color c;
  float radius = (outBound + inBound) / 4; // like this the enemies stay in the middle of the borders
  float speed = 0.02; // this is the speed at which the enemies move

  Enemy(float _startX, float _startY, int r, int g, int b) {

    x = _startX;
    y = _startY;
    c = color(r, g, b);
  }

  /* the formula to make an object move in a circle is:
   x: startX + cos(angle + x) * radius
   y: startY + sin(angle + y) * radius
   */
  void display() {
    fill(c);
    noStroke();
    ellipse(width/2 + cos(a + x) * radius, height/2 + sin(a + y) * radius, 20, 20);
  }

  void move() {

    a = a + speed; 
    radius = (outBorder.diam + inBorder.diam) / 4; // make sure that the enemies stay within the out and in border
  }
}
