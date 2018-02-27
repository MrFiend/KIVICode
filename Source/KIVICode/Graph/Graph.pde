import static javax.swing.JOptionPane.*; //<>//
import http.requests.*;
import processing.net.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.event.ItemListener;
import java.awt.event.ItemEvent;
import java.awt.CheckboxMenuItem;
import java.awt.MenuBar;
import java.awt.Menu;
import processing.awt.PSurfaceAWT;
import processing.svg.*;
import processing.pdf.*;
import processing.dxf.*;
import g4p_controls.*;
import garciadelcastillo.dashedlines.*;
import at.mukprojects.console.*;
import static javax.swing.JOptionPane.*;
import g4p_controls.*;
import java.util.*;
import controlP5.*;
import drop.*;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.*;
import geomerative.*;


SDrop drop;
Client c;
PWindow win;
VectorEditor vector;
EditorNode edit;
MenuBar myMenu, saveMenu;
Menu fileMenu, editMenu, exportMenu, runMenu, fileMenuSave, VectorMenu, PasteMenu;
MenuItem fileLoad, fileSave, fileSaveAs, exportSVG, exportPNG, exportDXF, exportPDF, exportGCode, machineRun, goHome, openEditor, saveFile, newNode, openVectorMenu;
myMenuListener menuListen;
ControlP5 cp5;
ScriptEngine engine;
ScriptEngineManager factory;

/*        Vector Editor   */
Console console;
/*        Vector Editor   */

PGraphics icon;

ArrayList<Line> line = new ArrayList<Line>();
StringDict pairs = new StringDict();
PGraphics svgSHAPE;
PShape globalOutput;
//PShape circleOut;

int index;
int pin = 6496;
int numberOfinput;
int id = 1;

float traceY;

Line object;
String matrixBonus;

boolean dragOrTrace = false;
boolean globalOutputB = false;

String ip = "localhost:9000";
String sketchPath = sketchPath("");
boolean loading = false;
int j = 0;

String stick = "\\";
PImage ico;

/*        Vector Editor   */
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Point> points = new ArrayList<Point>();
IntList selPoints = new IntList();
int pointDrag = -1;
int currShape = 0;
boolean anyPointsSelected = false;
boolean cursor = false;
boolean redscreen = false;

/*        Vector Editor   */


/*        Export svg -> gcode  */
RShape grp;
RPoint[][] pointPaths;

String penUp= "M03 S0 \n";
String penDown = "M03 S20 \n";
float[] xcoord = {0, 0};
float[] ycoord = {0, 0};
String gcodecommand ="G0 F16000\nG0"+ penUp; 

float xmag, ymag, newYmag, newXmag = 0;
float z = 0;

boolean ignoringStyles = false;
boolean first_line = true;
int filesaved = 0;

PGraphics svgOut;
/*        Export svg -> gcode  */

CWindow debug;
void setup() {  
  ico = loadImage("data/icon.png");
  surface.setIcon(ico);
  String OS = System.getProperty("os.name").toLowerCase(); 
  println(OS);
  if (OS.equals("mac os x")) {
    stick = "/";
  } else if (OS.equals("windows")) {
    stick = "\"";
  }
  println(stick);
  fill(21);
  rect(0, 0, width, height);
  textAlign(CENTER);
  text("Loading...", width/2, height/2);

   String pin2 = showInputDialog("Enter computer's PIN");
   pin = (int(pin2));
  if (pin2 != "") {
  c = new Client(this, "127.0.0.1", 6496);
   }

  surface.setResizable(true);
  background(21);
  win = new PWindow();
  edit = new EditorNode(dataPath("CustomNodes"));
  vector = new VectorEditor();

  surface.setTitle("Graph " + frameRate);

  menu_setup();

  surface.setLocation(0, 0);

  line.add(new Line(0, 0, 2, ""));
  line.remove(0);
  id--;

  textAlign(LEFT);

  edit.setVis(false);
  vector.setVis(false);
  drop = new SDrop(this);

  factory = new ScriptEngineManager();
  engine = factory.getEngineByName("JavaScript");
  engine.put("es", this);

  globalOutput = createShape(GROUP);
  console = new Console(this);
  debug = new CWindow();
  //circleOut = createShape(GROUP);
  frameRate(60);
}

void settings() {
  size(640, 480);
}

boolean g = true;
void draw() {
  surface.setIcon(ico);
  update();
  if (dragOrTrace) {
    stroke(#FA8A00);
    strokeWeight(5);
    noFill();
    drawSpline(line.get(index).x+5, traceY, mouseX-transX, mouseY-transY);
  }
  surface.setTitle("Graph " + int(frameRate));
}

void mouseMoved() {
  println(stick);
}

void exit() {
  win.exit();
  edit.exit();
  vector.exit();
  this.exit();
}

void update() {
  background(21);
  translate(transX, transY);
  frameRate(1200);
  FR = frameRate;
  drawGrid();
  redscreen = false;
  globalOutput = createShape(GROUP);
  try {
    for (Line c : line) {
      object = c;
      c.update();
      if (c.type == -1) {
        c.value = "";
        c.whatHeppens = "";
        File dir = new File(dataPath("CustomNodes") + stick + c.cnName + ".txt");
        String[] splt = loadStrings(dir);
        eval(toArr(splt, "\n"));
        c.value = c.index + "|" + c.value;
        c.whatHeppens = c.value;
        //shape(globalOutput);
      }
    }
    redscreen = true;

    trace();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

String toArr(String[] in, String sep ) {
  String rt = "";
  for (String i : in) {
    rt += i+sep;
  }
  return rt;
}

float FR = frameRate;
void drawGrid() {
  stroke(80);
  strokeWeight(1);
  for (float i = -1*(width/3); i < (width); i += 25) {
    for (float j = -1*(height/3); j < height; j += 25) {
      point(i, j);
    }
  }
}

String repl(String frm) {
  String out = frm;
  for (int i = 0; i < object.names.size(); i++) {
    if (out.indexOf(object.names.keyArray()[i]) != -1) {
      out = out.replace(object.names.keyArray()[i], str(object.getInput(int(object.names.get(object.names.keyArray()[i])))));
    }
  }
  return out;
}

boolean isNum(String in) {
  if (in.charAt(0) >=48 && in.charAt(0) <= 57) {
    return true;
  }

  return false;
}

String params(String[] in) {
  String out = "(";
  int i = 0;
  for (String c : in) {
    out += c;
    if (i+1 == in.length) {
      out += ");";
    } else {
      out += ",";
    }
    i++;
  }

  return out;
}

void eval(String str) {
  try {
    String data[] = split(str, "\n");
    int j = 0;
    for (String i : data) {
      if (!(i.startsWith("for") || i.startsWith("if") || i.startsWith("while") || i.equals("}") || i.equals("{"))) {
        if (!data[j].equals("")) {
          String cmd = split(data[j], "(")[0];
          if (!(cmd.equals("addInput") || cmd.equals("setTitle"))) {
            data[j] = "es."+cmd+"("+repl(split(split(data[j], "(")[1], ")")[0])+");";
          } else {
            data[j] = "es."+data[j]+";";
          }
        }
      }
      j++;
    }
    engine.eval(join(data, ""));
  }
  catch (ScriptException e) {
    e.printStackTrace();
  }
}

void say(String data) {
  System.out.println(data);
}

int last;
void mouseClicked() {
  if (mouseEvent.getClickCount() == 2) doubleClicked();
}

void doubleClicked() {

  for (Line curr : line) {
    println(dist(curr.x+5, curr.in2+5, mouseX-transX, mouseY-transY));
    if (dist(curr.x+5, curr.in1+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 1-st input"));
      if (currr != null) {
        curr.input1 = currr;
      }
    } else if (dist(curr.x+5, curr.in2+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 2-st input"));
      if (currr != null) {
        curr.input2 = currr;
      }
    } else if (dist(curr.x+5, curr.in3+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 3-rd input"));
      if (currr != null) {
        curr.input3 = currr;
      }
    } else if (dist(curr.x+5, curr.in4+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 4-th input"));
      if (currr != null) {
        curr.input4 = currr;
      }
    } else if (dist(curr.x+5, curr.in5+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 5-th input"));
      if (currr != null) {
        curr.input5 = currr;
      }
    } else if (dist(curr.x+5, curr.in6+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 6-th input"));
      if (currr != null) {
        curr.input6 = currr;
      }
    } else if (dist(curr.x+5, curr.in7+5, mouseX-transX, mouseY-transY) < 5) {
      String currr = (showInputDialog("Enter new value for 7-th input"));
      if (currr != null) {
        curr.input7 = currr;
      }
    }
  }
}


boolean isOnLine(float x, float y, float x1, float y1, float x2, float y2) {
  if ((dist(x1, y1, x2, y2) + dist(x, y, x2, y2) > dist(x1, y1, x, y)-10) && (dist(x1, y1, x2, y2) + dist(x, y, x2, y2) < dist(x1, y1, x, y)+10) ) {
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
void trace() {
  for (String curr : pairs.values()) {
    stroke(#FA8A00);
    strokeWeight(5);
    if (curr != null) {
      switch(split(curr, "|")[2]) {
      case "1":
        drawSpline(line.get(int(split(curr, "|")[0])).x+5, line.get(int(split(curr, "|")[0])).in1+5, line.get(int(split(curr, "|")[1])).out, line.get(int(split(curr, "|")[1])).in1+5);
        break;

      case "2":
        drawSpline(line.get(int(split(curr, "|")[0])).x+5, line.get(int(split(curr, "|")[0])).in2+5, line.get(int(split(curr, "|")[1])).out, line.get(int(split(curr, "|")[1])).in1+5);
        break;

      case "3":
        drawSpline(line.get(int(split(curr, "|")[0])).x+5, line.get(int(split(curr, "|")[0])).in3+5, line.get(int(split(curr, "|")[1])).out, line.get(int(split(curr, "|")[1])).in1+5);
        break;

      case "4":
        drawSpline(line.get(int(split(curr, "|")[0])).x+5, line.get(int(split(curr, "|")[0])).in4+5, line.get(int(split(curr, "|")[1])).out, line.get(int(split(curr, "|")[1])).in1+5);
        break;

      case "5":
        drawSpline(line.get(int(split(curr, "|")[0])).x+5, line.get(int(split(curr, "|")[0])).in5+5, line.get(int(split(curr, "|")[1])).out, line.get(int(split(curr, "|")[1])).in1+5);
        break;
      }
    }
  }
}

void drawSpline(float x1, float y1, float x2, float y2)
{
  int delta = 100;
  pushStyle();
  noFill();
  bezier(x1, y1, x1 - delta, y1, x2 + delta, y2, x2, y2);
  popStyle();
}

void dropEvent(DropEvent theDropEvent) {
  File importFile = theDropEvent.file();
  if (!importFile.isFile()) {
    showMessageDialog(frame, "Sorry, I cant't open a directory, only files");
  } else if (!importFile.getPath().endsWith(".kivi") && !importFile.getPath().endsWith(".txt")) {
    showMessageDialog(frame, "Sorry, I can open only \".kivi\" files");
  } else if (importFile.getPath().endsWith(".kivi")) {
    boolean normal = true;
    try {
      Load(importFile);
    }
    catch(Exception e) {
      normal = false;
      showMessageDialog(frame, "Sorry, I have an error:\n" + e.getStackTrace());
    }
    if (normal) {
      showMessageDialog(frame, "Successed!");
    }
  } else if (importFile.getPath().endsWith(".txt")) {
    line.add(new Line(mouseX-transX, mouseY-transY, -1, 0, split(importFile.getName(), ".")[0]));
    line.get(id).index = id;
    id++;
  }
}

void exportDXF(File in) {
  String out = "";
  println("Entery");
  for (Line l : line) {
    for (String c : split(l.whatHeppens, ";")) {
      println(c);
      if (split(c, "|").length > 1) {
        out += split(c, "|")[1]+";";
      } else {
        out += c;
      }
    }
  }
  println(split(in.getPath(), ".").length-2 < 0 ? 0 : split(in.getPath(), ".").length-2);
  String[] par = {"python", sketchPath("")+"data/main.py", "\""+out+"\"", in.getName(), split(in.getPath(), ".")[split(in.getPath(), ".").length-2 < 0 ? 0 : split(in.getPath(), ".").length-2]+".dxf"};
  exec(par);
  printArray(par);
  // String[] move = {"mv","~/"}
}

String Export = "";
String formatExport = "";
File expF;
void export(int type) {
}

void exportGCode(File in) {
  println("Start export gcode");
  String fileName = in.getName();
  PGraphics out; 
  int w = int(globalOutput.width);
  int h = int(globalOutput.height);
  out = createGraphics(w, h, SVG, fileName + ".svg");
  out.beginDraw();
  out.shape(globalOutput);
  out.dispose();
  out.endDraw();
  exportSVG2Gcode(in);
}

void exportSVG(File in) {
  println("Start export svg");
  PGraphics out; 
  out = createGraphics(640, 480, SVG, in.getPath() + ".svg");
  out.beginDraw();
  out.background(255);
  out.shape(globalOutput);
  out.endDraw();
  out.dispose();
}

void exportPNG(File in) {
  println("Start export svg");
  PGraphics out; 
  out = createGraphics(640, 480);
  out.beginDraw();
  out.background(255);
  out.shape(globalOutput);
  out.endDraw();
  //out.dispose();
  saveFrame("bigBang.jpg");
}

void exportPDF(File in) {
  println("Start export svg");
  PGraphics pdf; 
  pdf = createGraphics(640, 480, PDF, in.getPath() + ".pdf");
  pdf.beginDraw();
  pdf.background(255);
  for (int i = 0; i < globalOutput.getChildCount(); i++) {
    PShape a = globalOutput.getChild(i);
    pdf.shape(a);
  }
  pdf.dispose();
  pdf.endDraw();
}

void exportSVG2Gcode(File file) {
  String fileName = file.getName();

  RG.init(this);
  RG.ignoreStyles(ignoringStyles);

  RG.setPolygonizer(RG.ADAPTATIVE);
  grp = RG.loadShape(fileName +".svg");
  //grp.centerIn(false, 100, 1, 1);

  pointPaths = grp.getPointsInPaths();


  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/float(height) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0;
  }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0;
  }

  float a = 0, b = 0;

  for (int i = 0; i<pointPaths.length; i++) {
    if (pointPaths[i] != null) {
      //beginShape();
      for (int j = 0; j<pointPaths[i].length; j++) {
        //vertex(pointPaths[i][j].x, pointPaths[i][j].y);

        float xmaped = map(pointPaths[i][j].x, -200, 200, xcoord[1], xcoord[0]);
        float ymaped = map(pointPaths[i][j].y, -200, 200, ycoord[0], ycoord[1]);

        if (first_line== true) {
          gcodecommand = gcodecommand + "G0 X"+ str((xmaped-a))+" Y"+str(ymaped-b) +" \n"; 
          first_line = false;
        } else {
          gcodecommand = gcodecommand + "G1 X"+ str((xmaped-a))+" Y"+str(ymaped-b) +" \n";
        }
      }
      //endShape();
    }
    gcodecommand = gcodecommand + penUp;

    if (i == pointPaths.length-1) {
      String[] gcodecommandlist = split(gcodecommand, '\n');
      println(file.getPath() + fileName+".txt");
      saveStrings(file.getPath()+".txt", gcodecommandlist); 
      filesaved = 1;

      //exit();
    }
  }
}

String GLine(String fx, String fy, String tx, String ty) {
  String out = "G00 X"+fx+" Y"+fy+"\nG01 X"+tx+" Y"+ty+"\n";
  return out;
}

String GRect(String x, String y, String w, String h) {
  String out = GLine(x, y, str(float(x)+float(w)), y)+GLine(str(float(x)+float(w)), y, str(float(x)+float(w)), str(float(y)+float(h)))+GLine(str(float(x)+float(w)), str(float(y)+float(h)), x, str(float(y)+float(h)))+GLine(x, str(float(y)+float(h)), x, y);
  return out;
}
void keyPressed() {
  if (select && (key == DELETE || key == BACKSPACE) && index >= pairs.size()-1 && index >= line.size()-1) {
    line.remove(index);
    int i = 0;
    boolean del = false;
    for (String curr : pairs.values()) {
      if (curr != null && index == int(split(curr, "|")[0])) {
        pairs.remove(str(i));
        //  del = true;
      } 
      if (curr != null && index == int(split(curr, "|")[1])) {
        pairs.remove(split(curr, "|")[0]);
        pairs.remove(str(index));
        del = true;
      }
      i++;
    }
    for (int j = index; j < line.size(); j++) {
      line.get(j).index--;
    }
    index = -1;
    id = id<=0? 0 : id-1;
    select = false;
  } else if (key == '1') {
    line.add(new Line(mouseX-transX, mouseY-transY, -1, 0, "Line"));
    line.get(id).index = id;
    id++;
  } else if (key == '0') {
    String type = showInputDialog("Enter value");
    println(type);
    if (type != null) {
      line.add(new Line(mouseX-transX, mouseY-transY, 0, float(type), false));
      line.get(id).index = id;
      id++;
    }
  } else if (key == '2') {
    float val = float(int(random(0, 300)));
    line.add(new Line(mouseX-transX, mouseY-transY, -1, val, "Rect"));
    println(line.size());
    line.get(id).index = id;
    id++;
  } else if (key == '3') {
    float val = float(int(random(0, 300)));
    line.add(new Line(mouseX-transX, mouseY-transY, -1, val, "Ellipse"));
    line.get(id).index = id;
    id++;
  } else if (key == '4') {
    float val = float(int(random(0, 300)));
    String type = showInputDialog("Enter name of custom node");
    if (type != null && isFileNode(type)) {
      line.add(new Line(mouseX-transX, mouseY-transY, -1, val, type));
      line.get(id).index = id;
      id++;
    }
  } else if (key == '5') {
    line.add(new Line(mouseX-transX, mouseY-transY, -2, ""));
    line.get(id).index = id;
    id++;
  } else if (key == '6') {
    line.add(new Line(mouseX-transX, mouseY-transY, -3, ""));
    line.get(id).index = id;
    id++;
  } else if (key == 'r' ) {
    String speed = showInputDialog("Enter speed");
    String power = showInputDialog("Enter power (in %)");
    String type = showInputDialog("Enter type of machine\n1-laser 2-milling 3-3D printer");
    if (speed != null && power != null && type != null) {
      run(float(speed), float(power), int(type));
    }
  } else if (key == 's') {
    selectOutput("Save file:", "Save");
  } else if (key == 'l') {
    selectInput("Select a file to open:", "Load");
    return;
  } else {
    
    c = new Client(this, "127.0.0.1", int(showInputDialog("Enter new pin")));
  }
}

File sel;

void Save(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    saveFunction(selection);
  }
}

void Load(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    LoadFileName = selection.getAbsolutePath();
    line = null;
    line = new ArrayList();
    int startPairs = 0;
    int k = 0;
    JSONArray values = loadJSONArray(LoadFileName);
    for (int i = 0; i < values.size(); i++) {
      JSONObject lines = values.getJSONObject(i);
      if (lines.getBoolean("isNode") && lines.isNull("Pen")) {
        line.add(new Line());
        line.get(i).index = lines.getInt("id");
        line.get(i).x = lines.getFloat("x");
        line.get(i).y = lines.getFloat("y");
        line.get(i).type = lines.getInt("type");
        line.get(i).index = lines.getInt("id");
        line.get(i).cnName = lines.getString("name");
        line.get(i).value = lines.getString("value");
        line.get(i).whatHeppens = lines.getString("whatHeppens");
        line.get(i).input1 = lines.getString("input1");
        line.get(i).input2 = lines.getString("input2");
        line.get(i).input3 = lines.getString("input3");
        line.get(i).input4 = lines.getString("input4");
        line.get(i).input5 = lines.getString("input5");
        line.get(i).input6 = lines.getString("input6");
        line.get(i).input7 = lines.getString("input7");
        startPairs++;
      } else if (lines.getBoolean("isVector")) {
        shapes.get(k).pointCountM = lines.getInt("pointCountM");
        shapes.get(k).pointN = lines.getInt("pointN");

        for (int i_ = 0; i_ < lines.getInt("pointsC_size"); i_++) {
          shapes.get(k).pointsC.set(i_, lines.getInt("pointC_"+i_));
        }
        shapes.get(k).closed = lines.getBoolean("closed");
        shapes.get(k).added = lines.getBoolean("added");
        shapes.get(k).isEllipse = lines.getBoolean("isEllipse");
        k++;
      }
    }


    pairs = null;
    pairs = new StringDict();
    for (int i = startPairs; i < values.size(); i++) {
      JSONObject lines = values.getJSONObject(i);
      pairs.set(lines.getString("name"), lines.getString("data"));
    }
  }
}


static final void removeExitEvent(final PSurface surf) {
  final java.awt.Window win
    = ((processing.awt.PSurfaceAWT.SmoothCanvas) surf.getNative()).getFrame();

  for (final java.awt.event.WindowListener evt : win.getWindowListeners())
    win.removeWindowListener(evt);
}

void saveFunction(File selection) {
  if (sel == null) {
    sel = selection;
  }
  SaveFileName = split(sel.getPath(), ".")[0];


  JSONArray values = new JSONArray();
  int j = 0;
  int k = 0;
  int l = 0;
  for (int i = 0; i < line.size()+pairs.size()+shapes.size()+points.size(); i++) {

    JSONObject lines = new JSONObject();
    if (i < line.size()) {
      lines.setInt("id", i);
      lines.setBoolean("isNode", true);
      lines.setBoolean("isVector", false);
      lines.setFloat("x", line.get(i).x);
      lines.setFloat("y", line.get(i).y);
      lines.setInt("type", line.get(i).type);
      lines.setString("name", line.get(i).cnName);
      lines.setString("value", line.get(i).value);
      lines.setString("whatHeppens", line.get(i).whatHeppens);
      lines.setString("input1", line.get(i).input1);
      lines.setString("input2", line.get(i).input2);
      lines.setString("input3", line.get(i).input3);
      lines.setString("input4", line.get(i).input4);
      lines.setString("input5", line.get(i).input5);
      lines.setString("input6", line.get(i).input6);
      lines.setString("input7", line.get(i).input7);
    } else if (i-line.size() < pairs.size()) {
      lines.setBoolean("isNode", false);
      lines.setString("name", str(j));
      lines.setString("data", pairs.get(str(j)));
      lines.setBoolean("isVector", false);
      j++;
    } else if (i-line.size()-pairs.size() < shapes.size()) {
      println(k);
      lines.setBoolean("isNode", false);
      lines.setBoolean("isVector", true);
      lines.setInt("pointCountM", shapes.get(k).pointCountM);
      lines.setInt("pointN", shapes.get(k).pointN);
      lines.setInt("pointC_size", shapes.get(k).pointsC.size());
      for (int i_ = 0; i_ < shapes.get(k).pointsC.size(); i_++) {
        lines.setInt("pointC_"+i_, shapes.get(k).pointsC.get(i_));
      }
      lines.setBoolean("closed", shapes.get(k).closed);
      lines.setBoolean("added", shapes.get(k).added);
      lines.setBoolean("isEllipse", shapes.get(k).isEllipse);
      k++;
    } else {
      lines.setBoolean("isNode", false);
      lines.setBoolean("isVector", true);
      lines.setBoolean("isPoint", true);
      
      lines.setFloat("x", points.get(k).x);
      lines.setFloat("y", points.get(k).y);
      
      lines.setFloat("px", points.get(k).px);
      lines.setFloat("py", points.get(k).py);
      
      lines.setBoolean("selected", points.get(l).selected); 
      lines.setBoolean("isCenterOfCircle", points.get(l).isCenterOfCircle);
      
      lines.setInt("index", points.get(l).index);
      lines.setInt("pairIndex", points.get(l).pairIndex);
      
      lines.setInt("vert_size", points.get(l).vert.size());
      lines.setInt("horiz_size", points.get(l).horiz.size());
      lines.setInt("equals_size", points.get(l).equals.size());
      lines.setInt("lengthTo_size", points.get(l).lengthTo.size());
      
      for (int i_ = 0; i_ < points.get(l).vert.size(); i_++) {
        lines.setInt("vert_"+i_, points.get(l).vert.get(i_));
      }
      
      for (int i_ = 0; i_ < points.get(l).horiz.size(); i_++) {
        lines.setInt("horiz_"+i_, points.get(l).horiz.get(i_));
      }
      
      for (int i_ = 0; i_ < points.get(l).equals.size(); i_++) {
        lines.setInt("equals_"+i_, points.get(l).equals.get(i_));
      }
      
      for (int i_ = 0; i_ < points.get(l).lengthTo.size(); i_++) {
        lines.setString("lengthTo_"+i_, points.get(l).lengthTo.get(i_));
      }
      
      l++;
    }
    values.setJSONObject(i, lines); 
    println(i);
  }
  JSONObject pen = new JSONObject(); 
  pen.setBoolean("Pen", true); 
  pen.setString("Data", win.data); 
  pen.setBoolean("isNode", false); 
  values.setJSONObject(line.size()+pairs.size(), pen); 
  SaveFileName+=".kivi"; 
  println(SaveFileName); 
  saveJSONArray(values, SaveFileName); 
  println(sketchPath()+"/data/Icon_file.png"); 
  String[] cd = {"cd", sketchPath()}; 
  exec(cd); 
  String[] args = {"sh", "changeIcon.sh", "", SaveFileName, sketchPath()+"/data/Icon_file.png"}; 
  exec(args); 
  SaveFileName = "";
}

boolean select = false; 
boolean selectLine = false; 
IntList selectedNodes = new IntList(); 
String SaveFileName = ""; 
String LoadFileName = ""; 
String[] LoadedFile; 

void mousePressed() {
  int i = 0; 
  pMX = mouseX; 
  pMY = mouseY; 
  boolean brek = false; 
  if (!brek) {
    for (Line curr : line) {
      if (dist(curr.x+5, curr.in1+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 1; 
        traceY = curr.in1+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+5, curr.in2+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 2; 
        traceY = curr.in2+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+5, curr.in3+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 3; 
        traceY = curr.in3+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+5, curr.in4+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 4; 
        traceY = curr.in4+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+5, curr.in5+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 5; 
        traceY = curr.in5+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+5, curr.in6+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 6; 
        traceY = curr.in6+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+5, curr.in7+5, mouseX-transX, mouseY-transY) < 5) {
        index = i; 
        numberOfinput = 7; 
        traceY = curr.in7+5; 
        dragOrTrace = true;
      } else if (dist(curr.x+55, curr.y+15, mouseX-transX, mouseY-transY) < 45) {
        index = i; 
        select = true; 
        dragOrTrace = false; 
        if (curr.select) {
          curr.select = false;
        } else {
          curr.select = true;
        }
      } else if (dist(curr.x+55, curr.y+55, mouseX-transX, mouseY-transY) < 55) {
        index = i; 
        dragOrTrace = false;
      } else {
        select = false; 
        curr.select = false;
      }
      i++;
    }
  }
}


float transX = 0, transY = 0; 
float pMX = mouseX, pMY = mouseY; 
void mouseDragged() {
  if (mouseButton == LEFT) {
    if (dragOrTrace) {
      stroke(#FA8A00); 
      strokeWeight(5);
    } else if (index < line.size()) {
      line.get(index).x = mouseX-transX; 
      line.get(index).y = mouseY-transY;
    }
  }

  if (mouseButton == RIGHT) {
    for (Line l : line) {
      if (!onRect(mouseX-transX, mouseY-transY, l.x, l.y, 150, 110) && !select) {
        if (mouseX > pMX) {
          transX+=mouseX-pMX; 
          pMX = mouseX; 
          //println("move Right");
        } else if (mouseX < pMX) {
          transX-=pMX-mouseX; 
          pMX = mouseX; 
          //println("move Left");
        }

        if (mouseY > pMY) {
          transY+=mouseY-pMY; 
          pMY = mouseY; 
          //println("move Right");
        } else if (mouseY < pMY) {
          transY-=pMY-mouseY; 
          pMY = mouseY; 
          //println("move Left");
        }
        println(transX, transY);
      }
    }
  }
}


void mouseReleased() {
  int i = 0; 
  for (Line curr : line) {
    if (dragOrTrace && dist(curr.out, curr.in1, mouseX-transX, mouseY-transY) < 15) {
      pairs.set(str(i), index+"|"+i+"|"+numberOfinput); 
      if (line.get(index).type != 0) {
        switch(numberOfinput) {
        case 1 : 
          line.get(index).input1 = curr.value; 
          break; 

        case 2 : 
          line.get(index).input2 = curr.value; 
          break; 

        case 3 : 
          line.get(index).input3 = curr.value; 
          break; 

        case 4 : 
          line.get(index).input4 = curr.value; 
          break; 

        case 5 : 
          line.get(index).input5 = curr.value; 
          break;
        }
      }
    }
    i++;
  }
  dragOrTrace = false;
}


void run(float speed, float power, int type) {
  c = new Client(this, "127.0.0.1", pin); 
  String out = ""; 
  for (Line l : line) {
    if (l.canDraw) {
      out += l.value; 
      println(l.value, l.whatHeppens);
    }
  }

  //+ "[[" + speed + "]]" + "[" + power + "]" + "[[["+str(type) + "]]]"
  c.write(out + win.data + "[" + speed + "," + power + "," + type + "]"); 
  println(out + "[" + speed + "," + power + "," + type + "]");
}