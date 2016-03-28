public abstract static class Scene {

  public abstract void tick(TimeManager time);
  public abstract void render(TimeManager time);

  public void mousePressed() {
  }

  public void keyPressed() {
  }
}

// IMPLEMENTATIONS
public class BattleScene extends Scene {

  public static final int BATTLE_BASELINE = 450;

  private Team currentEnemies, currentHeroes;
  private Entity selectedHero;

  public BattleScene(Team currentHeroes, Team currentEnemies) {
    this.currentHeroes = currentHeroes;
    this.currentEnemies = currentEnemies;

    for (int i = 0; i < currentHeroes.members.length; i++) {
      Entity hero = currentHeroes.members[i];

      hero.project(50, 100);
      hero.bounds.x = 100 + (i * (hero.sprite.width + 5));
      hero.bounds.y = BATTLE_BASELINE - hero.sprite.height;
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      Entity enemy = currentEnemies.members[i];

      enemy.project(50, 100);
      enemy.bounds.x = 400 + (i * (enemy.sprite.width + 5));
      enemy.bounds.y = BATTLE_BASELINE - enemy.sprite.height;
    }

    selectedHero = currentHeroes.members[0];
  }

  void tick(TimeManager time) {
    for (int i = 0; i < currentHeroes.members.length; i++) {
      currentHeroes.members[i].tick();
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      currentEnemies.members[i].tick();
    }
  }

  public void render(TimeManager time) {
    float halfTPT = time.timePerTick / 2.0;
    if (time.tickDelta <= halfTPT) {
      color tickIndicatorColor = color(255, 0, 0, map(time.tickDelta, halfTPT, 0, 0, 255));

      noStroke();
      fill(tickIndicatorColor);
      rect(0, 0, width, height);

      fill(255);
      rect(15, 15, width - 30, height - 30);
    }

    // render the title
    String text = "Time-Based Dungeon Crawler";
    fill(0);
    textFont(titleFont, 48);
    text(text, (width / 2) - (textWidth(text) / 2), 50 + textAscent());

    textFont(gameFont, 16);
    for (int i = 0; i < currentHeroes.members.length; i++) {
      Entity hero = currentHeroes.members[i];

      hero.render(hero == selectedHero);
    }

    int bY = selectedHero.bounds.y + selectedHero.bounds.bHeight + 50;
    Hitbox bounds = new Hitbox(64, bY, 64, 64);

    for (int i = 0; i < selectedHero.attackIndices.length; i++) {
      Attack attack = attacks.get(selectedHero.attackIndices[i]);

      if (attack.hasSprite()) {
        attack.render(bounds);
        bounds.x += bounds.bWidth + 5;
      }
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      currentEnemies.members[i].render(false);
    }
  }

  public void mousePressed() {
    for (int i = 0; i < currentHeroes.members.length; i++) {
      Entity hero = currentHeroes.members[i];
      if (hero.bounds.contains(mouseX, mouseY)) {
        selectedHero = currentHeroes.members[i];
      }
    }

    for (int i = 0; i < currentEnemies.members.length; i++) {
      Entity enemy = currentEnemies.members[i];
      if (enemy.bounds.contains(mouseX, mouseY)) {
        selectedHero.attack(currentEnemies.members[i], 0);
      }
    }
  }
}