class Point {
  float x, y;
  boolean selected = false;

  PVector one = null, two = null; //only for size indicate
  int index;
  float px, py;
  boolean isCenterOfCircle = false;
  int pairIndex = -1;


  Rool_Horizontal R_h = new Rool_Horizontal();
  Rool_Vertical R_v = new Rool_Vertical();
  Rool_Equals R_e = new Rool_Equals();
  Rool_FixedDistance R_l = new Rool_FixedDistance();

  IntList horiz = new IntList(); // horizontal points' ids
  IntList vert = new IntList(); // vartical points' ids
  IntList equals = new IntList(); // equals points' ids
  StringList lengthTo = new StringList(); // fixed length points "secondP|dist"

  Point(float _x, float _y, int id) {
    x = _x;
    y = _y;
    index = id;
  }

  void set(float nx, float ny) {
    if (isCenterOfCircle) {
      println("I'm center", pairIndex);
      points.get(pairIndex).set(points.get(pairIndex).x+(nx-x), points.get(pairIndex).y+(ny-y));
    }
    x = nx;
    y = ny;
  }

  void update() { 
    px = x;
    py = y;
    if (equals.size() != 0) { //male vertical
      for (int c : equals) {
        R_e.set(index, c);
        R_e.makeEquals();
      }
    }

    if (lengthTo.size() != 0) { //make fixed length
      for (String c : lengthTo) {

        int secondPoint = int(split(c, "|")[0]);
        //if(equals.hasValue(secondPoint)){
        float dist = float(split(c, "|")[1]);
        PVector p = R_l.getNewPoint(points.get(index), points.get(secondPoint), dist);
        boolean ell = false;
        for (Shape i : shapes) {
          if (i.isEllipse) {
            for (int j : i.pointsC) {
              if (j == index) {
                ell = true;
              }
            }
          }
        }
        if (ell) {
          if (!isCenterOfCircle) {
            drawSizeEllipse(p, getVector(), 50);
          } else {
            drawSizeEllipse(getVector(), p, 50);
          }
        } else {
          drawSizeA(p, getVector(), 25, 9, dist);
        }
        points.get(secondPoint).x = p.x;
        points.get(secondPoint).y = p.y;
        //}else{
        // System.err.println("Error"); 
        //}
      }
    }

    if (horiz.size() != 0) { //male horizontal
      for (int c : horiz) {
        points.get(c).set(points.get(c).x, y);
      }
    }

    if (vert.size() != 0) { //make vertical
      for (int c : vert) {
        points.get(c).set(x, points.get(c).y);
      }
    }

    if (!validPos()) {
      x = px;
      y = py;
    }
  }



  boolean equals(Point in) {
    return (in.x == x && in.y == y);
  }

  PVector getVector() {
    return new PVector(x, y);
  }

  boolean validPos() {
    boolean res = true;
    if (equals.size() != 0) { //male vertical
      for (int c : equals) {
        if (points.get(index).getVector() != points.get(c).getVector()) {
          res = false;
        }
      }
    }

    if (lengthTo.size() != 0) { //make fixed length
      for (String c : lengthTo) {
        int secondPoint = int(split(c, "|")[0]);
        float dist = float(split(c, "|")[1]);
        PVector p = R_l.getNewPoint(points.get(index), points.get(secondPoint), dist);
        if (abs(dist(p.x, p.y, x, y) - dist) >= 1.5) {
          res = false;
        }
      }
    }

    if (horiz.size() != 0) { //male horizontal
      for (int c : horiz) {
        R_h.set(c, this);
        PVector p = R_h.getHorizontalPoints()[0];
        if (p.y != y) {
          res = false;
        }
      }
    }

    if (vert.size() != 0) { //make vertical
      for (int c : vert) {
        R_v.set(c, this);
        PVector p = R_v.getVerticalPoints()[0];
        if (p.x != x) {
          res = false;
        }
      }
    }
    return res;
  }


  void PRect() {
    vector.pushStyle();
    vector.noStroke();
    vector.fill(selected ? color(218, 0, 0) : color(0, 218, 0));
    vector.rectMode(CENTER);
    vector.rect(getVector().x, getVector().y, 8, 8);
    vector.popStyle();
  }

  void horR() {  
    vector.stroke(255, 0, 255);
    vector.fill(255, 0, 255);
    vector.pushStyle();
    vector.strokeWeight(2);
    vector.line(x+2, y, x+8, y);
    vector.popStyle();
    vector.rect(x+8, y-2, 6, 4);
  }

  void horL() {  
    vector.stroke(255, 0, 255);
    vector.fill(255, 0, 255);
    vector.pushStyle();
    vector.strokeWeight(2);
    vector.line(x-2, y, x-8, y);
    vector.popStyle();
    vector.rect(x-6-8, y-2, 6, 4);
  }

  void vertU() {  
    vector.stroke(255, 0, 255);
    vector.fill(255, 0, 255);
    vector.pushStyle();
    vector.strokeWeight(2);
    vector.line(x, y, x, y-8);
    vector.popStyle();
    vector.rect(x-2, y-8-6, 4, 6);
  }

  void vertD() {  
    vector.stroke(255, 0, 255);
    vector.fill(255, 0, 255);
    vector.pushStyle();
    vector.strokeWeight(2);
    vector.line(x, y, x, y+8);
    vector.popStyle();
    vector.rect(x-2, y+8, 4, 6);
  }

  void drawSizeA(PVector A, PVector B, int lenU, int arrowsize, float dist) {
    vector.pushStyle();
    vector.stroke(255, 0, 255);
    drawSize(A, B, lenU);
    drawSize(B, A, -lenU);
    arrow(one.x, one.y, two.x, two.y, arrowsize);
    arrow(two.x, two.y, one.x, one.y, arrowsize);
    vector.line(one.x, one.y, two.x, two.y);
    vector.fill(255);
    vector.noStroke();
    vector.rectMode(CORNER);
    vector.rect((one.x+two.x)/2-15, (one.y+two.y)/2, str(int(dist)).length()*8, 10);
    vector.fill(255, 0, 255);
    vector.text(int(dist), (one.x+two.x)/2-15, (one.y+two.y)/2+10);
    one = null;
    two = null;
    vector.popStyle();
  }


  void drawSize(PVector A, PVector B, float l) {
    float dx = B.x - A.x;
    float dy = B.y - A.y;
    float length = sqrt(dx * dx + dy * dy);
    float k = l / length;
    PVector C =new PVector();
    C.x = A.x - dy * k;
    C.y = A.y + dx * k;
    vector.line(A.x, A.y, C.x, C.y); 
    if (one == null) {
      one = C;
    } else {
      two = C;
    }
  }

  void arrow(float x1, float y1, float x2, float y2, int size) {
    vector.pushMatrix();
    vector.translate(x2, y2);
    float a = atan2(x1-x2, y2-y1);
    vector.rotate(a);
    vector.line(0, 0, -size, -size);
    vector.line(0, 0, size, -size);
    vector.popMatrix();
  }

  void drawSizeEllipse(PVector f, PVector t, int size) {
    vector.pushStyle();
    vector.stroke(255, 0, 255);
    PVector ft = f; 
    f = getNewPoint(f, t, -PVector.dist(f, t));
    vector.line(f.x, f.y, t.x, t.y);
    arrow(f.x, f.y, t.x, t.y, 10);
    arrow(t.x, t.y, f.x, f.y, 10);
    PVector v = getNewPoint(f, t, PVector.dist(f, t)+size);
    vector.line(f.x, f.y, v.x, v.y);
    vector.line(v.x, v.y, v.x+size*1.5, v.y);
    float nx = (v.x+size*1.5+v.x)/2;
    vector.popStyle();
    vector.pushStyle();
    vector.stroke(255, 0, 255);
    vector.fill(255, 0, 255);
    vector.textFont(createFont("Georgia", 30));
    vector.text("⌀", nx-40, v.y-4);
    vector.textFont(createFont("Georgia", 14));
    vector.text(PVector.dist(ft, t)-PVector.dist(ft, t)%0.01, nx-25, v.y-9);
    vector.popStyle();
    //popMatrix();
  }

  PVector getNewPoint(PVector p1, PVector p2, float dis) {
    float x3 = p2.x - p1.x;
    float y3 = p2.y - p1.y;

    float len = sqrt( x3 * x3 + y3 * y3 );
    x3 /= len;
    y3 /= len;

    x3 *= dis;
    y3 *= dis;
    PVector res = new PVector( p1.x + x3, p1.y + y3 );
    return res;
  }
}