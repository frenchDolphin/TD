// Gameplay-related stuff
static final ArrayList<Attack> attacks = new ArrayList();
static final ArrayList<Entity> heroes = new ArrayList();
static final ArrayList<Entity> enemies = new ArrayList();

Team party;

// Gameloop-related stuff
TimeManager time;

// Rendering-related stuff
final color RED = color(255, 0, 0);
final color GREEN = color(0, 255, 0);
final color BLUE = color(0, 0, 255);

void setup() {
  fullScreen();

  loadAttacks("attacks.json", attacks);
  loadEntities("heroes.json", heroes);
  loadEntities("enemies.json", enemies);

  party = new Team(heroes, 0, 0, 1);
  Team versus = new Team(enemies, 0, 0);

  time = new TimeManager();
  Scene.setCurrentScene(new BattleScene(party, versus));
}

void loadAttacks(String src, ArrayList out) {
  try {
    JSONArray loader = loadJSONArray(src);

    for (int i = 0; i < loader.size(); i++) {
      JSONObject attack = loader.getJSONObject(i);

      int id = out.size();
      String name = attack.getString("name", "");
      int damage = attack.getInt("damage", 0);
      int poison = attack.getInt("poison", 0);

      Attack loaded = new Attack(id, name, damage, poison);
      out.add(loaded);
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void loadEntities(String src, ArrayList out) {
  try {
    JSONArray loader = loadJSONArray(src);

    for (int i = 0; i < loader.size(); i++) {
      JSONObject entity = loader.getJSONObject(i);

      int id = out.size();
      String name = entity.getString("name", "");
      String imgSrc = entity.getString("imgSrc", "");
      int health = entity.getInt("health", 1);
      int def = entity.getInt("def", 0);
      int dodge = entity.getInt("dodge", 0);
      int speed = entity.getInt("speed", 0);

      Range damage = new Range(entity.getJSONArray("damage"));
      int[] attackIndices = entity.getJSONArray("attacks").getIntArray();

      Entity loaded = new Entity(id, name, imgSrc, health, damage, def, dodge, speed, attackIndices);
      out.add(loaded);
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  time.record();
  // update game logic once for every tick passed
  int ticksPassed = 0;
  while (time.doTick()) {
    Scene.getCurrentScene().tick();
    
    // limit the number of iterations to 10
    ticksPassed++;
    if (ticksPassed >= 10) {
      break;
    }
  }

  background(204);
  Scene.getCurrentScene().render();
}

void mousePressed() {
  Scene.getCurrentScene().mousePressed();
}

void keyPressed() {
  Scene.getCurrentScene().keyPressed();
}