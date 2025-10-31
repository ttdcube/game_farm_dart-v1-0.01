import 'crop.dart';

class Inventory {
  final Map<Crop, int> _seeds = {};
  final Map<String, int> _harvestedItems = {};
  int _coins = 100; // Starting coins
  final Set<Crop> _unlockedCrops = {Crop.grass}; // Start with grass unlocked

  // --- Seed management ---
  void addSeeds(Crop crop, int amount) {
    if (amount <= 0) return;
    _seeds[crop] = (_seeds[crop] ?? 0) + amount;
  }

  bool removeSeeds(Crop crop, int amount) {
    if ((_seeds[crop] ?? 0) >= amount && amount > 0) {
      _seeds[crop] = _seeds[crop]! - amount;
      if (_seeds[crop] == 0) _seeds.remove(crop);
      return true;
    }
    return false;
  }

  int getSeedCount(Crop crop) => _seeds[crop] ?? 0;

  Map<Crop, int> get seeds => Map.unmodifiable(_seeds);

  // --- Harvested items management ---
  void addHarvestedItem(String item, int amount) {
    if (amount <= 0) return;
    _harvestedItems[item] = (_harvestedItems[item] ?? 0) + amount;
  }

  bool removeHarvestedItem(String item, int amount) {
    if ((_harvestedItems[item] ?? 0) >= amount && amount > 0) {
      _harvestedItems[item] = _harvestedItems[item]! - amount;
      if (_harvestedItems[item] == 0) _harvestedItems.remove(item);
      return true;
    }
    return false;
  }

  int getHarvestedItemCount(String item) => _harvestedItems[item] ?? 0;

  Map<String, int> get harvestedItems => Map.unmodifiable(_harvestedItems);

  // --- Coin management ---
  int get coins => _coins;

  void addCoins(int amount) {
    if (amount <= 0) return;
    _coins += amount;
  }

  bool spendCoins(int amount) {
    if (_coins >= amount && amount > 0) {
      _coins -= amount;
      return true;
    }
    return false;
  }

  // --- Crop unlocking ---
  bool canUnlockCrop(Crop crop) =>
      !_unlockedCrops.contains(crop) && _coins >= crop.unlockCost;

  bool unlockCrop(Crop crop) {
    if (canUnlockCrop(crop)) {
      spendCoins(crop.unlockCost);
      _unlockedCrops.add(crop);
      return true;
    }
    return false;
  }

  Set<Crop> get unlockedCrops => Set.unmodifiable(_unlockedCrops);

  List<Crop> get availableCrops => unlockedCrops.toList();
}
