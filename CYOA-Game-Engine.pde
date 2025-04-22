public final float buttonTextSize = 50;
public float buttonHeight;
public int page;
public int nextPage;
public Page story;
public boolean mouseReleased;
public HashMap vars;
/*
  Variables are surrounded by ~ (Ex: ~var~)
 Important vars:
 - backgroundColor (sets the color of the background)
 - textColor (sets the color of the main text)
 - buttonColor (sets the color of the buttons)
 - choiceColor (sets the color of the text in the buttons)
 - textSize (sets the size on the main text)
 - textSpeed (sets the speed of the writing animation)
 - textAlign (sets wear the text is aligned)
 
 Page input:
 Line of text to desplay
 text for each button (seperated by | )
 the next page based on button pressed (seperated by | )
 Optional variable assignments (seperated by = )
 */
public void setup() {
  mouseReleased = false;
  size(1200, 800);
  buttonHeight = height/6.0;
  vars = new HashMap<String, String>();
  loadPage();
}

public void draw() {
  if (nextPage!=page) {
    page = nextPage;
    buildPage();
  }
  story.printPage();
}

public void mouseReleased() {
  mouseReleased = true;
}

public void buildPage() {
  BufferedReader storyBuilder = createReader(page + ".txt");
  String text, txtAlign;
  String[] choices;
  int txtSize, txtSpeed;
  int[] bgColor, txtColor, choiceColor, buttonColor, next;

  try {
    text = replaceVars(storyBuilder.readLine());
    if (text.indexOf("\\n") != -1) text = text.replace("\\n", "\n");

    choices = replaceVars(storyBuilder.readLine()).split(" \\| ");

    String[] temp = replaceVars(storyBuilder.readLine()).split(" \\| ");
    if (temp.length!=choices.length) throw new IOException("Invalid number of choices");
    next = new int[temp.length];
    for (int i = 0; i<temp.length; i++) {
      next[i] = Integer.parseInt(temp[i]);
    }

    String line = storyBuilder.readLine();
    while (line!=null) {
      temp = line.split(" = ");
      vars.put(temp[0], replaceVars(temp[1]));
      line = storyBuilder.readLine();
    }
    storyBuilder.close();
  }
  catch(Exception e) {
    text = "Missing Text";

    choices = new String[1];
    choices[0] = "Missing Choice";

    next = new int[choices.length];
    for (int i = 0; i<next.length; i++) next[i] = page;
  }

  if (vars.containsKey("textSize")) txtSize = Integer.parseInt((String) vars.get("textSize"));
  else txtSize = 100;

  if (vars.containsKey("textSpeed")) txtSpeed = Integer.parseInt((String) vars.get("textSpeed"));
  else txtSpeed = 5;

  if (vars.containsKey("textAlign")) txtAlign = (String) vars.get("textAlign");
  else txtAlign = "center";

  txtColor = setColor("textColor");

  choiceColor = setColor("choiceColor");

  bgColor = setColor("backgroundColor");

  buttonColor = setColor("buttonColor");

  story = new Page(text, choices, next, txtColor, choiceColor, bgColor, buttonColor, txtSize, txtSpeed, txtAlign);

  bookmark();
}

public int[] setColor(String name) {
  int[] arr;
  try {
    if (vars.containsKey(name)) {
      String[] temp = ((String) vars.get(name)).split(" \\| ");
      arr = new int[temp.length];
      for (int i = 0; i<temp.length; i++) {
        arr[i] = Integer.parseInt(temp[i]);
      }
    } else throw new Exception("Problem Setting Color");
  }
  catch(Exception e) {
    arr = new int[3];
    arr[0] = (name.equals("backgroundColor") | name.equals("choiceColor"))? 0 : 255;
    arr[1] = (name.equals("backgroundColor") | name.equals("choiceColor"))? 0 : 255;
    arr[2] = (name.equals("backgroundColor") | name.equals("choiceColor"))? 0 : 255;
  }
  return arr;
}

public void bookmark() {
  PrintWriter saver = createWriter("data\\page.txt");
  String v = vars.toString();
  saver.println(page);
  saver.print(v.substring(1, v.length() - 1));
  saver.flush();
  saver.close();
}

public void loadPage() {
  BufferedReader loader = createReader("page.txt");
  try {
    String line = loader.readLine();
    nextPage = Integer.parseInt(line);
    page = nextPage - 1;
    line = loader.readLine();
    if (line != null && !line.equals("")) {
      String[] pairs = line.split(", ");
      for (String pair : pairs) {
        String[] p = pair.split("=");
        vars.put(p[0], p[1]);
      }
    }
  }
  catch(Exception e) {
    page = -1;
    nextPage = 0;
  }
}

public String replaceVars(String line) {
  String newLine = line;
  while (newLine.indexOf("~") != -1) {
    int first = newLine.indexOf("~");
    int second = newLine.indexOf("~", first + 1);
    String varr = newLine.substring(first + 1, second);
    if (vars.containsKey(varr)) newLine = newLine.substring(0, first) + vars.get(varr) + newLine.substring(second + 1);
    else newLine = newLine.substring(0, first) + "(Missing Var)" + newLine.substring(second + 1);
  }
  return newLine;
}
