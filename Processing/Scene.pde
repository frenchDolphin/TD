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

  Team currentEnemies, currentHeroes;
  Entity selectedHero;

  Hitbox[] heroHitboxes, enemyHitboxes;

  BattleScene(Team currentHeroes, Team currentEnemies) {
    this.currentHeroes = currentHeroes;
    this.currentEnemies = currentEnemies;
    heroHitboxes = new Hitbox[currentHeroes.members.length];
    enemyHitboxes = new Hitbox[currentEnemies.members.length];

    for (int i = 0; i < currentHeroes.members.length; i++) {
      heroHitboxes[i] = new Hitbox(50 + (i * 50), 50, 25, 50);
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      enemyHitboxes[i] = new Hitbox(250 + (i * 50), 50, 25, 50);
    }
    
    selectedHero = currentHeroes.members[0];
  }

  void update() {
  }

  void render() {
    for (int i = 0; i < heroHitboxes.length; i++) {
      Hitbox box = heroHitboxes[i];
      Entity hero = currentHeroes.members[i];

      if (hero.dead) {
        fill(0);
        stroke(255);
      } else {
        fill(255);
        
        if (hero == selectedHero) {
          stroke(0, 0, 255);
        } else {
          stroke(0);
        }
      }

      rect(box.x, box.y, box.bWidth, box.bHeight);
      text(hero.health, box.x, box.y);
    }

    for (int i = 0; i < enemyHitboxes.length; i++) {
      Hitbox box = enemyHitboxes[i];
      Entity enemy = currentEnemies.members[i];

      stroke(255, 0, 0);
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
    for (int i = 0; i < heroHitboxes.length; i++) {
      Hitbox box = heroHitboxes[i];
      if (box.contains(mouseX, mouseY)) {
        selectedHero = currentHeroes.members[i];
      }
    }

    for (int i = 0; i < enemyHitboxes.length; i++) {
      Hitbox box = enemyHitboxes[i];
      if (box.contains(mouseX, mouseY)) {
        selectedHero.attack(currentEnemies.members[i], 0);
      }
    }
  }
}