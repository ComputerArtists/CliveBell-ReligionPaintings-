// Endlos-Mantra – kreisendes, atmendes Mantra-Rad
// Legt eine Datei "Mantra.txt" in den Sketch-Ordner (eine Silbe pro Zeile)
// Beispiele unten ☺
// N = neues Mantra laden + neue Farbe | S = speichern

String[] syllables;
ArrayList<MantraLetter> letters;
float time = 0;
float radius = 260;
float breath = 1.0;

void setup() {
  size(1000, 1000, P2D);
  smooth(16);
  textAlign(CENTER, CENTER);
  colorMode(HSB, 360, 100, 100, 100);
  blendMode(ADD);

  loadMantra();
  println("Mantra geladen:", syllables.length, "Silben");
  println("N = neues Mantra + Farbe | S = speichern");
}

void draw() {
  background(0, 0, 5);

  translate(width/2, height/2);
  breath = 1.0 + sin(time * 1.1) * 0.09;

  // Zentrum leuchtet sanft
  noStroke();
  fill(50, 40, 100, 50);
  circle(0, 0, 140 * breath);

  for (MantraLetter ml : letters) {
    ml.update();
    ml.display();
  }

  time += 0.009;
}

void loadMantra() {
  try {
    syllables = loadStrings("Mantra.txt");
    // eine Silbe pro Zeile
    if (syllables == null || syllables.length == 0) throw new Exception();
  } catch (Exception e) {
    // Fallback-Mantras falls Datei fehlt
    String[] fallback = {
      "Om", "Ma", "ni", "Pad", "me", "Hum"  // Om Mani Padme Hum
    };
    syllables = fallback;
  }

  // Buchstaben neu erzeugen
  letters = new ArrayList<MantraLetter>();
  float angleStep = TWO_PI / syllables.length;

  for (int i = 0; i < syllables.length; i++) {
    String s = syllables[i].trim();
    if (s.length() > 0) {
      letters.add(new MantraLetter(s, i * angleStep));
    }
  }
}

class MantraLetter {
  String text;
  float baseAngle;
  float offsetAngle;
  float currentAngle;
  float hue;

  MantraLetter(String t, float a) {
    text = t;
    baseAngle = a;
    offsetAngle = random(-0.15, 0.15);
    hue = random(0, 360);
  }

  void update() {
    // langsames, wellenförmiges Kreisen
    currentAngle = baseAngle
      + sin(time * 0.8 + baseAngle * 5) * 0.12
      + offsetAngle;

    // leichtes Atmen der Größe
    float sizePulse = 32 + sin(time * 2 + baseAngle * 8) * 12;
    textSize(sizePulse * breath);
  }

  void display() {
    pushMatrix();
    rotate(currentAngle);

    // äußeres Glühen
    fill(hue, 70, 100, 40);
    text(text, 0, -radius * breath - 20);

    // Hauptbuchstabe
    fill(hue, 80, 100, 255);
    text(text, 0, -radius * breath);

    popMatrix();
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    loadMantra();                           // neu aus Datei laden
    for (MantraLetter ml : letters) {
      ml.hue = random(0, 360);               // neue zufällige Farben
    }
    println("Neues Mantra + neue Farben");
  }

  if (key == 's' || key == 'S') {
    String name = "EndlessMantra_" +
                  year() + nf(month(),2) + nf(day(),2) + "_" +
                  nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(name);
    println("Mantra gespeichert:", name);
  }
}
