public class Entity {

  PImage sprite;

  final int id, maxHealth, def, dodge, speed;
  final String name, imgSrc;
  final Range damage;

  final int[] attackIndices;
  int health, poison;
  boolean dead;

  Hitbox bounds;

  Entity(int id, String name, String imgSrc, int maxHealth, Range damage, int def, int dodge, int speed, int[] attackIndices) {
    this.id = id;
    this.name = name;
    this.imgSrc = imgSrc;
    this.maxHealth = maxHealth;
    this.damage = damage;
    this.def = def;
    this.dodge = dodge;
    this.speed = speed;
    this.attackIndices = attackIndices;

    this.health = maxHealth;
    this.poison = 0;
    this.dead = false;

    sprite = loadImage("data/sprites/" + imgSrc);
    bounds = new Hitbox(0, 0, 0, 0);
  }

  void project(int bWidth, int bHeight) {
    if (sprite.width > sprite.height) {
      sprite.resize(bWidth, 0);
    } else {
      sprite.resize(0, bHeight);
    }

    bounds.bWidth = sprite.width;
    bounds.bHeight = sprite.height;
  }

  void tick() {
    if (!this.dead) {
      this.health -= this.poison;
      this.poison = floor(this.poison / 2.0);

      this.checkDead();
    }
  }

  void render(boolean selected) {
    if (this.dead) {
      tint(0);
    } else if (selected) {
      tint(204);
    } else {
      noTint();
    }

    image(this.sprite, bounds.x, bounds.y);

    // health bar
    float healthWidth = map(this.health, 0, this.maxHealth, 0, bounds.bWidth);
    color healthColor = this.health > this.maxHealth / 3.0 ? GREEN : RED;

    stroke(0);
    fill(healthColor);
    rect(bounds.x, bounds.y - 20, healthWidth, 10);
    
    // character name
    float nameX = bounds.x + (bounds.bWidth / 2) - (textWidth(name) / 2);
    float nameY = bounds.y + bounds.bHeight + textAscent() + 5;
    fill(0);
    text(this.name, nameX, nameY);
  }

  void attack(Entity target, int attackIndex) {
    if (!target.dead) {
      attacks.get(attackIndices[attackIndex]).perform(this, target);
    }
  }

  void checkDead() {
    if (this.health <= 0) {
      this.die();
    }
  }

  void die() {
    this.health = 0;
    this.dead = true;
  }

  Entity copy() {
    return new Entity(id, name, imgSrc, maxHealth, damage, def, dodge, speed, attackIndices);
  }
}

class Attack {
  final String name;
  final int id, damageMod, poison;

  Attack(int id, String name, int damageMod, int poison) {
    this.id = id;
    this.name = name;
    this.damageMod = damageMod;
    this.poison = poison;
  }

  void perform(Entity attacker, Entity target) {
    if (random(0, 100) > target.dodge) {
      float rawDamage = attacker.damage.getRandom() * (1 + (this.damageMod / 100.0));
      float defFactor = (1 - (target.def / 100.0));
      target.health -= rawDamage * defFactor;
    }

    // poison the target
    target.poison += this.poison;

    // check if the target was killed
    target.checkDead();
  }
}

class Team {

  final Entity[] members;

  Team(ArrayList<Entity> choices, int... ids) {
    members = new Entity[ids.length];
    for (int i = 0; i < ids.length; i++) {
      members[i] = choices.get(ids[i]).copy();
    }
  }

  Team(Entity... members) {
    this.members = members;
  }
}