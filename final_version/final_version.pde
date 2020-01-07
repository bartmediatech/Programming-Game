PImage candy;

//for the sound:

import ddf.minim.*;
Minim minim;
AudioPlayer waitSound;
AudioPlayer buzzer;

//the objects
Enemy e1, e2, e3;
Player player;
Border inBorder, outBorder;

//the variables
PFont font;
float outBound; 
float inBound;   //HERE CAN CHANGE THE SIZE OF THE CIRCLE
int score;
int timer;
int messageTimer;
int messageDuration;
int firstRound;
int secondRound;
int thirdRound;

float timerBarX;
float timerBarX1;
float timerBarY;
float timerBarY1;
color background;
boolean startState;
boolean roundOne;
boolean roundTwo;
boolean roundThree;
boolean roundFour;
boolean candyMessage;

boolean showImage;
boolean playWaitSound;
boolean playBuzzer;
boolean showStartText;
boolean gameFinished;
boolean gameOver;

PVector circleGoal;
PVector goal;
PVector enemy1;

void setup() {
  //size(800, 800);
  fullScreen();
  reset();
}

void draw() {
  background(background);
  //show the score
  showText();

  //show the borders
  outBorder.display();
  inBorder.display();

  // make player appear
  player.display();

  //make the enemies appear
  e1.display();
  e2.display();
  e3.display();

  if (startState) {     // this is in the "start state"

    playWaitSound();
    playBuzzer();

    //start the waiting sound
    playWaitSound = true;
  }

  if (player.follow) { // if the mouse is in the player circle, the game starts
    //undisplay the start text
    showStartText = false;
    // pause the wait sound
    playWaitSound = false;

    if (frameCount%60 == 0) { // timer +1 every second
      timer++;
    }

    if (showImage) {
      image(candy, width/2, height/2 + ((inBorder.diam/2 + outBorder.diam/2) /2), 20, 20);
    }
    
    // decide which round player is in
    if (timer < firstRound) {
      roundOne = true;
    } else if ( timer > firstRound && timer < secondRound) {
      roundOne = false;
      roundTwo = true;
    } else if (timer > secondRound && timer < thirdRound) {
      roundTwo = false;
      roundThree = true;
    } else if (timer > thirdRound) {
      roundThree = false;
      roundFour = true;
    }
    
    // in round two the candy appears that increases the points and shows a message when moved over
    if (roundOne) {
      play();
    } else if (roundTwo) {
      if (score < 40) {
        showImage = true;
        if (dist(mouseX, mouseY, width/2, height/2 + ((inBorder.diam/2 + outBorder.diam/2) /2) ) < 20) {
          showImage = false;
          score = score + 40;
          candyMessage = true;
        }
      }
      if (candyMessage) {
        messageTimer++;
        textSize(28);
        fill(#85FC97);
        text("+ 40! ", width/2 + 20, height/2 + ((inBorder.diam/2 + outBorder.diam/2) /2) );
        if (messageTimer > messageDuration) {
          // stop displaying the message
          candyMessage = false;
          messageTimer = 0;
        }
      }
      // move the borders
      if (outBorder.diam < 401 && inBorder.diam < 301) {
        outBorder.diam++;
        inBorder.diam++;
      }
      play();
    } else if (roundThree) {

      if (outBorder.diam < 501 && inBorder.diam < 401) {
        outBorder.diam++;
        inBorder.diam++;
      }
      play();
    } else if (roundFour) {
      if (outBorder.diam < 601 && inBorder.diam < 501) {

        // make the enemies go a bit slower, for them its tougher too!
        e1.speed = 0.015;
        e2.speed = 0.015;
        e3.speed = 0.015;
        outBorder.diam++;
        inBorder.diam++;
      }
      play();
    }
  } else {     // for while the player has not moved the mouse inside the start circle ...

    playWaitSound = true;
  }
}

void play() {
  timerBar();

  // make the enemies move around the center
  e1.move();
  e2.move();
  e3.move();

  checkBorders();
  checkScore();
  gameFinished();

  // if gameOver is true, the buzzer should stop, the game is over. Player can click to start a new game
  if (gameOver) {
    playBuzzer = false;
    background = color(#6693B7);
    background(#6693B7);
    fill(255);
    textSize(48);
    text("GAME OVER ", width/2, height/2);
    textSize(24);
    text("Click to start new game", width/2, height/2 + 60);
  }
}

void playWaitSound() {

  if (playWaitSound) {
    waitSound.play();
  } else {
    waitSound.pause();
  }
}

void playBuzzer() {

  if (playBuzzer) {
    buzzer.play();
  } else {
    buzzer.rewind();
    buzzer.pause();
  }
}

// method to make the borders
void makeBorders() {

  outBorder = new Border(width/2, height/2, outBound);  // outer border
  inBorder = new Border(width/2, height/2, inBound); // inner border
}

// method to check if the player is not going beyond the borders, but also to check if the enemies are overtaking the player
void checkBorders() {
  if (!gameFinished) {
    if ( dist(width/2, height/2, player.x, player.y) > (outBorder.diam/2 - player.diam/2) ) {  //player outside of outBound
      background = color(255, 0, 0); //red
      playBuzzer = true;
      score --;
    } else if (dist(width/2, height/2, player.x, player.y) < (inBorder.diam/2 + player.diam/2) ) {
      background = color(255, 0, 0); //red
      playBuzzer = true;
      score --;
    } else {
      background = color(#6693B7);
      playBuzzer = false;
    }

    if (dist(player.x, player.y, width/2 + cos(e1.a + e1.x) * e1.radius, height/2 + sin(e1.a + e1.y) * e1.radius) < player.diam) {
      background = color(255, 0, 0); //red
      playBuzzer = true;
      score = score - 1;
    } else if ( dist(player.x, player.y, width/2 + cos(e2.a + e2.x) * e2.radius, height/2 + sin(e2.a + e2.y) * e2.radius) < player.diam) {
      background = color(255, 0, 0); //red
      playBuzzer = true;
      score = score - 1;
    } else if ( dist(player.x, player.y, width/2 + cos(e3.a + e3.x) * e3.radius, height/2 + sin(e3.a + e3.y) * e3.radius) < player.diam) {
      background = color(255, 0, 0); //red
      playBuzzer = true;
      score = score - 1;
    }
  }
}

// method to show the text
void showText() {

  //for the score
  fill(255);
  textSize(48);
  text("Your score: "+ score, 50, 80); //display the score

  //for the start text
  if (showStartText) {
    fill(255);
    textSize(12);
    text("Move the mouse inside this circle to start the game \n Avoid the enemies and stay within the borders!", width/2, player.y - 60);
  }

  if (roundOne) {
    fill(255);
    textSize(24);
    text("Round 1", 30, height / 7 * 2);
  }
  if (roundTwo) {
    fill(255);
    textSize(24);
    text("Round 2", 30, height / 7 * 3);
  }
  if (roundThree) {
    fill(255);
    textSize(24);
    text("Round 3", 30, height / 7 * 4);
  }
  if (roundFour) {
    fill(255);
    textSize(24);
    text("Round 4", 30, height / 7 * 5);
  }
}

// method to check the score. If the score is 0, the game is over. 
void checkScore() {

  if (score < 1) {
    score = 0;
    gameOver = true;
  }
}

// if the user presses the mouse when the game is over, a new game can start
void mousePressed() {

  if (gameOver) {
    gameOver = false;
    reset();
  }
  if (gameFinished) {
    gameFinished = false;
    reset();
  }
}


// method to reset the game
void reset() {
  background = #6693B7;
  outBound = 300;
  inBound = 200;

  candy = loadImage("candy.png");

  //load the sound(s)
  minim = new Minim(this);
  waitSound = minim.loadFile("waiting.mp3");
  buzzer = minim.loadFile("buzzer.mp3");
  //waitSound = new SoundFile(this, "waiting.mp3");
  //buzzer = new SoundFile(this, "buzzer.mp3");


  //load font
  font = loadFont("Chalkduster-48.vlw");
  textFont(font);

  // initiate the enemies
  e1 = new Enemy(0, 0, 245, 166, 35); //orangeish 
  e2 = new Enemy(PI, PI, 201, 242, 153) ; // greenish
  e3 = new Enemy(0.5*PI, 0.5*PI, 129, 210, 199) ; //blueish

  // initiate player
  player = new Player(width/2, height/2 - ( (outBound/2 +  inBound/2) /2 ), 20);

  //set the border variables
  //outBound = 130;
  //inBound = 70;

  //make the borders
  makeBorders();
  outBorder.show = true;
  inBorder.show = true;

  timer = 0;
  timerBarX = width;
  timerBarX1 = width;
  timerBarY = 0;
  timerBarY1 = -height;
  firstRound = 10;
  secondRound = 25;
  thirdRound = 40;
  score = 150; //start with 150 points
  messageDuration = 120; // 2 seconds
  messageTimer = 0;

  candyMessage = false;
  showStartText = true;
  startState = true;
  roundOne = false;
  roundTwo = false;
  roundThree = false;
  roundFour  = false;
  playWaitSound  = false;
  playBuzzer  = false;
  gameFinished  = false;
  gameOver  = false;

  waitSound.rewind();
}
// method to make the bars that indicate the time
void timerBar() {

  // every half a second, shorten the bars
  if (frameCount%30 == 0) {
    timerBarX = timerBarX - width/60 ; //take a piece of the bar
    timerBarY1 = timerBarY1 + height/60;

    if (timerBarX < 1) {
      timerBarX = 0;
      timerBarY = timerBarY + height/60;
    }
    if (timerBarY1 > 0) {
      timerBarY1 = height;
      timerBarX1 = timerBarX1 - width/60;
    }
  }
  fill(#22364D);
  rect(0, 0, timerBarX, 20);
  rect(width - 20, height, 20, timerBarY1);

  rect(0, timerBarY, 20, height);
  rect(0, height - 20, timerBarX1, 20);

  if (timerBarY > height && timerBarX1 < 0) {
    gameFinished = true;
  }
}
// method for when the game is finished till the end
void gameFinished() {
  if (gameFinished) {
    playBuzzer = false;
    background = color(#85FC97);
    background(#85FC97);
    fill(255);
    textSize(48);
    text("WELL DONE! \n Your score is: "+ score, width/4, height/4);
    textSize(24);
    text("Click to start new game", width/4, height/3 + 200);
  }
}
