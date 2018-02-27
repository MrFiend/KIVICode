/*                                                    Функции                                                    *///<>// //<>// //<>// //<>//


void addInput(String name) {
  if (object.Vis) {
    fill(#FA8A00);
    text(name+" = " + (object.getInput(object.maxInput)), object.x+15, object.y+(15*object.maxInput)+27.5);
    rect(object.x, object.y+(15*object.maxInput)+20, 10, 10);
    object.par.set(name, str(object.maxInput));
    object.in.set(name, int(object.maxInput));
    object.names.set(name, str(object.maxInput));
    object.maxInput++;
  }
}

void setTitle(String t) {
  if (object.Vis) {
    fill(140);
    //rect(object.x+10, object.y+20, 20, 7);
    fill(30);
    fill(#FA8A00);
    text(t, object.x+10, object.y+20);
    object.cnName = t;
  }
}


void drawArcIn(float param1, float param2, float param3, float param4, float param5, float param6, float param7) {
  if (object.canDraw) {
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(object.arc3in(number(str(param1)), number(str(param2)), number(str(param3)), number(str(param4)), number(str(param5)), number(str(param6)), number(str(param7))));
    //circleOut.addChild(object.arc3in(number(param1), number(param2), number(param3), number(param4), number(param5), number(param6), number(param7)));
    popStyle();
  }
  object.whatHeppens += "arc3in(" + number(str(param1)) + "," + number(str(param2)) + "," + number(str(param3)) + "," + number(str(param4)) + "," + number(str(param5)) + "," + number(str(param6)) + "," + number(str(param7)) + ");";
  object.value = object.whatHeppens;
}

void drawArcOut(float param1, float param2, float param3, float param4, float param5, float param6, float param7) {
  if (object.canDraw) {
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(object.arc3out(number(str(param1)), number(str(param2)), number(str(param3)), number(str(param4)), number(str(param5)), number(str(param6)), number(str(param7))));
    //circleOut.addChild(object.arc3in(number(param1), number(param2), number(param3), number(param4), number(param5), number(param6), number(param7)));
    popStyle();
  }
  object.whatHeppens += "arc3out(" + number(str(param1)) + "," + number(str(param2)) + "," + number(str(param3)) + "," + number(str(param4)) + "," + number(str(param5)) + "," + number(str(param6)) + "," + number(str(param7)) + ");";
  object.value = object.whatHeppens;
}

void drawRect(float param1, float param2, float param3, float param4) {
  if (object.canDraw) {
    //win.r(number(param1), number(param2), number(param3), number(param4));
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(createShape(RECT, number(str(param1)), number(str(param2)), number(str(param3)), number(str(param4))));
    popStyle();
  }
  object.whatHeppens += "rect(" + number(str(param1)) + "," + number(str(param2)) + "," + number(str(param3)) + "," + number(str(param4)) + ");";
  object.value = object.whatHeppens;
}

void drawCircle(float param1, float param2, float param3) {
  if (object.canDraw) {
    //win.e(number(param1), number(param2), number(param3));
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(createShape(ELLIPSE, number(str(param1)), number(str(param2)), number(str(param3)), number(str(param3))));
    popStyle();
  }
  object.whatHeppens += "circle(" + number(str(param1)) + "," + number(str(param2)) + "," + number(str(param3)) + "," + number(str(param3)) + ");";
  object.value = object.whatHeppens;
}

void drawLine(float param1, float param2, float param3, float param4) {
  if (object.canDraw) {
    //win.e(number(param1), number(param2), number(param3));
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(createShape(LINE, number(str(param1)), number(str(param2)), number(str(param3)), number(str(param4))));
    popStyle();
  }
  object.whatHeppens += "line(" + number(str(param1)) + "," + number(str(param2)) + "," + number(str(param3)) + "," + number(str(param4)) + ");";
  object.value = object.whatHeppens;
}

void drawPoint(float param1, float param2) {
  if (object.canDraw) {
    //win.e(number(param1), number(param2), number(param3));
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(createShape(POINT, number(str(param1)), number(str(param2))));
    popStyle();
  }
  object.whatHeppens += "point(" + number(str(param1)) + "," + number(str(param2)) + ");";
  object.value = object.whatHeppens;
}

void drawEllipse(float param1, float param2, float param3, float param4) {
  if (object.canDraw) {
    //win.e(number(param1), number(param2), number(param3));
    pushStyle();
    noFill();
    stroke(0);
    globalOutput.addChild(createShape(ELLIPSE, number(str(param1)), number(str(param2)), number(str(param3)), number(str(param4))));
    popStyle();
  }
  object.whatHeppens += "ellipse(" + number(str(param1)) + "," + number(str(param2)) + "," + number(str(param3)) + "," + number(str(param4)) + ");";
  object.value = object.whatHeppens;
}

void makeMatrix(int param1, int param2, float param3, String param4) {
  int xraw = int(number(str(param1)));
  int yraw = int(number(str(param2)));
  float step = int(number(str(param3)));
  int indexOf;
  int target = -1;

  int i = 0;
  for (String curr : pairs.values()) {
    if (curr != null && object.index == int(split(curr, "|")[0])) {
      target = int(split(curr, "|")[1]);
    }
    i++;
  }

  if (param4.equals("NaN")) {
    indexOf = target;
  } else {
    indexOf = int(number(param4));
  }
  object.input4 = str(indexOf);

  if (indexOf != -1) {
    globalOutput.addChild(line.get(indexOf).matrix(xraw, yraw, step));
   
  }
}


void makeCircleMatrix(float param1, float param2, String param3) {
  int r = int(number(str(param1)));
  float step = int(number(str(param2)));
  int indexOf;
  int target = -1;
  int i = 0;
  for (String curr : pairs.values()) {
    if (curr != null && object.index == int(split(curr, "|")[0])) {
      target = int(split(curr, "|")[1]);
    }
    i++;
  }

  if (param3.equals("NaN")) {
    indexOf = target;
  } else {
    indexOf = int(number(param3));
  }
  object.input3 = str(indexOf);

  if (indexOf > -1 && indexOf < line.size() && step > 0) {
    line.get(indexOf).canDraw = false;
    globalOutput.addChild(line.get(indexOf).circleMatrix(r, step));
  }
}

void generateGear(float param1, float param2, float param3, float param4, float param5, float param6, float param7) { //good result: x,y, 3 180 130 60 30

  float x = number(str(param1));
  float y = number(str(param2));
  float notches = number(str(param3));
  float radiusO = number(str(param4));
  float radiusI = number(str(param5));
  float taperO = number(str(param6));
  float taperI = number(str(param7));

  PShape out = createShape(GROUP);
  float pi2 = TWO_PI, 
    angle = pi2 / (notches * 2), // угол между зубами
    taperAI = angle * taperI * 0.005, // внутренний радиус
    taperAO = angle * taperO * 0.005, // внешний радиус
    a = angle;  // просто так

  boolean toggle = false;
  float px = x + radiusO * cos(taperAO);
  float py = x + radiusO * sin(taperAO);
  pushStyle();
  stroke(0);

  for (; a <= pi2+1; a += angle) {
    // draw inner part
    if (toggle) {
      out.addChild(createShape(LINE, px, py, x + radiusI * cos(a - taperAI), y + radiusI * sin(a - taperAI)));
      object.value += "line(" + px + "," + py  + "," +  (x + radiusI * cos(a - taperAI)) + "," + (y + radiusI * sin(a - taperAI)) + ");";
      px = x + radiusI * cos(a - taperAI);
      py = y + radiusI * sin(a - taperAI);
      out.addChild(createShape(LINE, px, py, x + radiusO * cos(a + taperAO), y + radiusO * sin(a + taperAO)));
      object.value += "line(" + px + "," + py + "," + (x + radiusO * cos(a + taperAO)) + "," + (y + radiusO * sin(a + taperAO)) + ");";
      px = x + radiusO * cos(a + taperAO);
      py = y + radiusO * sin(a + taperAO);
    }

    // draw outer part
    else {
      out.addChild(createShape(LINE, px, py, x + radiusO * cos(a - taperAO), y + radiusO * sin(a - taperAO)));
      object.value += "line(" + px + "," + py + "," + (x + radiusO * cos(a - taperAO)) + "," + (y + radiusO * sin(a - taperAO)) + ");";
      px = x + radiusO * cos(a - taperAO);
      py = y + radiusO * sin(a - taperAO);
      out.addChild(createShape(LINE, px, py, x + radiusI * cos(a + taperAI), y + radiusI * sin(a + taperAI)));
      object.value += "line(" + px + "," + py + "," + (x + radiusI * cos(a + taperAI)) + "," + (y + radiusI * sin(a + taperAI)) + ");";
      px = x + radiusI * cos(a + taperAI);
      py = y + radiusI * sin(a + taperAI);
    }

    toggle = !toggle;
  }
  popStyle();
  globalOutput.addChild(out);
}

String otherParams(String[] params) {
  String out = "";
  for (int i = 2; i < params.length; i++) {
    out += params[i]+ (i+1==params.length? ";" : ",");
  }
  return out;
}
void showValue(String param4) {
  int indexOf = -1;
  int target = -1;
  for (String curr : pairs.values()) {
    if (curr != null && object.index == int(split(curr, "|")[0])) {
      target = int(split(curr, "|")[1]);
    }
  }

  if (param4.equals("NaN")) {
    indexOf = target;
    param4 = str(target);
  } else {
    indexOf = int(number(param4));
  }
  if (indexOf != -1) {
    println(line.get(indexOf).value);
  }
}

float number(String a) {
  return (float)calc(repl(a));
}



/*                                                    Функции                                                    */