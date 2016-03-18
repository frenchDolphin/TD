abstract static class Scene {

  static Scene currentScene;

  static Scene getCurrentScene() {
    return currentScene;
  }

  static void setCurrentScene(Scene newScene) {
    currentScene = newScene;
  }

  abstract void tick();
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
      heroHitboxes[i] = new Hitbox(100 + (i * (currentHeroes.members[i].sprite.width + 5)), 100, currentHeroes.members[i].sprite.width, currentHeroes.members[i].sprite.height);
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      enemyHitboxes[i] = new Hitbox(400 + (i * (currentEnemies.members[i].sprite.width + 5)), 100, currentEnemies.members[i].sprite.width, currentEnemies.members[i].sprite.height);
    }

    selectedHero = currentHeroes.members[0];
  }

  void tick() {
    for (int i = 0; i < heroHitboxes.length; i++) {
      currentHeroes.members[i].tick();
    }

    for (int i = 0; i < enemyHitboxes.length; i++) {
      currentEnemies.members[i].tick();
    }
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
          tint(204);
        } else {
          tint(255);
        }
      }

      image(hero.sprite, box.x, box.y);

      float healthWidth = map(hero.health, 0, hero.maxHealth, 0, box.bWidth);
      color healthColor = hero.health > hero.maxHealth / 3.0 ? GREEN : RED;

      stroke(0);
      fill(healthColor);
      rect(box.x, box.y - 20, healthWidth, 15);
    }

    for (int i = 0; i < enemyHitboxes.length; i++) {
      Hitbox box = enemyHitboxes[i];
      Entity enemy = currentEnemies.members[i];

      stroke(0);
      if (enemy.dead) {
        tint(0);
      } else {
        tint(255);
      }

      image(enemy.sprite, box.x, box.y);

      if (enemy.health > 0) {
        float healthWidth = map(enemy.health, 0, enemy.maxHealth, 0, box.bWidth);
        color healthColor = enemy.health > enemy.maxHealth / 3.0 ? GREEN : RED;

        stroke(0);
        fill(healthColor);
        rect(box.x, box.y - 20, healthWidth, 15);
      }
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