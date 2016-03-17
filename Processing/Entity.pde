class Entity {

  int id, maxHealth, def, dodge, speed;
  String name;
  Range damage;

  int[] attackIndices;
  int health, poison;
  boolean dead;

  Entity(int id, String name, int maxHealth, Range damage, int def, int dodge, int speed, int[] attackIndices) {
    this.id = id;
    this.maxHealth = maxHealth;
    this.damage = damage;
    this.def = def;
    this.dodge = dodge;
    this.speed = speed;
    this.attackIndices = attackIndices;

    this.health = maxHealth;
    this.poison = 0;
    this.dead = false;
  }

  void attack(Entity other, int attackIndex) {
    attacks.get(attackIndices[attackIndex]).perform(this, other);
  }

  void die() {
    this.health = 0;
    this.dead = true;
  }
}

class Attack {
  String name;
  int id, damageMod, poison;

  Attack(int id, String name, int damageMod, int poison) {
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

    if (target.health <= 0) {
      target.die();
    }
  }
}