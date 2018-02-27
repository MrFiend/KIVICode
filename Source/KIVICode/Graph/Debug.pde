public class CWindow extends PApplet {
  CWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }
Console console;
 void settings(){
  size(300,128); 
 }
 
 void setup(){
  console = new Console(this);
  console.start(); 
  surface.setTitle("Console");
  println("\nStarted\nStarted\nStarted\nStarted\nStarted\nStarted");
 }
 
 void draw(){
   console.draw();
 }
}