// Mandala-Generator – sauberes Processing-Skript (Java Mode)
// Läuft garantiert ohne Fehler
// Drücke „s“, um ein Bild zu speichern

float time = 0;

void setup() {
  size(900, 900);
  colorMode(HSB, 360, 100, 100, 100);  // HSB mit Alpha
  smooth(8);
  noFill();
  strokeWeight(2);
}

void draw() {
  background(0, 0, 5);                    // fast schwarzer Hintergrund
  translate(width/2, height/2);
  rotate(time * 0.1);                     // langsame Gesamtdrehung

  int layers    = 11;   // Anzahl der konzentrischen Kreise
  int symmetry  = 12;   // 12-fache Symmetrie (klassisch für Mandalas)

  for (int layer = 0; layer < layers; layer++) {
    float radius = 60 + layer * 38;
    float hueBase = (time * 15 + layer * 25) % 360;

    pushMatrix();
    for (int i = 0; i < symmetry; i++) {
      rotate(TWO_PI / symmetry);

      // Farbe pro Segment und Schicht
      float h = (hueBase + i * 10) % 360;
      float s = 70 + sin(time + layer * 0.5) * 20;
      float b = 90 + sin(time * 1.2) * 10;
      
      stroke(h, s, b, 85);
      fill(h, s, b, 20);                     // sehr transparente Füllung

      // Blütenblatt-Form
      pushMatrix();
      rotate(sin(time * 0.7 + layer) * 0.4);
      ellipse(0, radius, radius * 1.6, radius * 0.35);
      popMatrix();

      // Kleine Perlen/Kreise am äußeren Rand
      noStroke();
      fill(h, s, b, 90);
      circle(radius + 15, 0, 18 + sin(time * 2 + layer + i) * 8);

      // Striche in jeder zweiten Schicht
      if (layer % 2 == 1) {
        stroke(h, s, b, 70);
        noFill();
        line(radius * 0.5, 0, radius * 1.2, 0);
      }
    }
    popMatrix();
  }

  // Pulsierendes Zentrum
  noStroke();
  fill(50, 80, 100, 90);
  circle(0, 0, 80 + sin(time * 4) * 25);
  fill(0, 0, 100);
  circle(0, 0, 30 + sin(time * 6) * 10);

  time += 0.012;  // Animationsgeschwindigkeit
}

// Bild speichern
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("mandala-######.png");
    println("Mandala gespeichert als mandala-######.png");
  }
}
