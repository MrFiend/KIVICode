import java.io.FilenameFilter;

class Line extends Thread implements Runnable {
  final FilenameFilter TXTFILES = new FilenameFilter() {
    @ Override boolean accept(File f, String s) {
      return s.endsWith(".txt");
    }
  };

  StringDict par = new StringDict();

  IntDict in = new IntDict();

  float x;
  float y;
  float fx;
  float fy;
  float tx;
  float ty;

  boolean strk = true;
  boolean canDraw = true;
  boolean Vis = true;

  String whatHeppens = "";
  //String wthArc = "";
  String cnName;

  int maxInput = 1;
  int currIn = 1;

  String value;

  int type;
  int index;

  float in1, in2, in3, in4, in5, in6, in7, out;

  String input1 = "0", input2 = "0", input3 = "0", input4 = "0", input5 = "0", input6 = "0", input7 = "0";
  StringDict names = new StringDict();

  String tmp1 = null;
  String tmp2 = null;

  Line() {
  }

  Line(float x_, float y_, int t_, float v_, boolean a) {
    x = x_;
    y = y_;
    type = t_;
    value = str(v_);
    update();
  }

  Line(float x_, float y_, int t_, float v_, String name) {
    x = x_;
    y = y_;
    type = t_;
    value = str(v_);
    cnName = name;

    update();
  }

  Line(float x_, float y_, int t_, String name) {
    x = x_;
    y = y_;
    type = t_;
    cnName = name;

    update();
  }

  Line(float x_, float y_, int t_, String name, boolean inVis) {
    x = x_;
    y = y_;
    type = t_;
    cnName = name;
    Vis = false;
    update();
  }

  float getStr(String name) {
    return getInput(int(name));
  }
  void update() {
    whatHeppens = "";// + wthArc;
    if (Vis) {
      drawNode();
    }
    maxInput = 1;
    in1 = y+35;
    in2 = y+50;
    in3 = y+65;
    in4 = y+80;
    in5 = y+95;
    in6 = y+110;
    in7 = y+125;
    out = x+145;
  }

  void exitt() {
    exit();
  }

  float getInput(int i) {
    float result = 0;
    switch(i) {
    case 1:
      if (input1 != null) {
        result = float(input1);
      }
      break;

    case 2:
      if (input2 != null) {
        result = float(input2);
      }
      break;

    case 3:
      if (input3 != null) {
        result = float(input3);
      }
      break;

    case 4:
      if (input4 != null) {
        result = float(input4);
      }
      break;

    case 5:
      if (input5 != null) {
        result = float(input5);
      }
      break;

    case 6:
      if (input6 != null) {
        result = float(input6);
      }
      break;


    case 7:
      if (input7 != null) {
        result = float(input7);
      }
      break;
    }
    return result;
  }

  boolean select = false;

  void drawNode() {
    fill(140);
    if (select) {
      stroke(255, 0, 0);
    } else {
      noStroke();
    }

    if (type == -3 || type == -2) {
      maxInput = 2;
    }
    fill(140);
    rect(x, y, 150, 30, 7, 7, 0, 0);
    fill(#FA8A00);
    fill(90);
    rect(x, y+30, 150, (type == -3 || type == -2) ? maxInput*15+15 : maxInput*15, 0, 0, 7, 7);

    fill(#FA8A00);

    rect(x+140, in1, 10, 10);


    if (type == 0) {
      text("Float :  " + split(value, "|")[0], x+10, y+20);
      maxInput = 0;
    } else if (type == -2) {
      if (tmp1 != input1 && tmp2 != input2) {
        FigureExpression(input1, input2, false);
        tmp1 = input1;
        tmp2 = input2;
        println("DEBUG "+input1);
      }
      addInputt("a", split(split(input1, "|")[split(input1, "|").length-1], "(")[0]);
      addInputt("b", split(split(input2, "|")[split(input2, "|").length-1], "(")[0]);
      setTitle("Cut in");
      if (value != null) {
        for (String c : split(value, ";")) {
          if (split(c, "(").length > 1) {
            String p1 = split(c, "(")[1];
            String p2 = split(p1, ")")[0];
            String[] p3 = split(p2, ",");
            float[] p = float(p3);
            switch(split(c, "(")[0]) {
            case "vline":
              win.l(p[0], p[1], p[2], p[3]);
              break;

            case "hline":
              win.l(p[0], p[1], p[2], p[3]);
              break;

            case "arc3in":
              arc3in(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
              break;

            case "arc3out":
              arc3out(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
              break;

            case "point":
              win.p(p[0], p[1]);
              break;
            }
          }
        }
      }
    } else if (type == -3) {
      if (tmp1 != input1 && tmp2 != input2) {
        FigureExpression(input1, input2, true);
        tmp1 = input1;
        tmp2 = input2;
        println(input1);
      }

      addInputt("a", split(split(input1, "|")[split(input1, "|").length-1], "(")[0]);
      addInputt("b", split(split(input2, "|")[split(input2, "|").length-1], "(")[0]);
      setTitle("Cut out");
      if (value != "" && value != null) {
        whatHeppens = value;
        for (String c : split(value, ";")) {
          String p1 = split(c, ")")[0];
          if (split(p1, "(").length > 1) {
            String p2 = split(p1, "(")[1];
            float[] p = float(split(p2, ","));
            switch(split(p1, "(")[0]) {
            case "vline":
              win.l(p[0], p[1], p[2], p[3]);
              break;

            case "hline":
              win.l(p[0], p[1], p[2], p[3]);
              break;

            case "arc3in":
              arc3in(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
              break;

            case "arc3out":
              arc3out(p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
              break;

            case "point":
              win.p(p[0], p[1]);
              break;
            }
          }
        }
      }
    }
  }


  PShape matrix(int xraw, int yraw, float step) {
    PShape out = createShape(GROUP);
    if (whatHeppens.equals(null) || whatHeppens.equals("")) {
      whatHeppens = "";
    }
    for (float x = 0; x < xraw*step; x+=step) {
      for (float y = 0; y < yraw*step; y+=step) {
        if (value != null) {
          for (String c : split(value, ";")) {
            println(c);
            if (split(c, "(").length > 1) {
              String p1 = split(c, "(")[1];
              String p2 = split(p1, ")")[0];
              String[] p3 = split(p2, ",");
              float[] p = float(p3);
              float pl1 = p[2], pl2 = p[3];
              pl1 += x;
              pl2 += y;
              p[0] += x;
              p[1] += y;

              switch(split(split(c, "(")[0], "|")[1]) {
              case "vline":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(LINE, p[0], p[1], pl1, pl2));
                whatHeppens += "line(" + p[0] + "," + p[1] + "," + pl1 + "," + pl2 + ");";
                popStyle();
                break;

              case "hline":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(LINE, p[0], p[1], pl1, pl2));
                whatHeppens += "line(" + p[0] + "," + p[1] + "," + pl1 + "," + pl2 + ");";
                popStyle();
                break;

              case "line":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(LINE, p[0], p[1], pl1, pl2));
                whatHeppens += "line(" + p[0] + "," + p[1] + "," + pl1 + "," + pl2 + ");";
                popStyle();
                break;

              case "rect":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(RECT, p[0], p[1], p[2], p[3]));
                whatHeppens += "rect(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + ");";
                popStyle();
                break;

              case "arc3in":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(this.arc3in(p[0], p[1], p[2], p[3], p[4]+x, p[5]+y, p[6]));
                whatHeppens += "arc3in(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + "," + (p[4]+x) + "," + (p[5]+y) + "," + p[6] + ");";
                popStyle();
                break;

              case "ellipse":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(ELLIPSE, p[0], p[1], p[2], p[3]));
                whatHeppens += "ellipse(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + "," + p[4] + "," + p[5] + "," + p[6] + ");";
                popStyle();
                break;

              case "circle":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(ELLIPSE, p[0], p[1], p[2], p[2]));
                whatHeppens += "circle(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + ");";
                popStyle();
                break;
              case "arc3out":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(this.arc3out(p[0], p[1], p[2], p[3], p[4]+x, p[5]+y, p[6]));
                whatHeppens += "arc3out(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + "," + (p[4]+x) + "," + (p[5]+y) + "," + p[6] + ");";
                popStyle();
                break;

              case "point":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(POINT, p[0], p[1]));
                whatHeppens += "point(" + p[0] + "," + p[1] + ");";
                popStyle();
                break;
              }
            }
          }
        }
      }
    }
    return out;
  }

  PShape circleMatrix(int radius, float step) {
    PShape out = createShape(GROUP);
    int numPoints=360;
    float angle=TWO_PI/(float)numPoints;
    step = 360/step;
    for (float i=0; i<numPoints; i+=step) {
      float x = radius*sin(angle*i), y = radius*cos(angle*i);
      if (whatHeppens != null) {
        for (String c : split(whatHeppens, ";")) {
          //println("Zero = " + c);
          if (!c.equals(null) && split(c, "(").length > 1) {
            String p1 = split(c, "(")[1];
            //println("Cmd = " + p1);
            String p2 = split(p1, ")")[0];
            String[] p3 = split(p2, ",");
            float[] p = float(p3);
            float pl1 = p[2], pl2 = p[3];
            pl1 += x;
            pl2 += y;
            p[0] += x;
            p[1] += y;
            if (split(split(c, "(")[0], "|").length == 2) {
              switch(split(split(c, "(")[0], "|")[1]) {
              case "vline":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(LINE, p[0], p[1], pl1, pl2));
                whatHeppens += "line(" + p[0] + "," + p[1] + "," + pl1 + "," + pl2 + ");";
                popStyle();
                break;

              case "hline":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(LINE, p[0], p[1], pl1, pl2));
                whatHeppens += "line(" + p[0] + "," + p[1] + "," + pl1 + "," + pl2 + ");";
                popStyle();
                break;

              case "line":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(LINE, p[0], p[1], pl1, pl2));
                whatHeppens += "line(" + p[0] + "," + p[1] + "," + pl1 + "," + pl2 + ");";
                popStyle();
                break;

              case "rect":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(RECT, p[0], p[1], p[2], p[3]));
                whatHeppens += "rect(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + ");";
                popStyle();
                break;

              case "arc3in":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(this.arc3in(p[0], p[1], p[2], p[3], p[4]+x, p[5]+y, p[6]));
                whatHeppens += "arc3in(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + "," + (p[4]+x) + "," + (p[5]+y) + "," + p[6] + ");";
                popStyle();
                break;

              case "ellipse":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(ELLIPSE, p[0], p[1], p[2], p[3]));
                whatHeppens += "ellipse(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + "," + p[4] + "," + p[5] + "," + p[6] + ");";
                popStyle();
                break;

              case "circle":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(ELLIPSE, p[0], p[1], p[2], p[2]));
                whatHeppens += "circle(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + ");";
                popStyle();
                break;
              case "arc3out":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(this.arc3out(p[0], p[1], p[2], p[3], p[4]+x, p[5]+y, p[6]));
                whatHeppens += "arc3out(" + p[0] + "," + p[1] + "," + p[2] + "," + p[3] + "," + (p[4]+x) + "," + (p[5]+y) + "," + p[6] + ");";
                popStyle();
                break;

              case "point":
                pushStyle();
                noFill();
                stroke(0);
                out.addChild(createShape(POINT, p[0], p[1]));
                whatHeppens += "point(" + p[0] + "," + p[1] + ");";
                popStyle();
                break;
              }
            }
          }
        }
      }
    }
    return out;
  }

  String wth1 = "", wth2 = "";

  void FigureExpression(String a, String b, boolean type) {
    if (a != "0" && b != "0") {

      value = "";
      wth1 = line.get(int((split(a, "|")[0]))).whatHeppens;
      wth2 = line.get(int((split(b, "|")[0]))).whatHeppens;
      line.get(int((split(a, "|")[0]))).whatHeppens = "";
      line.get(int((split(a, "|")[0]))).canDraw = false;
      line.get(int((split(b, "|")[0]))).whatHeppens = "";
      line.get(int((split(b, "|")[0]))).canDraw = false;
      String[] c = {split(line.get(int((split(a, "|")[0]))).value, "|")[1], split(line.get(int((split(b, "|")[0]))).value, "|")[1]};
      printArray(b);
      println("\n");
      String[] cm = {split(c[0], "(")[0], split(c[1], "(")[0]};
      String[][] p = {split(split(c[0], ")")[0], "("), split(split(c[1], ")")[0], "(")};
      int cmd[] = {int(cm[0].replace("rect", "0").replace("circle", "1")), int(cm[1].replace("rect", "0").replace("circle", "1"))};
      float[] pA = (float(split(p[0][1], ",")));
      float[] pB = (float(split(p[1][1], ",")));
      printArray(cmd);
      if (cmd[0] == 0) {
        if (cmd[1] == 0) {


          boolean l = false, d = false, r = false, u = false;
          float endL = pA[1]+pA[3], endD = pA[0]+pA[2], endR = pA[1]+pA[3], endU = pA[0]+pA[2];
          float startL = pA[1], startD = pA[0], startR = pA[1], startU = pA[0];
          for (float i = pA[1]; i < pA[1]+pA[3]; i++) {
            if (!l && isCountorR(pA[0], i, pB[0], pB[1], pB[2], pB[3])) {
              win.p(pA[0], i);
            }

            if (!onRect(pA[0], i-1, pB[0], pB[1], pB[2], pB[2]) && onRect(pA[0], i+1, pB[0], pB[1], pB[2], pB[3])) {
              l = true;
              endL = i;
            }

            if (onRect(i, pA[1], pB[0], pB[1], pB[2], pB[3]) && !onRect(i+1, pA[1], pB[0], pB[1], pB[2], pB[3])) {
              startL = i;
            }
          }

          for (float i = pA[0]; i < pA[0]+pA[2]; i++) {
            if (!d && isCountorR(i, pA[1]+pA[3], pA[0], pA[1], pA[2], pA[3]) && !onRect(i, pA[1]+pA[3], pB[0], pB[1], pB[2], pB[3])) {
              win.p(i, pA[1]+pA[3]);
            }

            if (!onRect(i-1, pA[1]+pA[3], pB[0], pB[1], pB[2], pB[3]) && onRect(i+1, pA[1]+pA[3], pB[0], pB[1], pB[2], pB[3])) {
              endD = i;
              d = true;
            }

            if (onRect(i, pA[1]+pA[3], pB[0], pB[1], pB[2], pB[3]) && !onRect(i+1, pA[1]+pA[3], pB[0], pB[1], pB[2], pB[3])) {
              startD = i;
            }
          }

          for (float i = pA[1]; i < pA[1]+pA[3]; i++) {
            if (!r && !isCountorR(pA[0]+pA[2], i, pB[0], pB[1], pB[2], pB[3])) {
              win.p(pA[0]+pA[2], i);
            }

            if (!onRect(pA[0]+pA[2], i-1, pB[0], pB[1], pB[2], pB[3]) && onRect(pA[0]+pA[2], i+1, pB[0], pB[1], pB[2], pB[3])) {
              r = true;
              endR = i;
            }

            if (onRect(pA[0]+pA[2], i, pB[0], pB[1], pB[2], pB[3]) && !onRect(pA[0]+pA[2], i+1, pB[0], pB[1], pB[2], pB[3])) {
              startR = i;
            }
          }


          for (float i = pA[0]; i < pA[0]+pA[2]; i++) {
            if (!onRect(i, pA[1], pB[0], pB[1], pB[2], pB[3])) {
              win.p(i, pA[1]);
            }

            if (!u && !onRect(i-1, pA[1], pB[0], pB[1], pB[2], pB[3]) && onRect(i+1, pA[1], pB[0], pB[1], pB[2], pB[3])) {
              endU = i;
              u = true;
            }

            if (onRect(i, pA[1], pB[0], pB[1], pB[2], pB[3]) && !onRect(i+1, pA[1], pB[0], pB[1], pB[2], pB[3])) {
              startU = i;
            }
          }
          value+="vline(" + (pA[0]+pA[2]) + "," + startR + "," + (pA[0]+pA[2]) + "," + endR + ");";
          value+="hline(" + endD + "," + (pA[1]+pA[3]) + "," + startD + "," + (pA[1]+pA[3]) + ");";
          value+="vline(" + pA[0] + "," + startL + "," + pA[0] + "," + endL + ");";
          value+="hline(" + startU + "," + pA[1] + "," + endU + "," + pA[1] + ");";


          //println(value);
        } else if (cmd[1] == 1) {
          println("Test");
          boolean l = false, d = false, r = false, u = false;
          boolean sl = false, sd = false, sr = false, su = false;
          float endL = pA[1]+pA[3], endD = pA[0]+pA[2], endR = pA[1]+pA[3], endU = pA[0]+pA[2];
          float startL = pA[1], startD = pA[0], startR = pA[1], startU = pA[0];
          for (float i = pA[1]; i < pA[1]+pA[3]; i++) {
            if (!l && isCountorC(pA[0], i, pB[0], pB[1], pB[2])) {
              win.p(pA[0], i);
            }

            if (!onCircle(pA[0], i-1, pB[0], pB[1], pB[2], 0) && onCircle(pA[0], i+1, pB[0], pB[1], pB[2], 0)) {
              l = true;
              endL = i;
            }

            if (onCircle(i, pA[1], pB[0], pB[1], pB[2], 0) && !onCircle(i+1, pA[1], pB[0], pB[1], pB[2], 0)) {
              startL = i;
              sl = true;
            }
          }

          for (float i = pA[0]; i < pA[0]+pA[2]; i++) {
            if (!d && isCountorR(i, pA[1]+pA[3], pA[0], pA[1], pA[2], pA[3]) && !onCircle(i, pA[1]+pA[3], pB[0], pB[1], pB[2], 0)) {
              win.p(i, pA[1]+pA[3]);
            }

            if (!onCircle(i-1, pA[1]+pA[3], pB[0], pB[1], pB[2], 0) && onCircle(i+1, pA[1]+pA[3], pB[0], pB[1], pB[2], 0)) {
              endD = i;
              d = true;
            }

            if (onCircle(i, pA[1]+pA[3], pB[0], pB[1], pB[2], 0) && !onCircle(i+1, pA[1]+pA[3], pB[0], pB[1], pB[2], 0)) {
              startD = i;
              sd = true;
            }
          }

          for (float i = pA[1]; i < pA[1]+pA[3]; i++) {
            if (!r && !isCountorC(pA[0]+pA[2], i, pB[0], pB[1], pB[2])) {
              win.p(pA[0]+pA[2], i);
            }

            if (!onCircle(pA[0]+pA[2], i-1, pB[0], pB[1], pB[2], 0) && onCircle(pA[0]+pA[2], i+1, pB[0], pB[1], pB[2], 0)) {
              r = true;
              endR = i;
            }

            if (onCircle(pA[0]+pA[2], i, pB[0], pB[1], pB[2], 0) && !onCircle(pA[0]+pA[2], i+1, pB[0], pB[1], pB[2], 0)) {
              startR = i;
              sr = true;
            }
          }


          for (float i = pA[0]; i < pA[0]+pA[2]; i++) {
            if (!onCircle(i, pA[1], pB[0], pB[1], pB[2], 0)) {
              win.p(i, pA[1]);
            }

            if (!u && !onCircle(i-1, pA[1], pB[0], pB[1], pB[2], 0) && onCircle(i+1, pA[1], pB[0], pB[1], pB[2], 0)) {
              endU = i;
              u = true;
            }

            if (onCircle(i, pA[1], pB[0], pB[1], pB[2], 0) && !onCircle(i+1, pA[1], pB[0], pB[1], pB[2], 0)) {
              startU = i;
              su = true;
            }
          }

          value+="vline(" + (pA[0]+pA[2]) + "," + startR + "," + (pA[0]+pA[2]) + "," + endR + ");";
          value+="hline(" + endD + "," + (pA[1]+pA[3]) + "," + startD + "," + (pA[1]+pA[3]) + ");";
          value+="vline(" + pA[0] + "," + startL + "," + pA[0] + "," + endL + ");";
          value+="hline(" + startU + "," + pA[1] + "," + endU + "," + pA[1] + ");";

          println(type);
          if (!type) {
            println("arc3in");
            value+="arc3in(" + pA[0] + "," + pA[1] + "," + pA[2] + "," + pA[3] + "," + pB[0] + "," + pB[1] + "," + pB[2] + "," + type + ");";
            arc3in(pA[0], pA[1], pA[2], pA[3], pB[0], pB[1], pB[2]);
          } else {
            println("arc3out");
            value+="arc3out(" + pA[0] + "," + pA[1] + "," + pA[2] + "," + pA[3] + "," + pB[0] + "," + pB[1] + "," + pB[2] + "," + type + ");";
            arc3out(pA[0], pA[1], pA[2], pA[3], pB[0], pB[1], pB[2]);
          }
          whatHeppens = value;
          //wthArc = value;
        }
      }
    } else {
      if (int((split(a, "|")[0])) > line.size() && a != "" &&b != "") {
        //println(int((split(a, "|")[0])),line.size()-1,int((split(a, "|")[0])) >= line.size()-1);
        line.get(int((split(a, "|")[0]))).canDraw = true;
        line.get(int((split(b, "|")[0]))).canDraw = true;

        line.get(int((split(a, "|")[0]))).whatHeppens = wth1;
        line.get(int((split(b, "|")[0]))).whatHeppens = wth2;
      }
    }
  }

  PShape arc3out(float xr, float yr, float wr, float hr, float x, float y, float radius) {
    PShape out = createShape();
    out.beginShape();
    radius = radius/2;
    int points = 3600;
    double slice = 2 * Math.PI / points;
    for (float i = 0; i < points+1; i++)
    {
      double angle = slice * i;
      float newX = rnd((x + radius * cos((float)angle)), 6);
      float newY = rnd((y + radius * sin((float)angle)), 6);
      if (!onRect(newX, newY, xr, yr, wr, hr)) {
        out.vertex(newX, newY);
        win.p(newX, newY);
      }
    }
    out.endShape();
    return out;
  }

  PShape arc3in(float xr, float yr, float wr, float hr, float x, float y, float radius) {
    PShape out = createShape();
    out.beginShape();
    radius = radius/2;
    int points = 3600;
    double slice = 2 * Math.PI / points;
    for (float i = 0; i < points+1; i++)
    {
      double angle = slice * i;
      float newX = rnd((x + radius * cos((float)angle)), 6);
      float newY = rnd((y + radius * sin((float)angle)), 6);
      if (onRect(newX, newY, xr, yr, wr, hr)) {
        out.vertex(newX, newY);
        win.p(newX, newY);
      }
    }
    out.endShape();
    return out;
  }

  boolean isCountorR(float i_, float j_, float x_, float y_, float w_, float h_) {
    if (nonRect(i_-1, j_, x_, y_, w_, h_) || nonRect(i_, j_+1, x_, y_, w_, h_) || nonRect(i_, j_-1, x_, y_, w_, h_)) {
      return true;
    }

    return false;
  }

  boolean isCountorC(float i_, float j_, float x_, float y_, float w_) {
    if (dist(i_, j_, x_, y_) == w_) {
      return true;
    }

    return false;
  }

  boolean onRect(float x, float y, float bx, float by, float bw, float bh) {
    if (x >= bx && x <= bx+bw && y >= by && y <= by+bh) {
      return true;
    }
    return false;
  }

  boolean onCircle(float x, float y, float bx, float by, float bw, float a) {
    if (dist(x, y, bx, by) <= bw/2) {
      return true;
    }
    return false;
  }

  boolean nonRect(float x, float y, float bx, float by, float bw, float bh) {
    if (x >= bx && x <= bx+bw && y >= by && y <= by+bh) {
      return false;
    }
    return true;
  }

  float rnd(float number, float decimal) {
    return (float)(round((number*pow(10, decimal))))/pow(10, decimal);
  }



  void addInputt(String name, String val) {
    fill(#FA8A00);

    text(name+" = " + val, x+15, y+(15*(maxInput-1))+27.5);
    rect(x, y+(15*(maxInput-1))+20, 10, 10);
    par.set(name, str(maxInput));

    maxInput++;
  }

  void setTitle(String t) {
    text(t, x+10, y+20);
    cnName = t;
  }
}