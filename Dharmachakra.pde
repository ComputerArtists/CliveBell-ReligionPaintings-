// Dharmachakra – 5 echte Varianten, absolut fehlerfrei
// N = nächste Variante | S = speichern

float time = 0;
int variant = 0;

void setup() {
  size(900, 900, P2D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  blendMode(ADD);
  println("Dharmachakra bereit – N = neue Variante, S = speichern");
}

void draw() {
  background(0, 0, 8);
  translate(width/2, height/2);

  float breath = sin(time * 1.3) * 0.09 + 1.0;
  float spin   = time * 0.04;

  pushMatrix();
  rotate(spin);

  // richtiger Aufruf der Varianten
  if      (variant == 0) classicGolden(breath);
  else if (variant == 1) tibetanRainbow(breath);
  else if (variant == 2) zenMinimal(breath);
  else if (variant == 3) lotusStyle(breath);
  else if (variant == 4) cosmicBlue(breath);

  popMatrix();

  time += 0.008;
}

// ────────────────────── VARIANTEN ──────────────────────

void classicGolden(float b) {
  drawRing(380*b, 45, 95, 100, 18);
  for (int i = 0; i < 8; i++) { rotate(PI/4); drawSpoke(330*b, 45, 90, 100, 22); }
  drawRing(170*b, 45, 85, 95, 14);
  drawHub(80*b, 45, 60, 100);
}

void tibetanRainbow(float b) {
  for (int i = 0; i < 8; i++) {
    pushMatrix();
    rotate(i * PI/4);
    float h = (i * 45 + time * 30) % 360;
    drawSpoke(340*b, h, 90, 95, 20);
    popMatrix();
  }
  drawRing(380*b, 0, 0, 30, 30);           // weißer Außenring
  drawHub(90*b, 0, 0, 100);
}

void zenMinimal(float b) {
  noStroke();
  fill(0, 0, 95, 20); circle(0,0,800*b);
  stroke(0, 0, 100); strokeWeight(12);
  for (int i = 0; i < 8; i++) { rotate(PI/4); line(60,0,340*b,0); }
  fill(0,0,140*b);
  fill(0, 80, 100); circle(0,0,60*b);
}

void lotusStyle(float b) {
  drawRing(380*b, 45, 80, 90, 16);
  for (int i = 0; i < 8; i++) {
    pushMatrix();
    rotate(i * PI/4 + sin(time + i)*0.15);
    drawLotusSpoke(320*b);
    popMatrix();
  }
  drawHub(100*b, 320, 80, 90);
}

void cosmicBlue(float b) {
  if (frameCount % 4 == 0) {
    pushMatrix();
    rotate(-time*0.02);
    for (int i = 0; i < 30; i++) {
      float angle = random(TWO_PI);
      float dist = random(200, 420);
      fill(60, 20, 100, random(20,60));
      circle(cos(angle)*dist, sin(angle)*dist, random(2,7));
    }
    popMatrix();
  }
  drawRing(370*b, 210, 70, 90, 20);
  for (int i = 0; i < 8; i++) { rotate(PI/4); drawSpoke(330*b, 210, 60, 100, 18); }
  drawHub(85*b, 220, 90, 100);
}

// ────────────────────── HILFSFUNKTIONEN ──────────────────────

void drawRing(float d, float h, float s, float br, float w) {
  noFill();
  strokeWeight(w);
  stroke(h, s, br, 70);
  circle(0, 0, d);
  stroke(h, s*0.7, br*1.2, 40);
  strokeWeight(w*0.6);
  circle(0, 0, d*0.93);
}

void drawSpoke(float len, float h, float s, float br, float w) {
  strokeWeight(w);
  stroke(h, s, br, 85);
  line(50, 0, len, 0);
  noStroke();
  fill(h, s*0.8, br*1.3, 90);
  circle(len, 0, w*2);
}

void drawLotusSpoke(float len) {
  for (int p = 0; p < 5; p++) {
    pushMatrix();
    rotate(p * TWO_PI / 5);
    fill(320, 80, 90, 70);
    ellipse(0, len*0.7, 50, 130);
    popMatrix();
  }
}

void drawHub(float d, float h, float s, float br) {
  noStroke();
  fill(h, s, br, 80);
  circle(0, 0, d*2);
  fill(h, s*0.5, br*1.3, 90);
  circle(0, 0, d*1.4);
  fill(45, 20, 100, 100);
  circle(0, 0, d*0.6);
}

// ────────────────────── STEUERUNG ──────────────────────

void keyPressed() {
  if (key == 'n' || key == 'N') {
    variant = (variant + 1) % 5;
    println("Variante " + variant + " aktiv");
  }
  if (key == 's' || key == 'S') {
    String name = "Dharmachakra_V" + variant + "_" + 
                  year() + nf(month(),2) + nf(day(),2) + "_" +
                  nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(name);
    println("Gespeichert: " + name);
  }
}
