float windStrength = 0.2;
float size = 0;

ArrayList<Line> branchList = new ArrayList<Line>();
int current = 0;

int millis = 0;
int branches = 0;

void setup() {
  size(1000, 1000);
  frameRate(30);
}

void draw() {
  background(color(100, 150, 255));
  
  noStroke();
  fill(color(50, 200, 50));
  rect(0, height * 2/3, width, height);
  
  branchList.clear();
  size += size < 0.82 ? (0.82 - size) / 200 : 0;
  drawTree(width * 2/4, height * 2/3, 100, 1.9, branches);
  
  if(current >= branchList.size()) {
    branches++;
    current = 0;
  }
  for(int i = 0; i < current; i++)
    branchList.get(i).display();
  if(millis + 10 < millis()) {
    current++;
    millis = millis();
  }
}

void drawTree(float x, float y, float size, float spread, int branches) {
  noFill();
  PVector startPos = new PVector(x, y);
  PVector startVec = new PVector(0, -size);
  PVector newPos = PVector.add(startPos, startVec);
  drawLine(newPos, startVec, spread, PI/8, branches);
  branchList.add(new Line(startPos, newPos, color(75, 50, 25), 10));
  java.util.Collections.reverse(branchList);
}

void drawLine(PVector lastPos, PVector lastVec, float spread, float angle, int branch) {  
  float lastVecMag = lastVec.mag();
  if(branch == 0)
    return;
  float leftSpread = spread * 0.9;
  float rightSpread = spread * 0.9;
  PVector leftVec = calcVec(PVector.mult(lastVec, size), calcAngle(lastPos, leftSpread, angle));
  PVector rightVec = calcVec(PVector.mult(lastVec, size), calcAngle(lastPos, -rightSpread, angle));
  PVector newPosLeft = PVector.add(lastPos, leftVec);
  PVector newPosRight = PVector.add(lastPos, rightVec);
  drawLine(newPosLeft, leftVec, leftSpread, angle, branch - 1);
  drawLine(newPosRight, rightVec, rightSpread, angle, branch - 1);
  color col = color(75, 255 - lastVecMag * 2, 25);
  float weight = lastVecMag / 10;
  branchList.add(new Line(lastPos, newPosLeft, col, weight));
  branchList.add(new Line(lastPos, newPosRight, col, weight));
}

class Line{
  color col;
  float weight;
  PVector pos1, pos2;
  Line(PVector pos1, PVector pos2, color col, float weight) {
    this.col = col;
    this.weight = weight;
    this.pos1 = pos1;
    this.pos2 = pos2;
  }
  void display() {
    stroke(col);
    strokeWeight(weight);
    line(pos1, pos2);
  }
}

PVector calcVec(PVector vec, float ang) {
  return vec.copy().rotate(ang);
}

void line(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}

float calcAngle(PVector vector, float spread, float angle) {
  if(spread >= 0)
    return windStrength *  spread * (noise(vector.x / 1000 + millis() * 0.0001 + 1000) - 0.5) + (spread * angle);
  else
    return windStrength * -spread * (noise(vector.x / 1000 + millis() * 0.0001 + 1000) - 0.5) + (spread * angle);
}
