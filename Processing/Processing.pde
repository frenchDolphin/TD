static final ArrayList<Attack> attacks = new ArrayList();
static final ArrayList<Entity> heroes = new ArrayList();
static final ArrayList<Entity> enemies = new ArrayList();

void setup() {
  fullScreen();

  loadAttacks("attacks.json", attacks);
  loadEntities("heroes.json", heroes);
  loadEntities("enemies.json", enemies);

  Scene.setCurrentScene(new BattleScene());
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
      int health = entity.getInt("health", 1);
      int def = entity.getInt("def", 0);
      int dodge = entity.getInt("dodge", 0);
      int speed = entity.getInt("speed", 0);

      Range damage = new Range(entity.getJSONArray("damage"));
      int[] attackIndices = entity.getJSONArray("attacks").getIntArray();
      // load attacks here!!!

      Entity loaded = new Entity(id, name, health, damage, def, dodge, speed, attackIndices);
      out.add(loaded);
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
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