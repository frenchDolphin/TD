void setup() {
  fullScreen();

  Scene.setCurrentScene(new BattleScene());
}

void draw() {
  background(204);

  Scene.getCurrentScene().update();
  Scene.getCurrentScene().render();
}

void mousePressed() {
  Scene.getCurrentScene().mousePressed();
}

void keyPressed() {
  Scene.getCurrentScene().keyPressed();
}