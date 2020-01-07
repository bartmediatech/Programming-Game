// class to make the player. The player will follow the mouse x and y if the mouse is within the circle
class Player {

  float x, y;
  float diam;
  boolean follow;

  Player(float _x, float _y, float _diam) {

    x = _x;
    y = _y;
    diam = _diam;
  }

  void display() {

    noFill();
    stroke(255);
    ellipse(x, y, diam, diam);
    if ( dist( mouseX, mouseY, x, y) < diam/2){
      follow = true;
    }
    follow();
  }
  
  // this method ensures that the circle keeps coming to the mouse position, even when going fast
  void follow(){
    if (follow){
      x=mouseX;
      y=mouseY;
    }
  }
}
