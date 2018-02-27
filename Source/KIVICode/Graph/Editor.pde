import java.util.*;

public class EditorNode extends PApplet {

  String nodePath;
  GTextArea txaSample;
  int bgcol = 32;
  String startText = "";
  boolean isNew = true;
  EditorNode(String in) {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
    nodePath = in;
  }

  void settings() {
    size(640, 480);
  }


  String name = "New Node.txt";
  public void setup() {
    // G4P.setGlobalColorScheme(0);
    this.surface.setResizable(true);

    txaSample = new GTextArea(this, -5, -5, width+10, height+10, G4P.SCROLLBARS_NONE);
    txaSample.setText(name, 320);
    txaSample.setPromptText("Please enter your code");
    
    removeExitEvent(this.surface);
  }

  void setNameOfFile(String n) {
    name = n;
    txaSample.setText(loadStrings(nodePath + stick + name), 310);
  }
  public void draw() {
    surface.setTitle(split(name, ".")[0]);
  }

  void stop() {
    surface.setVisible(false);
  }

  public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) { /* code */
  }

  public void setVis(boolean a) {
    surface.setVisible(a);
  }
  void saveNode() {
    if (isNew) {
      String newName = showInputDialog("Enter name of new node");
      println(dataPath + stick + "CustomNodes" + stick + newName+".txt");
      PrintWriter p = createWriter(dataPath + stick + "CustomNodes" + stick + newName+".txt");
      for (int i = 0; i < split(txaSample.getText(), ";").length-1; i++ ) {
        p.println(split(txaSample.getText(), ";")[i]+";");
      }
      p.flush();
      //saveStrings(dataPath + stick + "CustomNodes" + stick + newName+".txt", split(txaSample.getText(), "\n"));
      name = newName;
      isNew = false;
    } else {
      println(dataPath + stick + "CustomNodes" + stick + name);
      PrintWriter p = createWriter(dataPath + stick + "CustomNodes" + stick + name);
      for (int i = 0; i < split(txaSample.getText(), ";").length-1; i++ ) {
        p.println(split(txaSample.getText(), ";")[i]+";");
      }
      p.flush();
    }
  }

  void newNode() {
    txaSample.setText("");
    name =  "newNode.txt";
    isNew = true;
  }
  public Object getSurf() {
    return surface;
  }
}