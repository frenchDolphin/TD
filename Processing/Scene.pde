abstract static class Scene {

  static Scene currentScene;

  static Scene getCurrentScene() {
    return currentScene;
  }

  static void setCurrentScene(Scene newScene) {
    currentScene = newScene;
  }

  abstract void update();
  abstract void render();

  void mousePressed() {
  }

  void keyPressed() {
  }
}

// IMPLEMENTATIONS
class BattleScene extends Scene {

  Entity[] currentEnemies = {
    enemies.get(0)
  };

  Entity[] currentHeroes = {
    heroes.get(0)
  };

  Hitbox[] hitboxes = new Hitbox[currentEnemies.length];

  BattleScene() {
    for (int i = 0; i < currentEnemies.length; i++) {
      hitboxes[i] = new Hitbox(250 + (i * 50), 50, 25, 50);
    }
  }

  void update() {
  }

  void render() {
    for (int i = 0; i < hitboxes.length; i++) {
      Hitbox box = hitboxes[i];
      Entity enemy = currentEnemies[i];

      if (enemy.dead) {
        fill(0);
      } else {
        fill(255);
      }

      rect(box.x, box.y, box.bWidth, box.bHeight);
      text("Health: " + enemy.health, box.x, box.y);
    }
  }

  void mousePressed() {
    for (int i = 0; i < hitboxes.length; i++) {
      Hitbox box = hitboxes[i];
      if (box.contains(mouseX, mouseY)) {
        currentEnemies[i].attack(currentEnemies[i], 0);
      }
    }
  }
}