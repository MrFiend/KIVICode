public class VectorEditor extends PApplet {
  VectorEditor() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
  DashedLines dash;

  boolean visibility = false;

  int currMode = LINE;       //RECT = 30    LINE = 4     ELLIPSE = 31     POINT = 2
  int pointCount = 2;

  Point tmp;

  void setup() {
    this.surface.setSize(displayWidth*3>>2, displayHeight*3>>2);
    this.surface.setLocation(0, 0);
    this.surface.setTitle("Vector Editor");
    removeExitEvent(this.surface);
    dash = new DashedLines(this);
    dash.pattern(20, 10);
    this.frameRate(60);
  }

  void settings() {
  }

  public void setVis(boolean a) {
    surface.setVisible(a);
  }

  void draw() {
    switch(currMode) {
    case LINE:
      pointCount = 2;
      break;

    case RECT:
      pointCount = 4;
      break;

    case ELLIPSE:
      pointCount = 2;
      break;
    }
    //redscreen = false;
    vector.background(255); 
    update();
    vector.fill(0);
    vector.text("Mode : " + (cursor ? "Cursor" : "Pen"), 20, 40);
    if (cursor && mpressed && !anyPointsSelected) {
      noFill();
      stroke(0);
      rect(pressed.x, pressed.y, mouseX-pressed.x, mouseY-pressed.y);
    }
    drawToolBar();
    this.surface.setTitle("Vector Editor " + this.frameRate);
  }

  void update() {
    for (Shape curr : shapes) {
      curr.update();
    }
  }

  void drawToolBar() {
    pushStyle();
    rectMode(CENTER);
    noFill();
    stroke(170);

    float zx = width/2 - 150;
    float zy = height-59  + 10;
    float ey = height+1  -10;

    fill(255);

    rect(width/2, height-29, 300, 60);
    line(zx+(60*1), zy, zx+(60*1), ey);
    line(zx+(60*2), zy, zx+(60*2), ey);
    line(zx+(60*3), zy, zx+(60*3), ey);
    line(zx+(60*4), zy, zx+(60*4), ey);
    line(zx+(60*5), zy, zx+(60*5), ey);

    //Draw line icon
    noStroke();
    fill(currMode == LINE ? 230 : 255);
    rect(zx+31, zy+21, 59, 60);
    stroke(0);
    line(zx+20, zy+30, zx+50, zy+10);
    fill(color(0, 218, 0));
    noStroke();
    rect(zx+20, zy+30, 6, 6);
    rect(zx+50, zy+10, 6, 6);

    //Draw rect icon
    noStroke();
    fill(currMode == RECT ? 230 : 255);
    rect(zx+91, zy+21, 59, 60);
    stroke(0);
    noFill();
    rect(zx+90, zy+20, 20, 20);
    fill(color(0, 218, 0));
    noStroke();
    rect(zx+80, zy+10, 6, 6);
    rect(zx+100, zy+10, 6, 6);
    rect(zx+100, zy+30, 6, 6);
    rect(zx+80, zy+30, 6, 6);

    //Draw ellipse icon
    noStroke();
    fill(currMode == ELLIPSE ? 230 : 255);
    rect(zx+151, zy+21, 59, 60);
    stroke(0);
    noFill();
    ellipse(zx+150, zy+20, 30, 30);
    fill(color(0, 218, 0));
    noStroke();
    rect(zx+150, zy+20, 6, 6);
    rect(zx+165, zy+20, 6, 6);

    //Draw point's icon
    noStroke();
    fill(currMode == POINT ? 230 : 255);
    rect(zx+211, zy+21, 59, 60);
    stroke(0);
    fill(0);
    textAlign(CENTER);
    text(pointCount+"\nPoint(s)", zx+210, zy+15);

    //Draw mode icon
    noStroke();
    fill(cursor ? 200 : 255);
    rect(zx+271, zy+21, 59, 60);
    stroke(0);
    fill(0);
    textAlign(CENTER);
    text("Change\nmode", zx+270, zy+15);

    popStyle();
  }

  void Dline(float x1, float y1, int x2, int y2) {
    vector.dash.line(x1, y1, x2, y2);
  }


  void exit() {
    vector.setVis(false);
  }
  void keyPressed() {
    switch(key) {

    case ' ':
      cursor = !cursor; 
      break;

    case 'h':
      if (selPoints.size() == 2) {
        println("Horizontal "+selPoints);
        points.get(selPoints.get(1)).horiz.append(selPoints.get(0));
      } else {
        println("Horizonal error");
      }
      break;

    case 'v':
      if (selPoints.size() == 2) {
        println("Vertical "+selPoints);
        points.get(selPoints.get(1)).vert.append(selPoints.get(0));
      }
      break;

    case 'o':
      if (selPoints.size() == 2) {
        println("Equals "+selPoints);
        points.get(selPoints.get(0)).equals.append(selPoints.get(1));
      }
      break;

    case 'd':
      if (selPoints.size() == 2) {
        println("Distance "+selPoints);
        float dist = float(showInputDialog("Enter new distance"));
        //points.get(selPoints.get(0)).lengthTo.append(selPoints.get(1) + "|" + dist);
        points.get(selPoints.get(1)).lengthTo.append(selPoints.get(0) + "|" + dist);
      }
      break;

    case 'l':
      if (selPoints.size() == 2) {
        println("Distance "+dist(points.get(selPoints.get(1)).x, points.get(selPoints.get(1)).y, points.get(selPoints.get(0)).x, points.get(selPoints.get(0)).y));
      }
      break;

    case BACKSPACE:
      if (selPoints.size() > 0) {
        for (int i : selPoints) {
          delPFromAllShapes(i);
        }
      }
    }
  }

  void delPFromAllShapes(int point) {
    for (Shape c : shapes) {
      if (c.pointsC.hasValue(point)) {
        int i = 0;
        for (int cp : c.pointsC) {
          if (cp == point) {
            c.pointsC.remove(i);
            println(i);
          }
          i++;
        }
      }
    }
  }

  int numPressed = 0;
  Point pressed;
  boolean mpressed = false;
  void mousePressed() {
    if (cursor) {
      mpressed = true;
      pressed = new Point(float(mouseX), float(mouseY), -1);
    }
    if (onRect(mouseX, mouseY, width/2 - 150, height-49, 300, 60)) {
      if (onRect(mouseX, mouseY, width/2 - 150, height-49, 60, 60)) {
        currMode = LINE;
      } else if (onRect(mouseX, mouseY, width/2 - 90, height-49, 60, 60)) {
        currMode = RECT;
      } else if (onRect(mouseX, mouseY, width/2 - 30, height-49, 60, 60)) {
        currMode = ELLIPSE;
      } else if (onRect(mouseX, mouseY, width/2 + 30, height-49, 60, 60)) {
        currMode = POINT;
        pointCount = int(showInputDialog("Enter new point count"));
      } else if (onRect(mouseX, mouseY, width/2 + 90, height-49, 60, 60)) {
        cursor = !cursor;
      }
    } else if (!cursor) {

      if (shapes.size() == 0 || !(shapes.get(shapes.size()-1).pointN != shapes.get(shapes.size()-1).pointCountM)) {
        int npr = numPressed;
        numPressed = 0;
        shapes.add(new Shape(pointCount));
        if (currMode == ELLIPSE) {
          shapes.add(new Shape(pointCount, true));
        }
      }


      Point np = new Point(mouseX, mouseY, points.size());
      tmp = np;
      addToPoints(np);
      if (currMode == RECT) {
        if (numPressed>0) {
          switch(numPressed) {
          case 1:
            points.get(points.size()-2).horiz.append(points.size()-1);
            break;

          case 2:
            points.get(points.size()-2).vert.append(points.size()-1);
            break;

          case 3:
            points.get(points.size()-2).horiz.append(points.size()-1);
            points.get(points.size()-4).vert.append(points.size()-1);
            break;
          }
        }
        numPressed++;
      }
      if (currMode == ELLIPSE) {
        println(numPressed);
        if (numPressed == 0) {
          //points.get(points.size()-1).selected = true;
          points.get(points.size()-1).isCenterOfCircle = true;
          points.get(points.size()-1).pairIndex = points.size();
        }
        numPressed++;
      }

      addPointToShape(-1, -1);
    } else {
      anyPointsSelected = false;
      int i = 0;
      for (Point p : points) {
        if (dist(p.x, p.y, mouseX, mouseY) < 6) {
          if (!p.selected) {
            selPoints.append(i);
            pointDrag = i;
            anyPointsSelected = true;
          }
          p.selected = !p.selected;
        }
        i++;
      }
      if (!anyPointsSelected) {
        selPoints.clear();
        pointDrag = -1;
        for (Point p : points) {
          p.selected = false;
        }
      }
    }
  }

  void mouseDragged() {
    if (pointDrag != -1 && cursor) {
      int c = pointDrag;
      points.get(c).set(points.get(c).x-(pmouseX-mouseX), points.get(c).y-(pmouseY-mouseY));
      points.get(c).selected = false;
    } else if (cursor) {
      noFill();
      rect(pressed.x, pressed.y, mouseX-pressed.x, mouseY-pressed.y);
    }
  }

  void mouseReleased() {
    if (mpressed && cursor) {
      mpressed = false;
      int i = 0;
      for (Point c : points) {
        if (onRect(c.x, c.y, pressed.x, pressed.y, mouseX-pressed.x, mouseY-pressed.y)) {
          c.selected = true; 
          selPoints.append(i);
        }
        i++;
      }
    }
  }

  void addToPoints(Point n) {
    points.add(n);
  }

  void addPointToShape(int add, int num) {
    if (num == -1) { 
      num = shapes.size()-1;
    }
    if (add == -1) { 
      add = points.size()-1;
    }
    shapes.get(num).add(add);
  }
}