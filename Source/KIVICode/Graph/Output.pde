public class PWindow extends PApplet {
  String out = "";

  PShape rct, rctC, ell, lin;
  boolean pencilMode = true;
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void e() {
    exit();
  }

  void r(float x, float y, float w, float h) {
    out += ("r(" + x + "," + y + "," + w + "," + h + ");");
  }

  void rc(float x, float y, float w, float h) {
    out += ("rc(" + x + "," + y + "," + w + "," + h + ");");
  }

  void l(float x, float y, float w, float h) {
    out += ("l(" + x + "," + y + "," + w + "," + h + ");");
  }


  void e(float x, float y, float w) {
    out += ("e(" + x + "," + y + "," + w + ");");
  }

  void p(float x, float y) {
    out += ("p(" + x + "," + y + ");");
  }



  String data = "";

  void s() {
    out = ("s();");
    stroke(255, 0, 0);
  }


  void settings() {
    size(640, 480, P3D);
  }



  void setup() {
    frameRate(30);
    surface.setLocation(650, 500);
    surface.setResizable(true);
    surface.setTitle("Outview");
    rct = createShape(RECT, 0, 0, 0, 0);
    rctC = createShape(RECT, 0, 0, 0, 0);
    ell = createShape(ELLIPSE, 0, 0, 0, 0);
    lin = createShape(LINE, 0, 0, 0, 0);
    background(127);
    // noLoop();
  }


  void draw() {
    if (redscreen) {// && globalOutput.getChildCount() == line.size()) {
      background(255);
      //println("BKG cleared");
      //println("drawed "+frameCount);
      globalOutput.noFill();
      globalOutput.setStroke(0);
      shape(globalOutput);
    }

    if (out != "") {
      for (String a : split(out, ";")) {
        beginShape();
        String cmd = split(a, "(")[0];
        String[] p1 = split(split(a, ")")[0], "(");
        noFill();
        switch(cmd) {
        case "r":
          float[] o = (float(split(p1[1], ",")));
          rect((o[0]), (o[1]), (o[2]), (o[3]));
          break;

        case "l":
          float[] o1 = (float(split(p1[1], ",")));
          line((o1[0]), (o1[1]), (o1[2]), (o1[3]));
          break;

        case "e":
          float[] o2 = (float(split(p1[1], ",")));
          ellipse((o2[0]), (o2[1]), (o2[2]), (o2[2]));
          break;

        case "p":
          float[] o3 = (float(split(p1[1], ",")));
          point((o3[0]), (o3[1]));
          break;

        case "s":
          background(127);
          break;
        }
        endShape();
      }

      out = "";
    }
  }
}