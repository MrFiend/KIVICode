class Shape { //<>// //<>// //<>//

  Shape(int startPointCount) {
    pointCountM = startPointCount;
  }

  Shape(int startPointCount, boolean el) {
    pointCountM = startPointCount;
    isEllipse = el;
  }

  int pointCountM = 0;
  int pointN = 0;
  IntList pointsC = new IntList();
  PShape out;
  boolean closed = false;
  boolean added = false;
  boolean isEllipse = false;

  PShape circle(float x, float y, float radius)
  {
    PShape o = createShape();
    radius = radius/2;
    int points = 3600;
    double slice = TWO_PI / points;
    for (int i = 0; i < points+1; i++)
    {
      double angle = slice * i;
      float newX = x + radius * cos((float)angle);
      float newY = y + radius * sin((float)angle);
      o.vertex(newX, newY);
    }
    return o;
  }

  void update() {

    if (points.size() > 0) {
      //rpushStyle();

      //if (isEllipse) {
      //  Point p1, p2;
      //  p1 = points.get(pointsC.get(0));
      //  if (pointsC.size() >= 2) {
      //    p2 = points.get(pointsC.get(1));
      //    out = circle(p1.x, p1.y, dist(p2.x, p2.y, p1.x, points.get(0).y));
      //    out.noFill();
      //  } else {
      //    vector.dash.ellipse(p1.x, p1.y, dist(mouseX, mouseY, p1.x, points.get(0).y), dist(mouseX, mouseY, p1.x, points.get(0).y));
      //  }
      //} 
      out = createShape();
      noFill();
      //fill(color(255, 255, 255, 60));
      out.beginShape();
      out.noFill();
      for (int curr : pointsC) { //making shape
        if (curr != -1) {
          points.get(curr).update();
        }
      }
      if (isEllipse) {
        if (pointsC.size()==2) {
          float x = points.get(pointsC.get(0)).x;
          float y = points.get(pointsC.get(0)).y;
          float radius = dist(points.get(pointsC.get(0)).x, points.get(pointsC.get(0)).y, points.get(pointsC.get(1)).x, points.get(pointsC.get(1)).y);
          //radius = radius/2;
          int points = 3600;
          double slice = TWO_PI / points;
          for (int i = 0; i < points+1; i++)
          {
            double angle = slice * i;
            float newX = x + radius * cos((float)angle);
            float newY = y + radius * sin((float)angle);
            out.vertex(newX, newY);
          }
        }
      } else {
        for (int curr : pointsC) { //making shape
          if (curr != -1) {
            points.get(curr).update();
            Point c = points.get(curr);
            out.vertex(c.getVector().x, c.getVector().y);
          }
        }
      }

      if (!isEllipse) {
        closeShape();
      }
      vector.shape(out); //<>// //<>// //<>// //<>//

      if (pointN < pointCountM && pointN > 0) { //draw dashed line
        Point pn = vector.tmp;


        vector.pushStyle();
        vector.stroke(0);
        if (vector.currMode == LINE) {
          vector.Dline(pn.x, pn.y, vector.mouseX, vector.mouseY);
        } else if (vector.currMode == RECT) {
          switch(vector.numPressed) {
          case 1:
            vector.Dline(pn.x, pn.y, vector.mouseX, int(pn.y));
            break;

          case 2:
            vector.Dline(pn.x, pn.y, int(pn.x), vector.mouseY);
            break;

          case 0:
            vector.Dline(vector.mouseX, int(pn.y), vector.mouseX, vector.mouseY);
            break;

          case 3:
            vector.Dline(int(pn.x), int(pn.y), vector.mouseX, int(pn.y));
            break;
          }
        } else if (vector.currMode == ELLIPSE) {
          float r = dist(pn.x, pn.y, mouseX, mouseY)*2;
          noFill();
          stroke(170);
          vector.Dline(int(pn.x), int(pn.y), vector.mouseX, int(pn.y));
          vector.Dline(vector.mouseX, int(pn.y), vector.mouseX, vector.mouseY);
        }
        vector.popStyle();
      }

      for (int curr : pointsC) { //making shape
        if (curr != -1) {
          points.get(curr).PRect();
        }
      }
     // popStyle();
    }
  }


  void dashedCircle(float x, float y, float radius) {
    vector.pushMatrix();
    vector.translate(x, y);
    int steps = 200;
    int dashWidth = 6;
    int dashSpacing = 4;
    int dashPeriod = dashWidth + dashSpacing;
    boolean lastDashed = false;
    for (int i = 0; i < steps; i++) {
      boolean curDashed = (i % dashPeriod) < dashWidth;
      if (curDashed && !lastDashed) {
        vector.beginShape();
      }
      if (!curDashed && lastDashed) {
        vector.endShape();
      }
      if (curDashed) {
        float theta = map(i, 0, steps, 0, TWO_PI);
        vector.vertex(cos(theta) * radius, sin(theta) * radius);
      }
      lastDashed = curDashed;
    }
    if (lastDashed) {
      vector.endShape();
    }
    vector.popMatrix();
  }

  void closeShape() {
    out.endShape(CLOSE);
    out.setStroke(0);
  }

  void add(int p) {
    if (pointN < pointCountM) {
      pointsC.append(p);
      pointN++;
    }
  }
}