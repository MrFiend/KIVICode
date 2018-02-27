import processing.serial.*;
import static javax.swing.JOptionPane.*;
import geomerative.*;
import processing.svg.*;
import processing.net.*;
import peasy.*;

PeasyCam cam;
Server s; 
Client c;

Serial myPort;
RShape grp;
RPoint[][] pointPaths;

PrintWriter output;

int ip = 0000;
String programm = "Alert";
int lf = 10;
boolean sell = true;
String myString = null;
String outX;
String outY;
String path;

ArrayList<PVector> vectors = new ArrayList<PVector>();
int[] UVNums = new int[10000];
PVector currPoint = new PVector(0, 0);

int cnt = 0;
int o = 1;
int k = 0;

float[] xcoord = { -108, -195};// These variables define the minimum and maximum position of each axis for your output GCode 
float[] ycoord = { -108, -195};// These settings also change between your configuration
String fileName;



String gcodecommand = ""; // String to store the Gcode we wil save later

float xmag, ymag, newYmag, newXmag = 0;
float z = 0;

boolean ignoringStyles = false;
boolean first_line = true;
boolean save = false;
boolean last = false;

int filesaved = 0;

String COMx, COMlist = "";

float DEEP = 7;

void keyPressed() {
  //getPower("{50}[65]/Laser|");
}


int rX = 0;
int rY = 0;
int rZ = 0;

PShape out;

void setup() {
  size(640, 480, P3D);
  out = createShape(GROUP);
  ip = int(random(1000, 9999));
  s = new Server(this, ip);
  showMessageDialog(frame, "My PIN is " + ip);

  cam = new PeasyCam(this, 100);


  currPoint = new PVector(0, 0, 0);
  background(127);
  o = 0;
  vectors.clear();
  fill(255, 70);

  cnt = 0;
  // drawMe(inputData);
  outp =  createShape(GROUP);
  //saveString("GCode", gcodeOutput, "\n");
}

//void saveString(String name, String in, String del) {
//  StringList out = new StringList();
//  for (String i : split(in, del)) {
//    out.append(i+del);
//  }
//  saveStrings(name,out.array());
//}

String input;
int data[];
int q = 0;

boolean point = false;
boolean a = true;


String gcodeOutput = "";
int p = 0;
PShape outp;
boolean started = false, finished = false;
void draw() {

  background(0);
  //shape(out);
  //rotateZ(radians(mouseY));

  c = s.available();
  c = s.available();

  if (c != null) {
    String input = c.readString();
    println(input);
    DEEP = float(showInputDialog("Enter deep value of drawing"));
    drawMe(split(input, "[")[0]);
    started = true;
  }
  if (started && !finished) {
    if (p  < vectors.size()-1) {
      PVector v = vectors.get(p);
      PVector pv = vectors.get(p+1);
      if (isIn(UVNums, p)) {
        stroke(255, 0, 0);
        gcodeOutput += "G0 X" + v.x + " Y" + v.y + " Z" + v.z + "\n";
        gcodeOutput += "G1 X" + pv.x + " Y" + pv.y + " Z" + pv.z + "\n";
      } else {
        stroke(255);
        gcodeOutput += "G0 X" + v.x + " Y" + v.y + " Z" + v.z + "\n";
      }
      outp.addChild(createShape(LINE, v.x, v.y, v.z, pv.x, pv.y, pv.z));
    } else {
      noLoop();
      //println(gcodeOutput);
    }
    //println(p);
    shape(outp);
    p++;
  } else if (finished) {
    saveString("GCode.txt", gcodeOutput, "\n");
    started = false;
    finished = false;
  }
}

void saveString(String name, String in, String del) {
  StringList out = new StringList();
  for (String i : split(in, del)) {
    out.append(i);
  }
  saveStrings(name, out.array());
}


void drawMe(String inputData) {

  String[] q = split(inputData, ";");
  for (int i = 0; i < q.length-1; i++) {
    for (float j = DEEP; j > 0; j--) {
      String in = split(q[i], "|").length < 2 ? q[i] : split(q[i], "|")[split(q[i], "|").length-1];
      //println(in);
      String cmd = split(in, "(")[0];
      switch(cmd) {
      case "rect":
        float a = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        float c = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);
        float d = float(split(split(split(split(in, ")")[0], "(")[1], ",")[3], ")")[0]);
        moveToP(currPoint, new PVector(a, b, j));
        Rect(a, b, j, c, d);
        moveToP(currPoint, new PVector(currPoint.x, currPoint.y, DEEP));
        println("j = " + j);
        break;

      case "ellipse":
        float a1 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b1 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        float c1 = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);
        moveToP(currPoint, new PVector(a1, b1, j ));
        circle(a1, b1, j, c1);
        moveToP(currPoint, new PVector(a1, b1, DEEP));
        break;

      case "move":
        float a2 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b2 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        text("Move to " + a2 + "/" + b2, 100, 10);
        break;

      case "point":
        float a6 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b6 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        addPoint(a6, b6, j);
        point = true;
        break;

      case "vline":
        float a7 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b7 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        float c6 = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);
        float d6 = float(split(split(split(in, ")")[0], "(")[1], ",")[3]);
        moveToP(currPoint, new PVector(a7, b7, j));
        vline(a7, b7, c6, d6, j);
        println("HLine");
        moveToP(currPoint, new PVector(a7, b7, DEEP));
        println("VLine");
        break;

      case "line":
        float a11 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b11 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        float c11 = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);
        float d11 = float(split(split(split(in, ")")[0], "(")[1], ",")[3]);
        moveToP(currPoint, new PVector(a11, b11, j ));
        currPoint = new PVector(a11, b11, j);
        drawLine(new PVector(a11, b11), new PVector(c11, d11), j);
        println("Line");
        moveToP(currPoint, new PVector(a11, b11, DEEP));
        break;

      case "hline":
        float a8 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b8 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        float c7 = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);
        float d7 = float(split(split(split(in, ")")[0], "(")[1], ",")[3]);
        moveToP(currPoint, new PVector(a8, b8, j));
        hline(a8, b8, c7, d7, j);
        println("HLine");
        moveToP(currPoint, new PVector(a8, b8, DEEP));
        break;

      case "arc3in":
        float xr = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);//xr
        float yr = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);//yr
        float wr = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);//wr

        float hr = float(split(split(split(in, ")")[0], "(")[1], ",")[3]);//hr
        float xe = float(split(split(split(in, ")")[0], "(")[1], ",")[4]);//x
        float ye = float(split(split(split(in, ")")[0], "(")[1], ",")[5]);//y
        float re = float(split(split(split(in, ")")[0], "(")[1], ",")[6]);//r
        moveToP(currPoint, new PVector(xr, yr, j ));
        arc3in(xr, yr, wr, hr, xe, ye, re, j);
        moveToP(currPoint, new PVector(xr, yr, DEEP));
        println("Arc");
        break;


      case "arc3out":
        float xr1 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);//xr
        float yr1 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);//yr
        float wr1 = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);//wr

        float hr1 = float(split(split(split(in, ")")[0], "(")[1], ",")[3]);//hr
        float xe1 = float(split(split(split(in, ")")[0], "(")[1], ",")[4]);//x
        float ye1 = float(split(split(split(in, ")")[0], "(")[1], ",")[5]);//y
        float re1 = float(split(split(split(in, ")")[0], "(")[1], ",")[6]);//r
        moveToP(currPoint, new PVector(xr1, yr1, j ));
        arc3out(xr1, yr1, wr1, hr1, xe1, ye1, re1, j);
        moveToP(currPoint, new PVector(xr1, yr1, DEEP));
        println("Arc");
        break;

      case "circle":
        float a10 = float(split(split(split(in, ")")[0], "(")[1], ",")[0]);
        float b10 = float(split(split(split(in, ")")[0], "(")[1], ",")[1]);
        float c10 = float(split(split(split(in, ")")[0], "(")[1], ",")[2]);
        moveToP(currPoint, new PVector(currPoint.x, currPoint.y, j));
        circle(a10, b10, j, c10);
        moveToP(currPoint, new PVector(currPoint.x, currPoint.y, DEEP));
        break;
      }
      println(j);
    }
  }
  moveToP(new PVector(currPoint.x, currPoint.y, DEEP), new PVector(currPoint.x, currPoint.y, 0));
  moveToP(new PVector(currPoint.x, currPoint.y, 0), new PVector(0, 0, 0));
  //p/rintArray(vectors);
  int j = 0;
  gcodeOutput = "";
  for (int i = 0; i < vectors.size()-1; i++) {
    PVector v = vectors.get(i);
    PVector pv = vectors.get(i+1);
    if (isIn(UVNums, j)) {
      stroke(255, 0, 0);
      //gcodeOutput += "G0 X" + v.x + " Y" + v.y + " Z" + v.z + "\n";
      //gcodeOutput += "G1 X" + pv.x + " Y" + pv.y + " Z" + pv.z + "\n";
    } else {
      stroke(255);
      //gcodeOutput += "G0 X" + v.x + " Y" + v.y + " Z" + v.z + "\n";
    }
    out.addChild(createShape(LINE, v.x, v.y, v.z, pv.x, pv.y, pv.z));
    j++;
  }
} 


boolean isIn(int[] arr, int elem) {
  for (int c : arr) {
    if (c == elem) {
      return true;
    }
  }
  return false;
}


void vline(float x1, float y, float x2, float y2, float z) {
  moveToP(currPoint, new PVector(x1, y, z));
  drawLine(new PVector(x1, y), new PVector(x1, y2), z);
}

void hline(float x1, float y, float x2, float y2, float z) {
  moveToP(currPoint, new PVector(x1, y, z));
  drawLine(new PVector(x1, y), new PVector(x2, y), z);
}


void join_up(float x, float y, float w, float h, int n) {
  //alert("");
  move(x, y-h);
  //ctx.lineTo(x+85,y+25);

  for (int i = 1; i < n; i++) {
    //move(x*(i+2),y-h);
    if (i==1) {
      line(x*(i)+w, y-h);
      line(x*(i)+w, y);
      line(x*(i)+(w+h), y);
      line(x*(i)+(w+h), y-h);
      if (n==1) {
        line(((x*i)+(w+h)*1.5), y-h);
      }
    } else {
      line(x*(i+(i-1))+w, y-h);
      line(x*(i+(i-1))+w, y);
      line(x*(i+(i-1))+(w+h), y);
      line(x*(i+(i-1))+(w+h), y-h);
      if (i+1 == n) {
        line(x*(i+(i))+(w+h), y-h);
      }
    }
  }
}



void star(float R, float cX, float cY, float N) {
  move(cX + R, cY);
  for (int i = 1; i <= N * 2; i++)
  {
    if (i % 2 == 0) {
      float theta = i * (TWO_PI) / (N * 2);
      float x = cX + (R * cos(theta));
      float y = cY + (R * sin(theta));
      line(x, y);
    } else {
      float theta = i * (TWO_PI) / (N * 2);
      float x = cX + ((R/2) * cos(theta));
      float y = cY + ((R/2) * sin(theta));
      line(x, y);
    }
  }
}

void polygon(float x, float y, float radius, float sides) {
  if (sides < 3) return;
  float a = (TWO_PI/sides);
  move(x, y);
  move(radius, 0);
  for (int i = 1; i < sides; i++) {
    line(radius*cos(a*i), radius*sin(a*i));
  }
}

float getSpeed(String in) {
  float result = 0;
  result = float(split(split(split(in, "[")[1], "]")[0], ",")[0]);
  return result;
}

float getPower(String in) {
  float result = 0;
  result = float(split(split(split(in, "[")[1], "]")[0], ",")[1]);
  return result;
}

int getMachine(String in) {
  int result = 0;
  result = int(split(split(split(in, "[")[1], "]")[0], ",")[2]);
  return result;
}

boolean fileExists(String path) {
  File file=new File(path);
  println(file.getName());
  boolean exists = file.exists();
  if (exists) {
    println("true");
    return true;
  } else {
    println("false");
    return false;
  }
}

void writeToPort(String data) {
  // myPort.write(data);
}

String dataFromArduino() {
  String inBuffer = myPort.readString();   
  return inBuffer;
}


String getLine(String in, int line) {
  return split(in, "G")[line];
}

String getLineOfIP(int numberOfLine) {
  String input;
  c = s.available();
  if (c != null) {
    input = c.readString(); 
    String[] data = (split(input, ";"));  // Split values into an array
    //println(data[numberOfLine]);
    return data[numberOfLine];
  }
  return "-1";
}

int len() {
  String input;
  c = s.available();
  if (c != null) {
    input = c.readString(); 
    String[] data = (split(input, ";"));  // Split values into an array
    return data.length;
  }
  return -1;
}
int leng(PVector[] a) {
  int b = 0;
  for (PVector c : a) {
    if (c != null) {
      b++;
    }
  }
  return b;
}

void select() {
  try {
    int i = Serial.list().length;
    if (i != 0) {
      if (i >= 2) {
        // need to check which port the inst uses -
        // for now we'll just let the user decide
        for (int j = 0; j < i; ) {
          COMlist += char(j+'a') + " = " + Serial.list()[j] + "\n";
          if (++j < i) COMlist += "";
        }
        COMx = showInputDialog("Which COM port is correct? (a,b,..):\n"+COMlist);
        if (COMx == null) exit();
        if (COMx.isEmpty()) exit();
        i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
      }
      String portName = Serial.list()[i-1];

      myPort = new Serial(this, portName, 9600); // change baud rate to your liking
      myPort.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
    } else {
      showMessageDialog(frame, "Device is not connected to the PC");
      exit();
    }
  }
  catch (Exception e)
  { //Print the type of error
    showMessageDialog(frame, "COM port is not available (may\nbe in use by another program)");
    println("Error:", e);
    exit();
  }
}


void addPoint(float x, float y, float z) {
  vectors.add(new PVector(x, y, z));
  currPoint = new PVector(x, y, z);
  UVNums = append(UVNums, cnt);
  cnt++;
}

void addMPoint(float x, float y, float z) {
  vectors.add(new PVector(x, y, z));
  currPoint = new PVector(x, y, z);
  //UVNums = append(UVNums, cnt);
  cnt++;
}

void moveToP(PVector from, PVector to) {
  float angle = atan2((to.y - from.y), (to.x - from.x));

  //get the dist() of the line
  float lineLength = dist(from.x, from.y, to.x, to.y);

  //segmentLength = divide that amount by the # of shapes to be drawn
  float segmentLength = lineLength/dist(from.x, from.y, to.x, to.y);

  //loop through, once for each shape:
  for (int i = 1; i < dist(from.x, from.y, to.x, to.y); i++) {                
    float distFromStart = segmentLength * i;
    float px = from.x + distFromStart * cos(angle);
    float py = from.y + distFromStart * sin(angle);
    //UVNums = append(UVNums, cnt);
    addMPoint(px, py, to.z);
  }
}

void ellips(float x, float y, float radius1, float radius2)
{
  radius1 = radius1/2;
  radius2 = radius2/2;
  int points = 360;
  double slice = TWO_PI / points;
  for (int i = 0; i < points+1; i++)
  {
    double angle = slice * i;
    float newX = rnd(((x + radius1) * cos((float)angle)), 6);
    float newY = rnd(((y + radius2) * sin((float)angle)), 6);
    if (i == 0) {
      moveToP(currPoint, new PVector(newX, newY));
    }
    point(newX, newY);
  }
}

void circle(float x, float y, float z, float radius)
{
  radius = radius/2;
  int points = 360;
  double slice = TWO_PI / points;
  for (int i = 0; i < points+1; i++)
  {
    double angle = slice * i;
    float newX = rnd((x + radius * cos((float)angle)), 6);
    float newY = rnd((y + radius * sin((float)angle)), 6);
    if (i == 0) {
      moveToP(currPoint, new PVector(newX, newY, z));
    }
    addPoint(newX, newY, z);
  }
}

void arc3in(float xr, float yr, float wr, float hr, float x, float y, float radius, float z) {

  radius = radius/2;
  int points = 360;
  double slice = 2 * Math.PI / points;
  boolean a = false;
  for (float i = 0; i < points+1; i++)
  {
    double angle = slice * i;
    float newX = rnd((x + radius * cos((float)angle)), 6);
    float newY = rnd((y + radius * sin((float)angle)), 6);
    if (i == 0) {
      moveToP(currPoint, new PVector(newX, newY));
    }
    if (onRect(newX, newY, xr, yr, wr, hr)) {
      if (a) {
        drawLine(currPoint, new PVector(newX, newY), z); 
        a = false;
      }
      addPoint(newX, newY, z);
    }
  }
}


void drawLine(PVector from, PVector to, float z) {
  float angle = atan2((to.y - from.y), (to.x - from.x));

  //get the dist() of the line
  float lineLength = dist(from.x, from.y, to.x, to.y);

  //segmentLength = divide that amount by the # of shapes to be drawn
  float segmentLength = lineLength/dist(from.x, from.y, to.x, to.y);

  //loop through, once for each shape:
  for (int i = 1; i < dist(from.x, from.y, to.x, to.y); i++) {                
    float distFromStart = segmentLength * i;
    float px = from.x + distFromStart * cos(angle);
    float py = from.y + distFromStart * sin(angle);
    UVNums = append(UVNums, cnt);
    addPoint(px, py, z);
  }
}

void arc3out(float xr, float yr, float wr, float hr, float x, float y, float radius, float z) {

  radius = radius/2;
  int points = 360;
  double slice = 2 * Math.PI / points;
  boolean a = false;
  for (float i = 0; i < points+1; i++)
  {
    double angle = slice * i;
    float newX = rnd((x + radius * cos((float)angle)), 6);
    float newY = rnd((y + radius * sin((float)angle)), 6);
    if (i == 0) {
      moveToP(currPoint, new PVector(newX, newY));
    }
    if (!onRect(newX, newY, xr, yr, wr, hr)) {
      if (a) {
        drawLine(currPoint, new PVector(newX, newY), z); 
        a = false;
      }
      addPoint(newX, newY, z);
    }
  }
}

boolean onRect(float x, float y, float bx, float by, float bw, float bh) {
  if (x >= bx && x <= bx+bw && y >= by && y <= by+bh) {
    return true;
  }
  return false;
}

void line(double x, double y) {
  writeToPort("{" + x + "," + y + "}");
  output.println("lineTo(" + x + "," + y + ");");
}

void move(double x, double y) {
  writeToPort("[" + x + "," + y + "]");
  output.println("move(" + x + "," + y + ");");
}

PVector[] down = new PVector[500];

void Rect(float x, float y, float z, float w, float h) {
  moveToP(currPoint, new PVector(x, y));
  drawLine(new PVector(x, y, z), new PVector(x+w, y, z), z);
  drawLine(new PVector(x+w, y, z), new PVector(x+w, y+h, z), z);
  drawLine(new PVector(x+w, y+h, z), new PVector(x, y+h, z), z);
  drawLine(new PVector(x, y+h, z), new PVector(x, y, z), z);
}



float rnd(float number, float decimal) {
  return (float)(round((number*pow(10, decimal))))/pow(10, decimal);
} 

String SGMove(double x, double y) {
  return ("G0 X" + x + " Y" + y + "\n");
}

String SGLine(double x, double y) {
  return ("G1 X" + x + " Y" + y + "\n");
}


void lines() {
  RG.init(this);
  RG.ignoreStyles(ignoringStyles);

  RG.setPolygonizer(RG.ADAPTATIVE);

  grp = RG.loadShape(fileName  +".svg");
  grp.centerIn(g, 100, 1, 1);

  pointPaths = grp.getPointsInPaths();

  translate(width/2, height/2);

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

  rotateX(-ymag); 
  rotateY(-xmag); 

  background(0);
  stroke(255);
  noFill();
  float a = 0, b = 0;

  /*
  if(pointPaths[i][j].y < min){min = pointPaths[i][j].y;}
   if(pointPaths[i][j].x < max){max = pointPaths[i][j].x;}
   */



  for (int i = 0; i<pointPaths.length; i++) {
    if (pointPaths[i] != null) {
      beginShape();
      for (int j = 0; j<pointPaths[i].length; j++) {
        vertex(pointPaths[i][j].x, pointPaths[i][j].y);

        float xmaped = map(pointPaths[i][j].x, -200, 200, xcoord[1], xcoord[0]);
        float ymaped = map(pointPaths[i][j].y, -200, 200, ycoord[0], ycoord[1]);

        if (first_line== true) {
          String o = "G0 X"+ str((xmaped-a))+" Y"+str(ymaped-b) +" \n";
          String sendo = "["+ str((xmaped-a))+","+str(ymaped-b) +"]\n";
          gcodecommand = gcodecommand + o; 
          writeToPort(sendo);
          first_line = false;
        } else {
          String senda = "{"+ str((xmaped-a))+" Y"+str(ymaped-b) +"}\n";
          gcodecommand = gcodecommand + "G1 X"+ str((xmaped-a))+" Y"+str(ymaped-b) +" \n"; 
          writeToPort(senda);
        }
      }
      endShape();
    }

    if (i == pointPaths.length-1) {
      String[] gcodecommandlist = split(gcodecommand, '\n');
      if (save) {
        String name = showInputDialog("Enter path and file name for saving the file:");
        saveStrings(name+".txt", gcodecommandlist); 
        save = false;
      } else {
        saveStrings("file"+".txt", gcodecommandlist);
      }
      filesaved = 1;

      // exit();
    }
  }
} 