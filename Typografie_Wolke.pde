// Gebetsworte als Typografie-Wolke
// Liest Worte aus der Datei "Worter.txt" im Sketch-Ordner
// N = neue Form (Herz ↔ Kreis ↔ Spirale) | S = speichern

String[] words;
ArrayList<Word> wordsList;
float time = 0;
int formMode = 0; // 0=Herz, 1=Kreis, 2=Spirale

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  textAlign(CENTER, CENTER);

  loadWordsFromFile();
  spawnWords();
  println("Geladene Worte:", words.length);
  println("N = Form wechseln | S = speichern");
}

void draw() {
  background(0, 0, 8);

  translate(width/2, height/2);

  float breath = 1.0 + sin(time * 1.5) * 0.07;

  for (Word w : wordsList) {
    w.update(breath);
    w.display();
  }

  // sanftes Leuchten im Zentrum
  noStroke();
  fill(50, 50, 100, 30);
  circle(0, 0, 120 + sin(time*3)*30);

  time += 0.012;
}

void loadWordsFromFile() {
  try {
    words = loadStrings("Worter.txt");
    if (words == null || words.length == 0) {
      println("FEHLER: Worter.txt nicht gefunden oder leer!");
      words = new String[]{"Om", "Amen", "Allah", "Peace", "Liebe", "Namaste"};
    }
  } catch (Exception e) {
    words = new String[]{"Shalom", "Salam", "Jesus", "Buddha", "Krishna"};
  }
}

void spawnWords() {
  wordsList = new ArrayList<Word>();
  int index = 0;
  for (int i = 0; i < 400; i++) {  // 400 fliegende Worte
    String wort = words[index % words.length].trim();
    if (wort.length() > 0) {
      wordsList.add(new Word(wort, random(TWO_PI), random(100, 600)));
    }
    index++;
  }
}

class Word {
  String text;
  float angle, dist;
  float targetAngle, targetDist;
  float x, y;
  float hue;
  int size;

  Word(String t, float a, float d) {
    text = t;
    angle = random(TWO_PI);
    dist = random(600, 1200);
    targetAngle = a;
    targetDist = d;
    hue = random(0, 360);
    size = (int)random(18, 48);
  }

  void update(float breath) {
    // langsam zur Zielposition fliegen
    angle = lerp(angle, targetAngle, 0.015);
    dist = lerp(dist, targetDist * breath, 0.015);

    // Zielposition je nach Form
    if (formMode == 0) {           // Herz
      float t = targetAngle;
      x = 16 * pow(sin(t), 3) * 18;
      y = -(13 * cos(t) - 5 * cos(2*t) - 2 * cos(3*t) - cos(4*t)) * 18;
      x *= 1.1;
      y *= 1.1;
    } else if (formMode == 1) {    // Kreis
      x = cos(targetAngle) * targetDist;
      y = sin(targetAngle) * targetDist;
    } else {                       // Spirale
      x = cos(targetAngle * 8) * targetDist * 0.7;
      y = sin(targetAngle * 8) * targetDist * 0.7;
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle + time * 0.3);

    fill(hue, 70, 100, 220);
    textSize(size);
    text(text, 0, 0);

    // sanftes Glühen
    fill(hue, 80, 100, 40);
    textSize(size + 8);
    text(text, 0, 0);

    popMatrix();
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    formMode = (formMode + 1) % 3;
    // neue Ziele zuweisen
    for (Word w : wordsList) {
      w.targetAngle = random(TWO_PI);
      w.targetDist = random(120, 500);
      w.hue = random(0, 360);
    }
    println("Neue Form: " + (formMode==0?"Herz":formMode==1?"Kreis":"Spirale"));
  }

  if (key == 's' || key == 'S') {
    String name = "PrayerCloud_" + (formMode==0?"Heart":formMode==1?"Circle":"Spiral") + "_" +
                  year() + nf(month(),2) + nf(day(),2) + "_" +
                  nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(name);
    println("Gespeichert:", name);
  }

  if (key == 'r' || key == 'R') {
    loadWordsFromFile();
    spawnWords();
    println("Wörter neu geladen");
  }
}
