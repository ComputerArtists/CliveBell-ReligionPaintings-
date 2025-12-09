// Bodhi-Blatt – Erwachen unter dem heiligen Feigenbaum
// N = neue Farbstimmung (Gold, Smaragd, Mondlicht, Sonnenaufgang) | S = speichern

ArrayList<Leaf> leaves;
Leaf centralLeaf;
float time = 0;
int mood = 0;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  blendMode(ADD);
  colorMode(HSB, 360, 100, 100, 100);

  leaves = new ArrayList<Leaf>();
  centralLeaf = new Leaf(0, 0, 0, 280, true);  // großes zentrales Blatt
  newMood();
  println("Bodhi-Blatt – N = neue Stimmung | S = speichern");
}

void draw() {
  background(210, 20, 8);                    // warmer Nachthimmel / frühe Dämmerung

  translate(width/2, height/2);

  // neues kleines Blatt alle paar Sekunden aus dem Zentrum wachsen lassen
  if (frameCount % 120 == 0) {
    float angle = random(TWO_PI);
    leaves.add(new Leaf(cos(angle)*30, sin(angle)*30, angle, random(40, 100), false));
  }

  // zentrales Bodhi-Blatt (immer da, pulsiert leicht)
  centralLeaf.display(true);

  // alle fliegenden Blätter
  for (int i = leaves.size()-1; i >= 0; i--) {
    Leaf l = leaves.get(i);
    l.update();
    l.display(false);
    if (l.alpha <= 0) leaves.remove(i);
  }

  time += 0.01;
}

void newMood() {
  mood = (mood + 1) % 4;
  float h = 50;
  switch(mood) {
    case 0: h = 55;  break;   // klassisches Bodhi-Gold
    case 1: h = 140; break;   // Smaragdgrün (Herzchakra)
    case 2: h = 210; break;   // Mondblau
    case 3: h = 35;  break;   // Sonnenaufgang-Orange-Gold
  }
  for (Leaf l : leaves) l.baseHue = h + random(-20, 40);
  centralLeaf.baseHue = h;
}

class Leaf {
  float x, y, rot, targetRot;
  float size;
  float alpha = 255;
  float vx, vy, vr;
  float baseHue;
  boolean isCentral;

  Leaf(float sx, float sy, float r, float s, boolean center) {
    x = sx; y = sy;
    rot = r;
    targetRot = r + random(-0.5, 0.5);
    size = s;
    isCentral = center;
    baseHue = 55;
    vx = random(-0.3, 0.3);
    vy = random(-1.8, -0.8);
    vr = random(-0.02, 0.02);
  }

  void update() {
    if (!isCentral) {
      x += vx;
      y += vy;
      vy += 0.02;                // sanfte Schwerkraft nach unten
      rot += vr;
      alpha -= 0.6;
    } else {
      rot = lerp(rot, targetRot + sin(time*1.2)*0.1, 0.02);
    }
  }

  void display(boolean glow) {
    pushMatrix();
    translate(x, y);
    rotate(rot);

    float h = (baseHue + sin(time + x*0.01)*20) % 360;

    // Blattform (klassische Herzform des Bodhi-Blattes)
    noStroke();
    beginShape();
    for (float a = 0; a < TWO_PI; a += 0.1) {
      float r = size * (0.5 - 0.4 * cos(a) + 0.1 * cos(6*a));
      float px = r * cos(a) * 1.1;
      float py = r * sin(a) * 1.3 - size*0.2;  // leicht nach unten verschoben
      vertex(px, py);
    }
    endShape(CLOSE);

    // Füllung
    fill(h, 70, 95, alpha*0.7);
    beginShape();
    for (float a = 0; a < TWO_PI; a += 0.05) {
      float r = size * (0.5 - 0.4 * cos(a) + 0.1 * cos(6*a));
      vertex(r * cos(a)*1.1, r * sin(a)*1.3 - size*0.2);
    }
    endShape(CLOSE);

    // Aderung
    stroke(h, 80, 100, alpha*0.9);
    strokeWeight(size*0.04);
    line(0, -size*0.6, 0, size*0.8);

    // Glühen (nur zentrales Blatt + große fliegende)
    if (glow || size > 80) {
      fill(h, 60, 100, 40);
      scale(1.25);
      beginShape();
      for (float a = 0; a < TWO_PI; a += 0.1) {
        float r = size * (0.5 - 0.4 * cos(a) + 0.1 * cos(6*a));
        vertex(r * cos(a)*1.1, r * sin(a)*1.3 - size*0.2);
      }
      endShape(CLOSE);
    }

    popMatrix();
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') newMood();
  if (key == 's' || key == 'S') {
    String name = "BodhiLeaf_" + mood + "_" +
                  year() + nf(month(),2) + nf(day(),2) + "_" +
                  nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(name);
    println("Bodhi-Blatt gespeichert");
  }
}
