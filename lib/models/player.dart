class Player {
  int level = 1;
  int experience = 0;
  int experienceToNextLevel = 100;
  int energy = 100; // Add energy property
  int gems = 0;

  void addExperience(int amount) {
    experience += amount;
    while (experience >= experienceToNextLevel) {
      experience -= experienceToNextLevel;
      level++;
      experienceToNextLevel = level * 100; // Simple scaling
    }
  }

  void addEnergy(int amount) {
    energy += amount;
    // Cap energy at a maximum if needed
  }

  bool removeEnergy(int amount) {
    if (energy >= amount) {
      energy -= amount;
      return true;
    }
    return false;
  }
}
