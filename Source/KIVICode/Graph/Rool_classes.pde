class Rool_Horizontal { //calculate horizontal line points

  Point one, two;
  Rool_Horizontal() {
  }
  PVector[] getHorizontalPoints() {
    PVector p1 = new PVector(), p2 = new PVector();
    p1.y = one.y;
    p1.x = two.x;

    p2.y = two.y;
    p2.x = two.x;
    PVector[] r = {p1, p2};
    return r;
  }

  void set(int one_, Point two_) {
    two = two_;
    one = points.get(one_);
    one.y = points.get(one_).y;
    if (points.get(two.index).y > points.get(one.index).y) {
      points.get(two.index).horL();
      points.get(one.index).horR();
    } else {
      points.get(two.index).horR();
      points.get(one.index).horL();
    }
  }
  boolean isPointValid(Point in) {
    if (getHorizontalPoints()[1].y == in.getVector().y) {
      return true;
    }
    return false;
  }
}

class Rool_Vertical { //calculate vertical line points

  Point one, two;
  Rool_Vertical() {
  }

  PVector[] getVerticalPoints() {
    PVector p1 = new PVector(), p2 = new PVector();
    p1.y = one.y;
    p1.x = two.x;

    p2.y = two.y;
    p2.x = two.x;
    PVector[] r = {p1, p2};
    return r;
  }

  void set(int one_, Point two_) {
    two = two_;
    one = points.get(one_);
    one.x = points.get(one_).x;
    if (points.get(two.index).y > points.get(one.index).y) {
      points.get(two.index).vertU();
      points.get(one.index).vertD();
    } else {
      points.get(two.index).vertD();
      points.get(one.index).vertU();
    }
  }

  boolean isPointValid(Point in) {
    if (getVerticalPoints()[1].x == in.getVector().x) {
      return true;
    }
    return false;
  }
}

class Rool_FixedDistance { //fixed length rool
  Point one, two;
  float dist;

  Rool_FixedDistance() {
  }

  void set(Point s, Point e, float nd) {
    one = s;
    two = e;
    dist = nd;
  }

  PVector getNewPoint(Point p1, Point p2, float dis) {
    //get vector  
    float x3 = p2.x - p1.x;
    float y3 = p2.y - p1.y;

    //normalize vector
    float len = sqrt( x3 * x3 + y3 * y3 );
    x3 /= len;
    y3 /= len;

    //scale vector
    x3 *= dis;
    y3 *= dis;
    //if(p1.x > p2.x && 
    PVector res = new PVector( p1.x + x3, p1.y + y3 );
    return res;
  }

  boolean isPointValid(Point in, Point pair, float dist) {
    if (abs(dist(in.x, in.y, pair.x, pair.y) - dist) < 1.5) {
      return true;
    }
    return false;
  }
}

































class Rool_Equals {

  int one, two;

  Rool_Equals() {
  };

  void set(int o, int t) {
    one = o;
    two = t;
  }

  void makeEquals() {
    for (Shape currS : shapes) {
      if (currS.pointsC.hasValue(two)) {
        if (points.get(two).horiz.size() != 0) {//points.get(two).vert.size() != 0
          if (points.get(two).y == points.get(one).y) {
            currS.pointsC.set(getIndex(currS.pointsC, two), one);
            println(points.get(two).y, points.get(one).y);
          }else{
           //redscreen = true; 
           System.err.println("Fatal Error");
          }
        } else if (points.get(two).vert.size() != 0) {
          if (points.get(two).x == points.get(one).x) {
            currS.pointsC.set(getIndex(currS.pointsC, two), one);
          }else{
           System.err.println("Fatal Error");
          }
        } else {
          println(points.get(one).horiz,points.get(two).horiz,one,two);
          println(points.get(one).vert,points.get(two).vert);
          currS.pointsC.set(getIndex(currS.pointsC, two), one);
        }
      }
    }
  }

  int getIndex(IntList in, int value) {
    for (int i = 0; i < in.size(); i++) {
      if (in.get(i) == value) {
        return i;
      }
    }
    return -1;
  }
}