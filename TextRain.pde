/* Text Rain -- Reimplementation
 * Sam Gruber
 * S2013 IACD */

import processing.video.*;

Capture webcam;
ArrayList<Letter> letters;
int pI = 0;
int ticks = 0;
PFont sans;

String[] poem = {
  "I like talking with you,",
  "simply that: conversing,",
  "a turning-with or -around,",
  "as in your turning around",
  "to face me suddenly . . .",
  "At your turning, each part",
  "of my body turns to verb.",
  "We are the opposite",
  "of tongue-tied, if there",
  "were such an antonym;",
  "We are synonyms",
  "for limbs' loosening",
  "of syntax.",
  "and yet turn to nothing:",
  "It's just talk." };
  
void setup() {
  size(640,480);
  letters = new ArrayList();

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("Wuh-oh! No camera!");
    exit();
  } else {
    webcam = new Capture(this, cameras[0]);
    webcam.start();
  }
  
  sans = loadFont("Cantarell-Bold-14.vlw");
  textFont(sans);
}

class Letter {
  PVector pos;
  PVector vel;
  char ltr;
  color col;
  
  Letter (char inLtr, int inPos, color inCol) {
    pos = new PVector(inPos + random(-2,2), random(-1,0));
    vel = new PVector(0,0.5 + random(-0.25,0.25));
    ltr = inLtr;
    col = inCol;
  }
  
  boolean detectCollision(PImage cam) {
    color slice = cam.get((int)(pos.x), (int)(pos.y));
    return (brightness(slice) <= 128);
  }
  
  void fall() {
    if (detectCollision(webcam)) {
      pos.sub(vel);
      if (detectCollision(webcam)) {
        pos.sub(vel);
      }
    }
    pos.add(vel);
  }
  
  void draw() {
    fill(col);
    text(Character.toString(ltr),pos.x+10,pos.y);
  }
}

void addLetters() {
  if (ticks % 240 == 0) {
    color tone = color(0);
    switch (pI / 5) {
      case 0:
        tone = color(178,18,18);
        break;
      case 1:
        tone = color(41,69,178);
        break;
      default:
        tone = color(255,238,123);
        break;
    }
    for(int i=0; i<poem[pI].length(); i++) {
      Letter l = new Letter(poem[pI].charAt(i), 640/poem[pI].length()*i, tone);
      letters.add(l);
    }
    pI = (pI+1) % poem.length;
  }
}

void gravity() {
  for(int i=0; i<letters.size(); i++) {
    letters.get(i).fall();
  }
}

void drawLetters() {
  for(int i=0; i<letters.size(); i++) {
    letters.get(i).draw();
  }
}

void draw() {
  if (webcam.available() == true) {
    webcam.read();
  }
  webcam.filter(GRAY);
  image(webcam, 0, 0);
  addLetters();
  gravity();
  drawLetters();
  ticks++;
}
