import '../providers/game_state.dart'; // Import Upgrade class

class UpgradeService {
  static List<Upgrade> getClickUpgrades() {
    return [
      Upgrade(
        name: 'Click Power',
        description: 'Increase coins per click by 10%',
        cost: 100,
        clickPowerBoost: 10,
      ),
      Upgrade(
        name: 'Growth Boost',
        description: 'Increase growth per click by 5%',
        cost: 200,
        growthPerClickBoost: 0.05,
      ),
      Upgrade(
        name: 'Lucky Touch',
        description: '10% chance to earn 2–5x coins per click',
        cost: 500,
      ),
      Upgrade(
        name: 'Combo Clicker',
        description: 'Click 5 times in a row to trigger x2 coins for 10s',
        cost: 1000,
      ),
      Upgrade(
        name: 'Mega Click',
        description: 'Each click gives +20% coins and growth',
        cost: 3000,
        clickPowerBoost: 20,
        growthPerClickBoost: 0.10,
      ),
      Upgrade(
        name: 'Critical Click',
        description: 'Small chance for a critical click (x5 coins)',
        cost: 5000,
      ),
    ];
  }

  static List<Upgrade> getIdleUpgrades() {
    return [
      Upgrade(
        name: 'Idle Growth Speed',
        description: 'Faster idle growth by 0.01%',
        cost: 300,
        idleRateBoost: 0.0001,
      ),
      Upgrade(
        name: 'Idle Coins',
        description: 'Automatically earn coins over time',
        cost: 800,
      ),
      Upgrade(
        name: 'Auto Collector',
        description: 'Add 1 auto-farmer that clicks for you',
        cost: 1500,
        autoFarmerBoost: 1,
      ),
      Upgrade(
        name: 'Auto Farmer Plus',
        description: 'Add 2 auto-farmers',
        cost: 4000,
        autoFarmerBoost: 2,
      ),
      Upgrade(
        name: 'Farm Robot',
        description: 'Add 5 auto-farmers for faster harvesting',
        cost: 10000,
        autoFarmerBoost: 5,
      ),
    ];
  }

  static List<Upgrade> getGlobalUpgrades() {
    return [
      Upgrade(
        name: 'Global Fertilizer',
        description: 'Increase all coin yields by 10%',
        cost: 5000,
        globalBonus: 10,
      ),
      Upgrade(
        name: 'Water System',
        description: 'Reduce growth time for all crops by 20%',
        cost: 10000,
      ),
      Upgrade(
        name: 'Sunlight Amplifier',
        description: 'Increase XP gain from harvesting by 25%',
        cost: 20000,
      ),
      Upgrade(
        name: 'Lucky Season',
        description: 'All clicks earn double coins for 60s',
        cost: 50000,
        durationBonus: 60,
      ),
      Upgrade(
        name: 'Farm Expansion',
        description: 'Unlock new crops earlier and increase max level by 2',
        cost: 100000,
      ),
      Upgrade(
        name: 'Golden Tools',
        description: 'All clicks +50% coins and +10% growth',
        cost: 150000,
        clickPowerBoost: 50,
        growthPerClickBoost: 0.10,
      ),
    ];
  }

  static List<Upgrade> getAvailableUpgrades() {
    return [
      Upgrade(name: 'Better Tools', description: 'Growth per click +2%', cost: 10, growthPerClickBoost: 0.02),
      Upgrade(name: 'Fertile Soil', description: 'Idle growth rate +0.05%', cost: 50, idleRateBoost: 0.0005),
      Upgrade(name: 'Super Fertile Soil', description: 'Idle growth rate +0.1%', cost: 200, idleRateBoost: 0.001),
      Upgrade(name: 'Sprinkler System', description: 'Add +0.5% growth per second idle bonus', cost: 500, idleRateBoost: 0.005),
      Upgrade(name: 'Advanced Auto-Farmer', description: 'Adds 3 auto-farmers', cost: 1000, autoFarmerBoost: 3),
      Upgrade(name: 'Plant Miracle', description: 'Every click has a chance to instantly grow 10%', cost: 2000, growthPerClickBoost: 0.10),
    ];
  }
}