public class myMenuListener implements ActionListener, ItemListener {

  myMenuListener() {
  }

  public void actionPerformed(ActionEvent e) {
    MenuItem source = (MenuItem)(e.getSource());
    println(isFileNode(source.getLabel())); //<>//
    if (source.getLabel().equals("Save As         ⇧⌘S")) {
      selectOutput("Save file:", "Save");
    } else if (source.getLabel().equals("Save              ⌘S") && sel != null) {
      saveFunction(sel);
    } else if (source.getLabel().equals("Load               ⌘L")) {
      selectInput("Select a file to open:", "Load");
    } else if (source.getLabel().equals("GCode")) {
      selectOutput("", "exportGCode");
    } else if (source.getLabel().equals("SVG")) {
      selectOutput("", "exportSVG");
    } else if (source.getLabel().equals("DXF")) {
      selectOutput("", "exportDXF");
    } else if (source.getLabel().equals("PDF")) {
      selectOutput("", "exportPDF");
    } else if (source.getLabel().equals("PNG")) {
      selectOutput("", "exportPNG");
    } else if (source.getLabel().equals("Move to zero")) {
      transX = 0;
      transY = 0;
    } else if (source.getLabel().equals("Run on machine")) {
      String speed = showInputDialog("Enter speed");
      String power = showInputDialog("Enter power (in %)");
      String type = showInputDialog("Enter type of machine\n1-laser 2-milling 3-3D printer");
      if (speed != null && power != null && type != null) {
        run(float(speed), float(power), int(type));
      } else {
        showMessageDialog(frame, "You need to enter speed, power and type of machine to execute it");
      }
    } else if (source.getLabel().endsWith(".txt")) {
      edit.setNameOfFile(source.getLabel());
      edit.isNew = false;
      edit.setVis(true);
    } else if (isFileNode(source.getLabel())) { //<>//
      float val = float(int(random(0, 300)));
      String type = source.getLabel();
      line.add(new Line((width/2)-transX, (height/2)-transY, -1, val, type));
      line.get(id).index = id;
      id++;
      println(type); //<>//
    } else if (source.getLabel().equals("Save Node")) {
      edit.saveNode();
    } else if (source.getLabel().equals("New Node") || source.getLabel().equals("Open NodeEditor")) {
      edit.newNode();
      edit.setVis(true);
    } else if (source.getLabel().equals("Open/Close Vector Editor")) {
      vector.visibility = ! vector.visibility;
      vector.setVis(vector.visibility);
      println(vector.visibility);
    }
  }
  public void itemStateChanged(ItemEvent e) {

    MenuItem source = (MenuItem)(e.getSource());

    String s = "Action event detected." + "    Event source: " + source.getLabel()
      + " (an instance of " + getClassName(source) + ")";

    println(s);

    //this part changes the background colour
    if (source.getLabel().equals("Load Layer")) {
      println("Load a layer");
    } else if (source.getLabel().equals("Save Layer")) {
      println("Save a layer");
    } else if (source.getLabel().equals("View Open")) {
      println(" Open view window");
    } else if (source.getLabel().equals("View Close")) {
      println("Close view window");
    } else if (source.getLabel().equals("Flip View")) {
      println("Flip view window");
    } else println(" etc. etc..");
  }

  protected String getClassName(Object o) {
    String classString = o.getClass().getName();
    int dotIndex = classString.lastIndexOf(".");
    return classString.substring(dotIndex+1);
  }
}

boolean isFileNode(String name) {
  return new File(dataPath("CustomNodes") + stick + name + ".txt").exists();
}

void menu_setup() {

  menuListen = new myMenuListener();
  myMenu = new MenuBar();
  saveMenu = new MenuBar();

  fileMenu = new Menu("File");
  exportMenu = new Menu("Export");
  runMenu = new Menu("Machine");
  editMenu = new Menu("Edit");
  fileMenuSave = new Menu("File");
  PasteMenu = new Menu("Place Node");
  VectorMenu = new Menu("Vector Editor");

  fileSave = new MenuItem("Save              ⌘S");
  fileSave.addActionListener(menuListen);

  fileSaveAs = new MenuItem("Save As         ⇧⌘S");
  fileSaveAs.addActionListener(menuListen);

  fileLoad = new MenuItem("Load               ⌘L");
  fileLoad.addActionListener(menuListen);

  exportSVG = new MenuItem("SVG");
  exportSVG.addActionListener(menuListen);

  exportDXF = new MenuItem("DXF");
  exportDXF.addActionListener(menuListen);

  exportGCode = new MenuItem("GCode");
  exportGCode.addActionListener(menuListen);

  exportPDF = new MenuItem("PDF");
  exportPDF.addActionListener(menuListen);

  exportPNG = new MenuItem("PNG");
  exportPNG.addActionListener(menuListen);

  goHome = new MenuItem("Move to zero");
  goHome.addActionListener(menuListen);

  machineRun = new MenuItem("Run on machine");
  machineRun.addActionListener(menuListen);

  openEditor = new MenuItem("Open NodeEditor");
  openEditor.addActionListener(menuListen);

  saveFile = new MenuItem("Save Node");
  saveFile.addActionListener(menuListen);

  newNode = new MenuItem("New Node");
  newNode.addActionListener(menuListen);

  openVectorMenu = new MenuItem("Open/Close Vector Editor");
  openVectorMenu.addActionListener(menuListen);

  exportMenu.add(exportGCode);
  exportMenu.add(exportSVG);
  exportMenu.add(exportDXF);
  exportMenu.add(exportPDF);
  exportMenu.add(exportPNG);

  fileMenu.add(fileSave);
  fileMenu.add(fileSaveAs);
  fileMenu.add(fileLoad);
  fileMenu.add(goHome);

  runMenu.add(machineRun);

  editMenu.add(openEditor);

  VectorMenu.add(openVectorMenu);
  File dir = new File(dataPath("CustomNodes") + stick);
  for (File curr : dir.listFiles()) {
    MenuItem itm = new MenuItem(curr.getName());
    itm.addActionListener(menuListen);
    if (curr.getPath().endsWith(".txt")) {
      openFile.add(itm);
      MenuItem itm2 = new MenuItem(itm.getLabel().substring(0, itm.getLabel().length()-4));
      itm2.addActionListener(menuListen);
      pastFile.add(itm2);
    }
  }

  PasteMenu.add(pastFile);
  editMenu.add(openFile);

  myMenu.add(fileMenu);
  myMenu.add(exportMenu);
  myMenu.add(runMenu);
  myMenu.add(editMenu);
  myMenu.add(PasteMenu);
  myMenu.add(VectorMenu);

  fileMenuSave.add(newNode);
  fileMenuSave.add(saveFile);
  saveMenu.add(fileMenuSave);


  PSurfaceAWT awtSurface = (PSurfaceAWT)(surface);
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setMenuBar(myMenu);

  PSurfaceAWT awtSurface1 = (PSurfaceAWT)(edit.getSurf());
  PSurfaceAWT.SmoothCanvas smoothCanvas1 = (PSurfaceAWT.SmoothCanvas)awtSurface1.getNative();
  smoothCanvas1.getFrame().setMenuBar(saveMenu);
}

Menu openFile = new Menu("Edit File");
Menu pastFile = new Menu("Select Node");
MenuItem item;