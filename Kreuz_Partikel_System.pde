// Leuchtendes Kreuz-Partikel-System – ENDLICH 100 % fehlerfrei
// N = neue Farbstimmung | S = speichern | Maus X = extra Glühen, Maus Y = Tempo

ArrayList<Particle> particles;
float globalTime = 0;
float currentBrightBoost = 0;           // <-- globale Variable für alle Partikel
int mood = 0;

void setup() {
  size(900, 900, P2D);
  blendMode(ADD);
  colorMode(HSB, 360, 100, 100, 100);
  generateParticles();
  newMood();
}

void draw() {
  background(0);
  translate(width/2, height/2);

  float speed           = map(mouseY, 0, height, 0.4, 2.8);
  currentBrightBoost    = map(mouseX, 0, width, 0, 45);   // jetzt global verfügbar

  for (Particle p : particles) {
    p.update(speed);
    p.show();
  }

  globalTime += 0.01 * speed;
}

void generateParticles() {
  particles = new ArrayList<Particle>();
  for (int i = 0; i < 4200; i++) {
    particles.add(new Particle());
  }
}

void newMood() {
  mood = (mood + 1) % 6;
  float baseHue = 50;
  switch(mood) {
    case 0: baseHue = 50;  break;  // Gold
    case 1: baseHue = 200; break;  // Blau
    case 2: baseHue = 300; break;  // Violett
    case 3: baseHue = 0;   break;  // Rot
    case 4: baseHue = 140; break;  // Grün
    case 5: baseHue = 35;  break;  // Weißgold
  }
  for (Particle p : particles) {
    p.hue = (baseHue + random(-30, 60) + 360) % 360;
  }
}

class Particle {
  float x, y, vx, vy;
  float targetX, targetY;
  float hue;
  float life = 255;

  Particle() { reset(); }

  void reset() {
    float side = random(4);
    if (side < 1)      {x = random(-width, width);  y = -height/2-1000;}
    else if (side < 2) {x = random(-width, width);  y =  height/2+100;}
    else if (side < 3) {x = -width/2-100; y = random(-height, height);}
    else               {x =  width/2+100; y = random(-height, height);}

    vx = vy = 0;
    assignNewTarget();
  }

  void assignNewTarget() {
    if (random(1) < 0.72) {
      targetX = random(-90, 90);
      targetY = random(-520, 520);
    } else {
      targetX = random(-360, 360);
      targetY = random(-90, 90);
    }
  }

  void update(float speed) {
    float dx = targetX - x;
    float dy = targetY - y;
    float dist = mag(dx, dy);

    if (dist > 5) {
      vx += dx * 0.0011 * speed;
      vy += dy * 0.0011 * speed;
      vx *= 0.945;
      vy *= 0.945;
    } else {
      vx *= 0.72;
      vy *= 0.72;
      life -= 0.4;
      if (life < 0) {
        reset();
        life = 255;
      }
    }
    x += vx;
    y += vy;
  }

  void show() {
    // jetzt benutzen wir die globale Variable!
    float br = 80 + sin(globalTime*3 + x*0.02)*30 + currentBrightBoost;
    stroke(hue, 85, br, life);
    strokeWeight(2.3 + sin(globalTime*6 + y*0.01)*1.3);
    point(x, y);
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') newMood();
  if (key == 's' || key == 'S') {
    String name = "LivingCross_" + year() + nf(month(),2) + nf(day(),2) + "_" +
                  nf(hour(),2) + nf(minute(),2) + nf(second(),2) + ".png";
    saveFrame(name);
    println("Gespeichert:", name);
  }
}
