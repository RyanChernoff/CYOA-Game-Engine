public class Page {
  private String text, currentText, txtAlign;
  private String[] choices;
  private int txtSize, txtSpeed, timer;
  private int[] bgColor, txtColor, choiceColor, buttonColor, hoverColor, next;
  private boolean showButtons;

  public Page(String t, String[] c, int[] n, int[] txt, int[] cc, int[] bg, int[] button, int ts, int txs, String ta) {
    text = t;
    txtColor = txt;
    choices = c;
    choiceColor = cc;
    next = n;
    bgColor = bg;
    buttonColor = button;
    txtSize = ts;
    txtSpeed = txs;
    txtAlign = ta;
    hoverColor = new int[3];
    for (int i = 0; i<3; i++) {
      hoverColor[i] = buttonColor[i] + 50;
      if (hoverColor[i]>255) hoverColor[i]=255;
    }
    timer = -1;
    currentText = "";
    showButtons = false;
  }

  public void printPage() {
    background(bgColor[0], bgColor[1], bgColor[2]);
    if (currentText.length() != text.length()) {
      timer++;
      if (timer % txtSpeed == 0) currentText += text.substring(currentText.length(), currentText.length() + 1);
    } else showButtons = true;
    fill(txtColor[0], txtColor[1], txtColor[2]);
    textSize(txtSize);
    if (txtAlign.toLowerCase().equals("center")) textAlign(CENTER, CENTER);
    else if (txtAlign.toLowerCase().equals("left")) textAlign(LEFT, CENTER);
    else if (txtAlign.toLowerCase().equals("right")) textAlign(RIGHT, CENTER);
    else textAlign(CENTER, CENTER);
    text(currentText, 20, 20, width-40, height-buttonHeight-40);
    if (showButtons) {
      float buttonWidth = ((float)width)/choices.length;
      for (int i = 0; i < choices.length; i++) {
        float x = (i*26 + 1)*buttonWidth/26;
        float y = height - buttonHeight;
        float w = 12*buttonWidth/13;
        float h = buttonHeight - 15;
        if (mouseX>= x && mouseX < x + w && mouseY >= y) {
          fill(hoverColor[0], hoverColor[1], hoverColor[2]);
          if (mouseReleased) {
            mouseReleased = false;
            nextPage = next[i];
            break;
          }
        } else fill(buttonColor[0], buttonColor[1], buttonColor[2]);
        rect(x, y, w, h, 35);
        fill(choiceColor[0], choiceColor[1], choiceColor[2]);
        textSize(buttonTextSize);
        for (float size = buttonTextSize; textWidth(choices[i])>= buttonWidth; size--) textSize(size);
        textAlign(CENTER, CENTER);
        textLeading(40);
        text(choices[i], x, y, w, h);
      }
      mouseReleased = false;
    }
  }
}
