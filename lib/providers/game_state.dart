import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/crop.dart';
import '../models/inventory.dart';
import '../models/player.dart';
import '../models/quest_manager.dart';
import '../services/upgrade_service.dart';
import '../services/crop_service.dart';

class Upgrade {
  final String name;
  final String description;
  final int cost;
  final double growthPerClickBoost;
  final double idleRateBoost;
  final int autoFarmerBoost;
  final int clickPowerBoost;
  final int globalBonus;
  final int durationBonus; // For temporary boosts like Lucky Season

  Upgrade({
    required this.name,
    required this.description,
    required this.cost,
    this.growthPerClickBoost = 0,
    this.idleRateBoost = 0,
    this.autoFarmerBoost = 0,
    this.clickPowerBoost = 0,
    this.globalBonus = 0,
    this.durationBonus = 0,
  });
}

class GameState extends ChangeNotifier {
  // === Core Resources ===
  int coins = 0;
  double growthProgress = 0.0; // 0.0 - 1.0
  double growthPerClick = 0.05; // 5% per click
  double idleRate = 0.001; // base 0.1% per second
  int autoFarmerCount = 0;

  List<Crop> _allLoadedCrops = []; // To store all crops loaded from JSON

  // === Crop & Level ===
  int currentCropIndex = 0;
  int currentCropLevel = 1;

  // This list will hold the actual Crop objects from _allLoadedCrops
  // that form the player's evolution path.
  List<Crop> cropEvolutionPath = [];

  // A flag to indicate if the game state has been initialized
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Loading status message
  String _loadingMessage = "Initializing...";
  String get loadingMessage => _loadingMessage;

  Crop get currentCrop {
    if (cropEvolutionPath.isEmpty) {
      // Return a default/placeholder crop if not yet loaded
      return const Crop(
        name: 'Loading...',
        emoji: '🌱',
        growthEmojis: ['🌱'],
        growthTime: Duration(seconds: 1),
        harvestYield: 0,
        seedCost: 0,
        unlockCost: 0,
        unlockLevel: 0,
        xpReward: 0,
      );
    }
    return cropEvolutionPath[currentCropIndex];
  }

  GrowthStage get currentGrowthStage {
    if (growthProgress < 0.2) return GrowthStage.seed;
    if (growthProgress < 0.4) return GrowthStage.sprout;
    if (growthProgress < 0.6) return GrowthStage.young;
    if (growthProgress < 0.8) return GrowthStage.mature;
    if (growthProgress < 1.0) return GrowthStage.flowering;
    return GrowthStage.fruiting;
  }

  bool get canHarvest => growthProgress >= 1.0;
  bool get canEvolve =>
      currentCropIndex < cropEvolutionPath.length - 1 &&
      coins >= cropEvolutionPath[currentCropIndex + 1].unlockCost;
  bool get canUpgrade =>
      currentCropLevel < currentCrop.maxLevel && coins >= getUpgradeCost();

  // === Player & Inventory ===
  Player player = Player();
  Inventory inventory = Inventory();
  QuestManager questManager = QuestManager();

  // === Prestige ===
  int seedsOfPower = 0;
  int prestigeCount = 0;
  int prestigeThreshold = 100000;
  double prestigeMultiplier = 1.0;

  // === Combo ===
  double comboMultiplier = 1.0;
  Timer? _comboTimer;
  int _comboClickCount = 0;
  DateTime? _lastClickTime;

  // === Timers ===
  Timer? _idleTimer;
  Timer? _autoFarmerTimer;

  // === Upgrades ===
  List<Upgrade> clickUpgrades = [];
  List<Upgrade> idleUpgrades = [];
  List<Upgrade> globalUpgrades = [];
  List<Upgrade> availableUpgrades = [];

  // === Achievements ===
  List<Achievement> achievements = [];
  bool hasNewAchievements = false;

  // === Visual Effects Flags ===
  bool showHarvestEffect = false;
  bool showPrestigeEffect = false;
  bool showUpgradeEffect = false;
  bool showEvolveEffect = false;


  GameState() {
    _initializeGameState();
  }

  Future<void> _initializeGameState() async {
    _loadingMessage = "Loading saved game...";
    notifyListeners();
    await loadGameState(); // Load saved state

    _loadingMessage = "Initializing upgrades...";
    notifyListeners();
    _initUpgrades();

    _loadingMessage = "Loading achievements...";
    notifyListeners();
    _initAchievements();

    _loadingMessage = "Starting game timers...";
    notifyListeners();
    _startIdleTimer();
    _startAutoFarmerTimer();

    _loadingMessage = "Done!";
    
    _isInitialized = true;
    // Final notification to switch screens
    notifyListeners();
  }

  Future<void> _loadAllCropsAndSetupEvolutionPath() async {
    _allLoadedCrops = await CropService.loadCropsFromJson();

    // Define multiple evolution paths for prestige
    final List<List<String>> evolutionPaths = [
      // Path 0: Basic crops
      [
        'Cỏ Non',
        'Lúa Mạch',
        'Cà Rốt',
        'Cà Chua',
        'Hoa Hướng Dương',
        'Cây Dâu Tây',
        'Cây Nấm',
        'Cây Bí Ma',
        'Cây Trúc Xanh',
        'Cây Âm Nhạc',
        'Cây Vàng',
      ],
      // Path 1: More advanced/rare crops after first prestige
      [
        'Cây Đậu',
        'Cây Ngô',
        'Cây Táo',
        'Cây Cam',
        'Cây Dưa Hấu',
        'Hoa Anh Đào',
        'Cây Hoa Sen',
        'Cây Linh Hồn',
        'Cây Ánh Sáng',
        'Cây Pha Lê',
        'Cây Thần Thoại',
      ],
      // Add more paths for subsequent prestiges if desired
    ];

    // Select the evolution path based on prestige count
    // Use modulo to loop back to the first path if prestige count exceeds available paths
    final List<String> desiredEvolutionNames = evolutionPaths[prestigeCount % evolutionPaths.length];

    // Populate cropEvolutionPath with actual Crop objects loaded from JSON
    cropEvolutionPath = desiredEvolutionNames.map((name) {
      return _allLoadedCrops.firstWhere(
        (crop) => crop.name == name,
        orElse: () {
          // Fallback if a crop name is not found in JSON (should not happen if JSON is complete)
          debugPrint('Warning: Crop "$name" not found in loaded JSON. Using default grass.');
          // Provide a minimal default Crop to prevent crash, or handle error appropriately
          return const Crop(
            name: 'Default Crop',
            emoji: '❓',
            growthEmojis: ['❓'],
            growthTime: Duration(seconds: 1),
            harvestYield: 1,
            seedCost: 1,
            unlockCost: 0,
            unlockLevel: 1,
            xpReward: 1,
          );
        },
      );
    }).toList();

    // Ensure the initial currentCropIndex is valid
    if (currentCropIndex >= cropEvolutionPath.length) {
      currentCropIndex = 0;
    }

    // Unlock the first crop in the inventory (e.g., "Cỏ Non")
    inventory.unlockCrop(cropEvolutionPath.first);
  }

  // === Core Methods ===
  void click() {
    _incrementGrowth(growthPerClick * comboMultiplier);
    _updateAchievementProgress('total_clicks', 1);
    _handleCombo();
  }

  void harvest() {
    if (!canHarvest) return;
    int coinsEarned = (currentCrop.harvestYield * currentCropLevel).round();
    int xpEarned = (currentCrop.xpReward * currentCropLevel).round();
    coins += coinsEarned;
    player.addExperience(xpEarned);
    inventory.addHarvestedItem(currentCrop.name, currentCrop.harvestYield);
    questManager.updateProgress('harvest', 1);
    questManager.updateProgress('earn_coins', coinsEarned);
    _updateAchievementProgress('total_harvests', 1);
    _triggerHarvestEffect();
    growthProgress = 0.0;
    saveGameState();
    notifyListeners();
  }

  void evolveCrop() {
    if (!canEvolve) return;
    coins -= cropEvolutionPath[currentCropIndex + 1].unlockCost;
    currentCropIndex++;
    currentCropLevel = 1;
    _updateAchievementProgress('crops_evolved', 1);
    _triggerEvolveEffect();
    growthProgress = 0.0;
    saveGameState();
    notifyListeners();
  }

  void upgradeCrop() {
    if (!canUpgrade) return;
    coins -= getUpgradeCost();
    currentCropLevel++;
    growthPerClick += 0.01; // +1% per level
    idleRate += 0.0005; // +0.05% per level
    _updateAchievementProgress('upgrades_purchased', 1);
    saveGameState();
    notifyListeners();
  }

  int getUpgradeCost() {
    return (currentCrop.unlockCost ~/ 10) * currentCropLevel;
  }

  void buyUpgrade(Upgrade upgrade) {
    if (coins < upgrade.cost) return;
    coins -= upgrade.cost;
    growthPerClick += upgrade.growthPerClickBoost;
    idleRate += upgrade.idleRateBoost;
    autoFarmerCount += upgrade.autoFarmerBoost;
    // Apply more effects if needed
    _updateAchievementProgress('upgrades_purchased', 1);
    _triggerUpgradeEffect();
    saveGameState();
    notifyListeners();
  }

  void selectCrop(Crop crop) {
    if (!inventory.unlockedCrops.contains(crop) || !cropEvolutionPath.contains(crop)) return; // Check if it's in evolution path
    currentCropIndex = cropEvolutionPath.indexOf(crop);
    currentCropLevel = 1;
    growthProgress = 0.0;
    saveGameState();
    notifyListeners();
  }

  // === Prestige ===
  bool get canPrestige => coins >= prestigeThreshold;

  void prestige() {
    if (!canPrestige) return;
    int seedsGained = (coins ~/ 10000).clamp(1, 100);
    seedsOfPower += seedsGained;
    prestigeMultiplier += seedsGained * 0.02;
    prestigeCount++;
    prestigeThreshold += prestigeCount * 50000;
    _triggerPrestigeEffect();

    // Reset core stats
    coins = 0;
    growthProgress = 0.0;
    currentCropIndex = 0;
    currentCropLevel = 1;
    growthPerClick = 0.05 * prestigeMultiplier; // Base value with prestige bonus
    idleRate = 0.001 * prestigeMultiplier; // Base value with prestige bonus
    autoFarmerCount = 0;
    comboMultiplier = 1.0;
    inventory = Inventory();

    // Reload the new evolution path and reset upgrades
    _initializeGameState(); // This will re-run the setup with the new prestigeCount

    saveGameState(); // Save the new prestige state
    notifyListeners();
  }

  // === Internal Helpers ===
  void _incrementGrowth(double amount) {
    growthProgress += amount;
    if (growthProgress > 1.0) growthProgress = 1.0;
    notifyListeners();
  }

  void _handleCombo() {
    final now = DateTime.now();
    if (_lastClickTime != null && now.difference(_lastClickTime!).inSeconds < 2) {
      _comboClickCount++;
      if (_comboClickCount >= 5) {
        comboMultiplier = 2.0;
        _comboTimer?.cancel();
        _comboTimer = Timer(const Duration(seconds: 10), () {
          comboMultiplier = 1.0;
          _comboClickCount = 0;
          notifyListeners();
        });
      }
    } else {
      _comboClickCount = 1;
    }
    _lastClickTime = now;
  }

  void _startIdleTimer() {
    _idleTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) => _incrementGrowth(idleRate * comboMultiplier));
  }

  void _startAutoFarmerTimer() {
    _autoFarmerTimer =
        Timer.periodic(const Duration(seconds: 1), (_) {
      if (autoFarmerCount > 0) {
        _incrementGrowth(autoFarmerCount * 0.01 * comboMultiplier);
      }
    });
  }

void _initUpgrades() {
  clickUpgrades = UpgradeService.getClickUpgrades();
  idleUpgrades = UpgradeService.getIdleUpgrades();
  globalUpgrades = UpgradeService.getGlobalUpgrades();
  availableUpgrades = UpgradeService.getAvailableUpgrades();
}

  void _initAchievements() {
    // Initialize a static list of achievements
    achievements = [
      Achievement(id: 'total_clicks', name: 'Clicker Trainee', description: 'Click 100 times.', icon: '👆', goal: 100),
      Achievement(id: 'total_clicks_2', name: 'Clicker Adept', description: 'Click 1,000 times.', icon: '👍', goal: 1000),
      Achievement(id: 'total_harvests', name: 'First Harvest', description: 'Harvest 10 crops.', icon: '🌾', goal: 10),
      Achievement(id: 'total_harvests_2', name: 'Seasoned Farmer', description: 'Harvest 100 crops.', icon: '🚜', goal: 100),
      Achievement(id: 'upgrades_purchased', name: 'Upgrader', description: 'Buy 5 upgrades.', icon: '🔧', goal: 5),
      Achievement(id: 'upgrades_purchased_2', name: 'Enhancement Expert', description: 'Buy 25 upgrades.', icon: '🛠️', goal: 25),
      Achievement(id: 'crops_evolved', name: 'Evolutionist', description: 'Evolve a crop for the first time.', icon: '🧬', goal: 1),
    ];
    // TODO: Load saved achievement progress
  }

  void _updateAchievementProgress(String id, int amount) {
    for (var achievement in achievements) {
      // Find all achievements that match the ID prefix
      if (achievement.id.startsWith(id) && !achievement.isUnlocked) {
        achievement.currentProgress += amount;
        if (achievement.currentProgress >= achievement.goal) {
          if (!achievement.isUnlocked) {
            hasNewAchievements = true; // Set flag for new achievement
          }
          achievement.isUnlocked = true;
          // TODO: Show a notification for unlocked achievement
        }
      }
    }
    notifyListeners();
  }

  void clearNewAchievementsFlag() {
    hasNewAchievements = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _autoFarmerTimer?.cancel();
    _comboTimer?.cancel();
    super.dispose();
  }

  // === Save & Load Game State ===
  Future<void> saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', coins);
    await prefs.setDouble('growthProgress', growthProgress);
    await prefs.setDouble('growthPerClick', growthPerClick);
    await prefs.setDouble('idleRate', idleRate);
    await prefs.setInt('autoFarmerCount', autoFarmerCount);
    await prefs.setInt('currentCropIndex', currentCropIndex);
    await prefs.setInt('currentCropLevel', currentCropLevel);
    await prefs.setInt('playerLevel', player.level);
    await prefs.setInt('playerExperience', player.experience);
    await prefs.setInt('seedsOfPower', seedsOfPower);
    await prefs.setInt('prestigeCount', prestigeCount);
    await prefs.setDouble('prestigeMultiplier', prestigeMultiplier);
    await prefs.setInt('prestigeThreshold', prestigeThreshold);
    // Note: Saving complex objects like inventory and purchased upgrades would require serialization (e.g., to JSON).
    // This is a simplified version for now.
    debugPrint("Game state saved!");
  }

  Future<void> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    coins = prefs.getInt('coins') ?? 0;
    growthProgress = prefs.getDouble('growthProgress') ?? 0.0;
    // For prestige-affected stats, load the base and apply multiplier
    growthPerClick = prefs.getDouble('growthPerClick') ?? 0.05;
    idleRate = prefs.getDouble('idleRate') ?? 0.001;
    autoFarmerCount = prefs.getInt('autoFarmerCount') ?? 0;
    currentCropIndex = prefs.getInt('currentCropIndex') ?? 0;
    currentCropLevel = prefs.getInt('currentCropLevel') ?? 1;
    player.level = prefs.getInt('playerLevel') ?? 1;
    player.experience = prefs.getInt('playerExperience') ?? 0;
    player.experienceToNextLevel = player.level * 100; // Recalculate
    seedsOfPower = prefs.getInt('seedsOfPower') ?? 0;
    prestigeCount = prefs.getInt('prestigeCount') ?? 0;
    prestigeMultiplier = prefs.getDouble('prestigeMultiplier') ?? 1.0;
    prestigeThreshold = prefs.getInt('prestigeThreshold') ?? 100000;

    // After loading prestige count, we need to reload the correct crop path
    await _loadAllCropsAndSetupEvolutionPath();
    debugPrint("Game state loaded! Prestige count: $prestigeCount");
  }

  // === Effect Triggers ===
  void _triggerHarvestEffect() {
    showHarvestEffect = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1500), () {
      showHarvestEffect = false;
      notifyListeners();
    });
  }

  void _triggerPrestigeEffect() {
    showPrestigeEffect = true;
    notifyListeners();
    // This effect can be dismissed by the user or a timer in the UI
  }

  void _triggerUpgradeEffect() {
    showUpgradeEffect = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1200), () {
      showUpgradeEffect = false;
      notifyListeners();
    });
  }

  void _triggerEvolveEffect() {
    showEvolveEffect = true;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1500), () {
      showEvolveEffect = false;
      notifyListeners();
    });
  }
}
