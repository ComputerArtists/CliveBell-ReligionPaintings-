// Islamisches Sternmuster – finale Version
// N = neues Muster | S = speichern | Maus = langsamer/ schneller drehen
// Processing Java Mode – 100% lauffähig

ArrayList<StarLayer> layers;
float globalTime = 0;
int patternCounter = 1;          // für schöne Dateinamen

void setup() {
  size(900, 900);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  generateNewPattern();
  println("Bereit! Taste N = neues Muster, S = speichern");
}

void draw() {
  background(210, 25, 12);
  translate(width/2, height/2);

  // Maus links/rechts = Rotation beschleunigen/verlangsamen
  float rotationSpeed = map(mouseX, 0, width, -0.08, 0.08);
  rotate(globalTime * rotationSpeed);

  for (StarLayer layer : layers) {
    layer.display(globalTime);
  }

  globalTime += 0.01;
}

// ────── 1. NEUES MUSTER OHNE NEUSTART ──────
void keyPressed() {
  if (key == 'n' || key == 'N') {
    generateNewPattern();
    patternCounter++;
    println("Neues Muster #"+patternCounter);
  }

  // ────── 2. SPEICHERN MIT SCHÖNEM NAMEN ──────
  if (key == 's' || key == 'S') {
    String fileName = "Breath-of-the-Compassionate_" + 
                      year() + nf(month(),2) + nf(day(),2) + "_" +
                      nf(hour(),2) + nf(minute(),2) + nf(second(),2) + 
                      "_v" + nf(patternCounter, 3) + ".png";
    saveFrame(fileName);
    println("Gespeichert als: " + fileName);
  }
}

// ────── ZUFÄLLIGES NEUES MUSTER ERZEUGEN ──────
void generateNewPattern() {
  layers = new ArrayList<StarLayer>();
  int numLayers = int(random(4, 9));                    // 4–8 Schichten

  for (int i = 0; i < numLayers; i++) {
    int[] possiblePoints = {8, 10, 12, 16, 20};
    int points = possiblePoints[int(random(possiblePoints.length))];

    float baseRadius = 370 - i * 45;
    float hue = (180 + random(-60, 100) + i*20) % 360;   // Türkis → Gold → Indigo
    float breathSpeed = random(0.8, 3.2);
    float breathPhase = random(TWO_PI);
    float rotationOffset = random(TWO_PI);

    layers.add(new StarLayer(points, baseRadius, hue, breathSpeed, breathPhase, rotationOffset));
  }
}

// ────── STERN-SCHICHT KLASSE (mit Atmen & eigenem Versatz) ──────
class StarLayer {
  int points;
  float baseR1, baseR2;
  float hue, breathSpeed, breathPhase, rotationOffset;

  StarLayer(int p, float r, float h, float bs, float bp, float ro) {
    points = p;
    baseR1 = r;
    baseR2 = r * random(0.33, 0.48);
    hue = h;
    breathSpeed = bs;
    breathPhase = bp;
    rotationOffset = ro;
  }

  void display(float t) {
    pushMatrix();
    rotate(rotationOffset + sin(t * 0.5) * 0.1);  // leichter zusätzlicher Schwung

    float breath = sin(t * breathSpeed + breathPhase) * 0.15 + 1.0; // 0.85–1.15
    float r1 = baseR1 * breath;
    float r2 = baseR2 * breath;

    color col = color(hue, random(75, 95), random(85, 100), 80);
    fill(col);
    stroke(red(col)*0.95, green(col)*0.95, blue(col)*0.95, alpha(col)*0.7);
    strokeWeight(2.8);

    beginShape();
    float angle = TWO_PI / points;
    for (int i = 0; i < points; i++) {
      vertex(cos(i*angle) * r1, sin(i*angle) * r1);
      vertex(cos(i*angle + angle/2) * r2, sin(i*angle + angle/2) * r2);
    }
    endShape(CLOSE);

    popMatrix();
  }
}
