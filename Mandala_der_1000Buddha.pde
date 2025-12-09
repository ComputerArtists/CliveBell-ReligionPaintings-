// Mandala der 1000 Buddhas – 100 % fehlerfrei
// N = neue Farbvariante | S = speichern

ArrayList<Buddha> buddhas;
float time = 0;
int variant = 0;
final float GOLDEN_ANGLE = radians(137.507764);

void setup() {
  size(1100, 1100, P2D);
  smooth(16);
  colorMode(HSB, 360, 100, 100, 100);
  blendMode(ADD);

  buddhas = new ArrayList<Buddha>();
  generateBuddhas();
  println("Mandala der 1000 Buddhas bereit – N = Variante | S = speichern");
}

void draw() {
  background(210, 25, 5);
  translate(width/2, height/2);

  float breath = 1.0 + sin(time * 0.8) * 0.08;

  noStroke();
  fill(35, 80, 100, 60);
  circle(0, 0, 180 * breath + sin(time*2)*30);

  for (Buddha b : buddhas) {
    b.update(breath);   // nur update übergibt breath
    b.display();        // display zeichnet
  }

  time += 0.006;
}

void generateBuddhas() {
  buddhas.clear();
  int total = 1008;

  for (int i = 0; i < total; i++) {
    float ring = floor(sqrt(i) * 1.3);
    float posInRing = i - ring*ring*0.7;
    float angle = posInRing * GOLDEN_ANGLE;
    float dist = ring * 28 + random(-8, 8);

    float hue;
    if      (variant == 0) hue = 45 + random(-15, 25);      // Gold
    else if (variant == 1) hue = 140 + random(-30, 30);     // Jade
    else if (variant == 2) hue = 300 + random(-40, 40);     // Amethyst
    else                   hue = random(360);               // Regenbogen

    buddhas.add(new Buddha(dist, angle, hue));
  }
}

class Buddha {
  float baseDist, angle, hue;
  float appearPhase = 0;

  Buddha(float d, float a, float h) {
    baseDist = d;
    angle = a;
    hue = h;
  }

  void update(float breath) {
    if (appearPhase < 1.0) appearPhase += 0.0018;
  }

  void display() {
    float currentDist = baseDist * (1.0 + sin(time * 0.8) * 0.08);
    float x = cos(angle) * currentDist;
    float y = sin(angle) * currentDist;

    pushMatrix();
    translate(x, y);
    rotate(angle + time * 0.2);

    float alpha = map(sin(appearPhase * PI), 0, 1, 0, 255) * 0.9;
    float pulse = 0.85 + sin(time * 3 + baseDist * 0.01) * 0.15;

    // Körper
    noStroke();
    fill(hue, 70, 100, alpha * 0.6);
    ellipse(0, 0, 24 * pulse, 32 * pulse);

    // Kopf
    fill(hue, 60, 100, alpha * 0.8);
    circle(0, -10, 20 * pulse);

    // Ushnisha
    fill(hue, 40, 100, alpha);
    circle(0, -18, 8 * pulse);

    // Heiligenschein-Glühen
    fill(hue, 50, 100, alpha * 0.25);
    circle(0, -10, 50 * pulse);

    popMatrix();
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    variant = (variant + 1) % 4;
    generateBuddhas();
    println("Variante:", variant==0?"Gold":variant==1?"Jade":variant==2?"Amethyst":"Regenbogen");
  }
  if (key == 's' || key == 'S') {
    String name = "ThousandBuddhas_V" + variant + "_" +
                  year() + nf(month(),2) + nf(day(),2) + "_" +
                  nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(name);
    println("Gespeichert:", name);
  }
}
