abstract class Entity {

  int maxHealth, prot, dodge, speed;
  Range damage;

  ArrayList<Attack> attacks;
  int health, poison;
  boolean dead;

  Entity(int maxHealth, Range damage, int prot, int dodge, int speed) {
    this.maxHealth = maxHealth;
    this.damage = damage;
    this.prot = prot;
    this.dodge = dodge;
    this.speed = speed;

    this.health = maxHealth;
    this.poison = 0;
    this.dead = false;
  }

  void attack(Entity other, int attackIndex) {
    attacks.get(attackIndex).perform(this, other);
  }

  void die() {
    this.health = 0;
    this.dead = true;
  }
}

class Attack {

  int damageMod, poison;

  Attack() {
    this(0, 0);
  }

  Attack(int damageMod) {
    this(damageMod, 0);
  }

  Attack(int damageMod, int poison) {
    this.damageMod = damageMod;
    this.poison = poison;
  }

  void perform(Entity attacker, Entity target) {
    if (random(0, 100) > target.dodge) {
      float rawDamage = attacker.damage.getRandom() * (1 + (target.prot / 100.0));
      float protFactor = (1 - (target.prot / 100.0));
      target.health -= rawDamage * protFactor;
    }

    if (this.poison > target.poison) {
      target.poison = this.poison;
    }

    if (target.health <= 0) {
      target.die();
    }
  }
}

// IMPLEMENTATIONS

class Biter extends Entity {

  Biter() {
    // 8 health, 2-3 damage, 5% protection, 0% dodge chance, 5 speed
    super(8, new Range(2, 3), 5, 0, 5);

    attacks = new ArrayList();
    attacks.add(new Attack());
  }
}

class WarHero extends Entity {

  WarHero() {
    // 8 health, 3-4 damage, 5% protection, 0% dodge chance, 5 speed
    super(12, new Range(3, 4), 0, 10, 3);

    attacks = new ArrayList();
    attacks.add(new Attack());
  }
}