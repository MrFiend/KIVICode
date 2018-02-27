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

    txaSample = new GTextArea(this, 0, 0, width+5, height+5, G4P.SCROLLBARS_NONE);
    txaSample.setText(name, 310);
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
      saveStrings(dataPath("CustomNodes") + stick + showInputDialog("Enter name of new node")+".txt", split(txaSample.getText(), "\n"));
      isNew = false;
    } else {
      saveStrings(dataPath("CustomNodes") + stick + name, split(txaSample.getText(), "\n"));
    }
  }

  void newNode() {
    txaSample.setText("");
    isNew = true;
  }
  public Object getSurf() {
    return surface;
  }
}