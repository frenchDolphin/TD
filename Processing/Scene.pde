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
      heroHitboxes[i] = new Hitbox(100 + (i * currentHeroes.members[i].sprite.width), 100, currentHeroes.members[i].sprite.width, currentHeroes.members[i].sprite.height);
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      enemyHitboxes[i] = new Hitbox(400 + (i * currentEnemies.members[i].sprite.width), 100, currentEnemies.members[i].sprite.width, currentEnemies.members[i].sprite.height);
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
        tint(0);
      } else {
        tint(255);

        if (hero == selectedHero) {
          tint(0, 0, 255);
        } else {
          tint(255);
        }
      }

      image(hero.sprite, box.x, box.y);
      text(hero.health, box.x, box.y);
    }

    for (int i = 0; i < enemyHitboxes.length; i++) {
      Hitbox box = enemyHitboxes[i];
      Entity enemy = currentEnemies.members[i];

      if (enemy.dead) {
        tint(0);
      } else {
        tint(255);
      }

      image(enemy.sprite, box.x, box.y);
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