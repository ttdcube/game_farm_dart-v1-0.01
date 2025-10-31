enum GrowthStage { seed, sprout, young, mature, flowering, fruiting }

enum CropRarity { common, rare, epic, legendary, event }

enum TimeOfDay { day, night }

enum Weather { sunny, rainy, snowy, windy }

enum EmotionState { happy, normal, sad, tired, angry, ecstatic }

enum PlantBehavior { idle, shaking, glowing, wilting, sparkling, sleeping }

class Crop {
  final String name;
  final String emoji;
  final List<String> growthEmojis; // Different emojis for each growth stage
  final Duration growthTime;
  final int harvestYield;
  final int seedCost;
  final int unlockCost; // Cost in coins to unlock
  final int unlockLevel; // Player level required to unlock
  final int xpReward; // XP gained per harvest
  final int waterNeeded; // Water units needed per growth cycle
  final int fertilizerNeeded; // Fertilizer units needed per growth cycle
  final CropRarity rarity;
  final String? specialEffect; // Description of special effect
  final String? unlockMethod; // How to unlock (e.g., 'quest', 'season', 'achievement')
  final int maxLevel; // Maximum level for upgrades
  final Map<String, dynamic> upgradeRequirements; // Requirements for each level upgrade
  final List<String> environmentalEffects; // Effects based on time/weather
  final Map<String, String> levelEmojis; // Different emojis per level
  final int affinity; // Current affinity level (0-10)
  final int currentLevel; // Current upgrade level (1-10)
  final int durability; // New: Durability of the crop
  final int sellingValue; // New: Base selling value of the crop
  final Map<String, int> upgradeItemRequirements; // New: Items needed for upgrade
  final EmotionState currentEmotion; // Current emotional state
  final PlantBehavior currentBehavior; // Current behavior
  final DateTime? lastInteraction; // Last time player interacted
  final int interactionCount; // Total interactions
  final Map<String, int> careHistory; // History of care actions

  const Crop({
    required this.name,
    required this.emoji,
    required this.growthEmojis,
    required this.growthTime,
    required this.harvestYield,
    required this.seedCost,
    required this.unlockCost,
    required this.unlockLevel,
    required this.xpReward,
    this.waterNeeded = 3,
    this.fertilizerNeeded = 2,
    this.rarity = CropRarity.common,
    this.specialEffect,
    this.unlockMethod,
    this.maxLevel = 10,
    this.upgradeRequirements = const {},
    this.environmentalEffects = const [],
    this.levelEmojis = const {},
    this.affinity = 0,
    this.currentLevel = 1,
    this.durability = 100, // Default durability
    this.sellingValue = 10, // Default selling value
    this.upgradeItemRequirements = const {}, // Default empty
    this.currentEmotion = EmotionState.normal,
    this.currentBehavior = PlantBehavior.idle,
    this.lastInteraction,
    this.interactionCount = 0,
    this.careHistory = const {},
  });

  String getEmojiForStage(GrowthStage stage) {
    if (growthEmojis.length > stage.index) {
      return growthEmojis[stage.index];
    }
    return emoji;
  }

  Map<String, dynamic> getUpgradedStats(int level) {
    // This is a placeholder for dynamic stat calculation based on level
    // In a real game, you would have more complex logic here.
    return {
      'growthTime': (growthTime.inSeconds * (1 - level * 0.05)).round(), // 5% faster per level
      'harvestYield': harvestYield + level, // +1 yield per level
      'xpReward': xpReward + (level * 2), // +2 XP per level
      'durability': durability + (level * 10), // +10 durability per level
      'sellingValue': sellingValue + (level * 5), // +5 selling value per level
    };
  }

  // Emotion and behavior methods
  EmotionState calculateEmotion(DateTime? lastWatered, DateTime? lastFertilized, DateTime? lastTalked, int careScore) {
    if (careScore >= 10) return EmotionState.ecstatic;
    if (lastWatered == null || lastFertilized == null) return EmotionState.sad;
    final now = DateTime.now();
    final hoursSinceWater = now.difference(lastWatered).inHours;
    final hoursSinceFertilize = now.difference(lastFertilized).inHours;
    final hoursSinceTalk = lastTalked != null ? now.difference(lastTalked).inHours : 24;

    if (hoursSinceWater > 24 || hoursSinceFertilize > 48) return EmotionState.angry;
    if (hoursSinceTalk > 12) return EmotionState.tired;
    if (hoursSinceWater > 6 || hoursSinceFertilize > 12) return EmotionState.sad;
    return EmotionState.happy;
  }

  PlantBehavior getBehaviorForEmotion(EmotionState emotion) {
    switch (emotion) {
      case EmotionState.happy:
        return PlantBehavior.shaking;
      case EmotionState.sad:
        return PlantBehavior.wilting;
      case EmotionState.tired:
        return PlantBehavior.sleeping;
      case EmotionState.angry:
        return PlantBehavior.wilting;
      case EmotionState.ecstatic:
        return PlantBehavior.sparkling;
      default:
        return PlantBehavior.idle;
    }
  }

  String getEmotionEmoji(EmotionState emotion) {
    switch (emotion) {
      case EmotionState.happy:
        return '😁';
      case EmotionState.normal:
        return '😐';
      case EmotionState.sad:
        return '😢';
      case EmotionState.tired:
        return '😴';
      case EmotionState.angry:
        return '😡';
      case EmotionState.ecstatic:
        return '✨';
    }
  }

  void updateAffinity(int change) {
    // Affinity logic would be implemented here
    // For now, it's a placeholder
  }

  bool canEvolve(int currentLevel) {
    return currentLevel < maxLevel;
  }

  Crop evolve(int newLevel) {
    // Return a new Crop instance with updated stats
    // This is a simplified version
    return copyWith(currentLevel: newLevel);
  }

  Crop copyWith({
    String? name,
    String? emoji,
    List<String>? growthEmojis,
    Duration? growthTime,
    int? harvestYield,
    int? seedCost,
    int? unlockCost,
    int? unlockLevel,
    int? xpReward,
    int? waterNeeded,
    int? fertilizerNeeded,
    CropRarity? rarity,
    String? specialEffect,
    String? unlockMethod,
    int? maxLevel,
    Map<String, dynamic>? upgradeRequirements,
    List<String>? environmentalEffects,
    Map<String, String>? levelEmojis,
    int? affinity,
    int? currentLevel,
    int? durability,
    int? sellingValue,
    Map<String, int>? upgradeItemRequirements,
    EmotionState? currentEmotion,
    PlantBehavior? currentBehavior,
    DateTime? lastInteraction,
    int? interactionCount,
    Map<String, int>? careHistory,
  }) {
    return Crop(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      growthEmojis: growthEmojis ?? this.growthEmojis,
      growthTime: growthTime ?? this.growthTime,
      harvestYield: harvestYield ?? this.harvestYield,
      seedCost: seedCost ?? this.seedCost,
      unlockCost: unlockCost ?? this.unlockCost,
      unlockLevel: unlockLevel ?? this.unlockLevel,
      xpReward: xpReward ?? this.xpReward,
      waterNeeded: waterNeeded ?? this.waterNeeded,
      fertilizerNeeded: fertilizerNeeded ?? this.fertilizerNeeded,
      rarity: rarity ?? this.rarity,
      specialEffect: specialEffect ?? this.specialEffect,
      unlockMethod: unlockMethod ?? this.unlockMethod,
      maxLevel: maxLevel ?? this.maxLevel,
      upgradeRequirements: upgradeRequirements ?? this.upgradeRequirements,
      environmentalEffects: environmentalEffects ?? this.environmentalEffects,
      levelEmojis: levelEmojis ?? this.levelEmojis,
      affinity: affinity ?? this.affinity,
      currentLevel: currentLevel ?? this.currentLevel,
      durability: durability ?? this.durability,
      sellingValue: sellingValue ?? this.sellingValue,
      upgradeItemRequirements: upgradeItemRequirements ?? this.upgradeItemRequirements,
      currentEmotion: currentEmotion ?? this.currentEmotion,
      currentBehavior: currentBehavior ?? this.currentBehavior,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      interactionCount: interactionCount ?? this.interactionCount,
      careHistory: careHistory ?? this.careHistory,
    );
  }

  static const Crop grass = Crop(
    name: 'Grass',
    emoji: '🌱',
    growthEmojis: ['🌱', '🌿', '🌾', '🌾'],
    growthTime: Duration(seconds: 5), // Quick growth for starting crop
    harvestYield: 2,
    seedCost: 1,
    unlockCost: 0, // Already unlocked
    unlockLevel: 1,
    xpReward: 5,
    durability: 80,
    sellingValue: 5,
  );

  static const Crop wheat = Crop(
    name: 'Wheat',
    emoji: '🌾',
    growthEmojis: ['🌱', '🌿', '🌾', '🌾'],
    growthTime: Duration(seconds: 10),
    harvestYield: 5,
    seedCost: 2,
    unlockCost: 10,
    unlockLevel: 2,
    xpReward: 10,
    durability: 100,
    sellingValue: 10,
  );

  static const Crop carrot = Crop(
    name: 'Carrot',
    emoji: '🥕',
    growthEmojis: ['🌱', '🌿', '🥕', '🥕'],
    growthTime: Duration(seconds: 15),
    harvestYield: 3,
    seedCost: 3,
    unlockCost: 20,
    unlockLevel: 3,
    xpReward: 15,
    durability: 90,
    sellingValue: 12,
  );

  static const Crop tomato = Crop(
    name: 'Tomato',
    emoji: '🍅',
    growthEmojis: ['🌱', '🌿', '🍅', '🍅'],
    growthTime: Duration(seconds: 20),
    harvestYield: 4,
    seedCost: 5,
    unlockCost: 30,
    unlockLevel: 4,
    xpReward: 20,
    durability: 70,
    sellingValue: 15,
  );

  static const Crop sunflower = Crop(
    name: 'Sunflower',
    emoji: '🌻',
    growthEmojis: ['🌱', '🌿', '🌻', '🌻'],
    growthTime: Duration(seconds: 25),
    harvestYield: 6,
    seedCost: 4,
    unlockCost: 50,
    unlockLevel: 5,
    xpReward: 25,
    durability: 110,
    sellingValue: 18,
  );

  static const Crop strawberry = Crop(
    name: 'Strawberry',
    emoji: '🍓',
    growthEmojis: ['🌱', '🌿', '🍓', '🍓'],
    growthTime: Duration(seconds: 30),
    harvestYield: 8,
    seedCost: 6,
    unlockCost: 80,
    unlockLevel: 6,
    xpReward: 30,
    durability: 85,
    sellingValue: 20,
  );

  static const Crop mushroom = Crop(
    name: 'Mushroom',
    emoji: '🍄',
    growthEmojis: ['🌱', '🍄', '🍄', '🍄'],
    growthTime: Duration(seconds: 35),
    harvestYield: 4,
    seedCost: 8,
    unlockCost: 120,
    unlockLevel: 8,
    xpReward: 40,
    durability: 60,
    sellingValue: 25,
  );

  static const Crop pumpkin = Crop(
    name: 'Pumpkin',
    emoji: '🎃',
    growthEmojis: ['🌱', '🌿', '🎃', '🎃'],
    growthTime: Duration(seconds: 45),
    harvestYield: 12,
    seedCost: 10,
    unlockCost: 180,
    unlockLevel: 10,
    xpReward: 60,
    durability: 120,
    sellingValue: 30,
  );

  static const Crop ancientTree = Crop(
    name: 'Ancient Tree',
    emoji: '🌳',
    growthEmojis: ['🌱', '🌿', '🌳', '🌳'],
    growthTime: Duration(seconds: 60),
    harvestYield: 10,
    seedCost: 15,
    unlockCost: 250,
    unlockLevel: 12,
    xpReward: 70,
    durability: 150,
    sellingValue: 40,
  );

  static const Crop magicTree = Crop(
    name: 'Magic Tree',
    emoji: '🌲✨',
    growthEmojis: ['🌱', '🌿', '🌲✨', '🌲✨'],
    growthTime: Duration(seconds: 90),
    harvestYield: 15,
    seedCost: 25,
    unlockCost: 500,
    unlockLevel: 15,
    xpReward: 100,
    durability: 180,
    sellingValue: 50,
  );

  static const Crop goldenApple = Crop(
    name: 'Golden Apple',
    emoji: '🍎✨',
    growthEmojis: ['🌱', '🌿', '🍎✨', '🍎✨'],
    growthTime: Duration(seconds: 120),
    harvestYield: 20,
    seedCost: 50,
    unlockCost: 1000,
    unlockLevel: 20,
    xpReward: 200,
    durability: 200,
    sellingValue: 100,
  );

  // 🌱 I. CÂY THƯỜNG (Common Plants)
  static const Crop coNon = Crop(
    name: 'Cỏ Non',
    emoji: '🌿',
    growthEmojis: ['🌱', '🌿', '🌾', '🌾'],
    growthTime: Duration(seconds: 5),
    harvestYield: 2,
    seedCost: 1,
    unlockCost: 0,
    unlockLevel: 1,
    xpReward: 5,
    rarity: CropRarity.common,
    specialEffect: 'Tăng tốc phát triển 50% mỗi cấp',
    durability: 80,
    sellingValue: 5,
  );

  static const Crop cayDau = Crop(
    name: 'Cây Đậu',
    emoji: '🌱',
    growthEmojis: ['🌱', '🌿', '🌱', '🌱'],
    growthTime: Duration(seconds: 8),
    harvestYield: 3,
    seedCost: 2,
    unlockCost: 10,
    unlockLevel: 2,
    xpReward: 8,
    rarity: CropRarity.common,
    specialEffect: '+1 hạt mỗi 2 cấp',
    durability: 90,
    sellingValue: 8,
  );

  static const Crop hoaHuongDuong = Crop(
    name: 'Hoa Hướng Dương',
    emoji: '🌻',
    growthEmojis: ['🌱', '🌿', '🌻', '🌻'],
    growthTime: Duration(seconds: 12),
    harvestYield: 4,
    seedCost: 3,
    unlockCost: 20,
    unlockLevel: 3,
    xpReward: 12,
    rarity: CropRarity.common,
    specialEffect: 'Tăng XP và tiền khi thu hoạch, phát sáng khi đạt Lv.10',
    durability: 100,
    sellingValue: 10,
  );

  static const Crop cayNgo = Crop(
    name: 'Cây Ngô',
    emoji: '🌽',
    growthEmojis: ['🌱', '🌿', '🌽', '🌽'],
    growthTime: Duration(seconds: 15),
    harvestYield: 5,
    seedCost: 4,
    unlockCost: 30,
    unlockLevel: 4,
    xpReward: 15,
    rarity: CropRarity.common,
    specialEffect: 'Sản lượng ổn định, giảm thời gian phát triển',
    durability: 110,
    sellingValue: 12,
  );

  static const Crop caChua = Crop(
    name: 'Cà Chua',
    emoji: '🍅',
    growthEmojis: ['🌱', '🌿', '🍅', '🍅'],
    growthTime: Duration(seconds: 18),
    harvestYield: 6,
    seedCost: 5,
    unlockCost: 40,
    unlockLevel: 5,
    xpReward: 18,
    rarity: CropRarity.common,
    specialEffect: 'Nhiều sản lượng, dễ héo, quả to gấp đôi khi đạt Lv.10',
    durability: 95,
    sellingValue: 15,
  );

  static const Crop xuongRong = Crop(
    name: 'Xương Rồng',
    emoji: '🌵',
    growthEmojis: ['🌱', '🌵', '🌵', '🌵'],
    growthTime: Duration(seconds: 20),
    harvestYield: 3,
    seedCost: 6,
    unlockCost: 50,
    unlockLevel: 6,
    xpReward: 20,
    waterNeeded: 0, // Không cần tưới
    rarity: CropRarity.common,
    specialEffect: 'Không cần tưới, +50% sức bền ở cấp cao',
    unlockMethod: 'region',
    durability: 120,
    sellingValue: 18,
  );

  static const Crop cayNam = Crop(
    name: 'Cây Nấm',
    emoji: '🍄',
    growthEmojis: ['🌱', '🍄', '🍄', '🍄'],
    growthTime: Duration(seconds: 25),
    harvestYield: 4,
    seedCost: 7,
    unlockCost: 60,
    unlockLevel: 7,
    xpReward: 25,
    rarity: CropRarity.common,
    specialEffect: 'Phát triển chậm, cho giá cao, càng chăm sóc đúng giờ càng hiếm',
    durability: 80,
    sellingValue: 20,
  );

  static const Crop caRot = Crop(
    name: 'Cà Rốt',
    emoji: '🥕',
    growthEmojis: ['🌱', '🌿', '🥕', '🥕'],
    growthTime: Duration(seconds: 14),
    harvestYield: 3,
    seedCost: 3,
    unlockCost: 25,
    unlockLevel: 3,
    xpReward: 14,
    rarity: CropRarity.common,
    specialEffect: 'Dễ trồng, xoay vòng nhanh, +20% giá bán ở cấp 10',
    unlockMethod: 'quest',
    durability: 90,
    sellingValue: 10,
  );

  static const Crop cayKhoaiTay = Crop(
    name: 'Cây Khoai Tây',
    emoji: '🥔',
    growthEmojis: ['🌱', '🌿', '🥔', '🥔'],
    growthTime: Duration(seconds: 22),
    harvestYield: 5,
    seedCost: 4,
    unlockCost: 35,
    unlockLevel: 4,
    xpReward: 22,
    rarity: CropRarity.common,
    specialEffect: 'Dành cho nông dân kiên trì, giảm 30% nguy cơ héo',
    durability: 105,
    sellingValue: 13,
  );

  static const Crop luaMach = Crop(
    name: 'Lúa Mạch',
    emoji: '🌾',
    growthEmojis: ['🌱', '🌿', '🌾', '🌾'],
    growthTime: Duration(seconds: 16),
    harvestYield: 4,
    seedCost: 3,
    unlockCost: 28,
    unlockLevel: 3,
    xpReward: 16,
    rarity: CropRarity.common,
    specialEffect: 'Dùng làm nguyên liệu chế biến, tăng XP khi trồng liên tiếp',
    durability: 98,
    sellingValue: 11,
  );

  // 🌸 II. CÂY HIẾM (Rare Plants)
  static const Crop cayDauTay = Crop(
    name: 'Cây Dâu Tây',
    emoji: '🍓',
    growthEmojis: ['🌱', '🌿', '🍓', '🍓'],
    growthTime: Duration(seconds: 28),
    harvestYield: 8,
    seedCost: 8,
    unlockCost: 100,
    unlockLevel: 8,
    xpReward: 35,
    rarity: CropRarity.rare,
    specialEffect: 'Cho nhiều quả, giá cao, quả đổi màu vàng ở Lv.10 ✨',
    unlockMethod: 'quest',
    durability: 100,
    sellingValue: 25,
  );

  static const Crop cayDuaHau = Crop(
    name: 'Cây Dưa Hấu',
    emoji: '🍉',
    growthEmojis: ['🌱', '🌿', '🍉', '🍉'],
    growthTime: Duration(seconds: 35),
    harvestYield: 10,
    seedCost: 10,
    unlockCost: 150,
    unlockLevel: 10,
    xpReward: 45,
    rarity: CropRarity.rare,
    specialEffect: 'Sản lượng cực lớn, nở hoa trước khi chín, tăng XP',
    unlockMethod: 'achievement',
    durability: 110,
    sellingValue: 30,
  );

  static const Crop cayCam = Crop(
    name: 'Cây Cam',
    emoji: '🍊',
    growthEmojis: ['🌱', '🌿', '🍊', '🍊'],
    growthTime: Duration(seconds: 40),
    harvestYield: 7,
    seedCost: 9,
    unlockCost: 120,
    unlockLevel: 9,
    xpReward: 40,
    rarity: CropRarity.rare,
    specialEffect: 'Cây lâu năm, +XP cho mỗi lần người chơi ghé thăm',
    unlockMethod: 'quest',
    durability: 130,
    sellingValue: 28,
  );

  static const Crop cayTao = Crop(
    name: 'Cây Táo',
    emoji: '🍎',
    growthEmojis: ['🌱', '🌿', '🍎', '🍎'],
    growthTime: Duration(seconds: 32),
    harvestYield: 6,
    seedCost: 7,
    unlockCost: 90,
    unlockLevel: 7,
    xpReward: 32,
    rarity: CropRarity.rare,
    specialEffect: 'Trung bình, dễ chăm, quả đổi màu đỏ đậm ở cấp 10',
    unlockMethod: 'level',
    durability: 120,
    sellingValue: 22,
  );

  static const Crop cayCaPhe = Crop(
    name: 'Cây Cà Phê',
    emoji: '☕',
    growthEmojis: ['🌱', '🌿', '☕', '☕'],
    growthTime: Duration(seconds: 38),
    harvestYield: 5,
    seedCost: 11,
    unlockCost: 160,
    unlockLevel: 11,
    xpReward: 50,
    rarity: CropRarity.rare,
    specialEffect: 'Phải chăm đều, tăng tốc độ phát triển cây xung quanh',
    unlockMethod: 'quest',
    durability: 105,
    sellingValue: 35,
  );

  static const Crop cayBacHa = Crop(
    name: 'Cây Bạc Hà',
    emoji: '🌿',
    growthEmojis: ['🌱', '🌿', '🌿', '🌿'],
    growthTime: Duration(seconds: 26),
    harvestYield: 4,
    seedCost: 6,
    unlockCost: 80,
    unlockLevel: 6,
    xpReward: 28,
    rarity: CropRarity.rare,
    specialEffect: 'Giảm mệt mỏi cho nông trại, làm mát khu vực xung quanh 🌬️',
    unlockMethod: 'achievement',
    durability: 90,
    sellingValue: 20,
  );

  static const Crop cayOaiHuong = Crop(
    name: 'Cây Oải Hương',
    emoji: '💜',
    growthEmojis: ['🌱', '🌿', '💜', '💜'],
    growthTime: Duration(seconds: 30),
    harvestYield: 5,
    seedCost: 8,
    unlockCost: 110,
    unlockLevel: 8,
    xpReward: 38,
    rarity: CropRarity.rare,
    specialEffect: 'Hương thơm, giá trị cao, tạo hiệu ứng gió tím khi thu hoạch',
    unlockMethod: 'season',
    durability: 95,
    sellingValue: 28,
  );

  static const Crop cayCucVang = Crop(
    name: 'Cây Cúc Vàng',
    emoji: '🌼',
    growthEmojis: ['🌱', '🌿', '🌼', '🌼'],
    growthTime: Duration(seconds: 24),
    harvestYield: 4,
    seedCost: 5,
    unlockCost: 70,
    unlockLevel: 5,
    xpReward: 26,
    rarity: CropRarity.rare,
    specialEffect: 'Dùng làm thuốc, phát sáng vào ban đêm',
    unlockMethod: 'quest',
    durability: 88,
    sellingValue: 23,
  );

  static const Crop cayLoHoi = Crop(
    name: 'Cây Lô Hội (Aloe Vera)',
    emoji: '🪴',
    growthEmojis: ['🌱', '🪴', '🪴', '🪴'],
    growthTime: Duration(seconds: 20),
    harvestYield: 3,
    seedCost: 4,
    unlockCost: 60,
    unlockLevel: 4,
    xpReward: 24,
    rarity: CropRarity.rare,
    specialEffect: 'Hồi phục sức khỏe cho cây khác, tự động chữa "bệnh cây" xung quanh',
    unlockMethod: 'achievement',
    durability: 115,
    sellingValue: 20,
  );

  static const Crop cayDua = Crop(
    name: 'Cây Dứa',
    emoji: '🍍',
    growthEmojis: ['🌱', '🌿', '🍍', '🍍'],
    growthTime: Duration(seconds: 36),
    harvestYield: 9,
    seedCost: 9,
    unlockCost: 130,
    unlockLevel: 9,
    xpReward: 42,
    rarity: CropRarity.rare,
    specialEffect: 'Cứng, năng suất cao, giảm thời gian chờ giữa 2 vụ',
    unlockMethod: 'level',
    durability: 125,
    sellingValue: 32,
  );

  // 🌳 III. CÂY CAO CẤP / HUYỀN THOẠI (Epic & Legendary Plants)
  static const Crop hoaAnhDao = Crop(
    name: 'Hoa Anh Đào',
    emoji: '🌸',
    growthEmojis: ['🌱', '🌿', '🌸', '🌸'],
    growthTime: Duration(seconds: 50),
    harvestYield: 12,
    seedCost: 15,
    unlockCost: 300,
    unlockLevel: 15,
    xpReward: 80,
    rarity: CropRarity.epic,
    specialEffect: 'Nở đẹp, giá bán cao, cánh hoa rơi khi người chơi chạm',
    unlockMethod: 'region',
    durability: 130,
    sellingValue: 45,
  );

  static const Crop cayHoaSen = Crop(
    name: 'Cây Hoa Sen',
    emoji: '🪷',
    growthEmojis: ['🌱', '🪷', '🪷', '🪷'],
    growthTime: Duration(seconds: 45),
    harvestYield: 10,
    seedCost: 12,
    unlockCost: 250,
    unlockLevel: 12,
    xpReward: 70,
    rarity: CropRarity.epic,
    specialEffect: 'Thanh tịnh, hiếm, giảm 50% nguy cơ sâu bệnh',
    unlockMethod: 'achievement',
    durability: 140,
    sellingValue: 40,
  );

  static const Crop cayTrucXanh = Crop(
    name: 'Cây Trúc Xanh',
    emoji: '🎋',
    growthEmojis: ['🌱', '🎋', '🎋', '🎋'],
    growthTime: Duration(seconds: 55),
    harvestYield: 8,
    seedCost: 14,
    unlockCost: 280,
    unlockLevel: 14,
    xpReward: 75,
    rarity: CropRarity.epic,
    specialEffect: 'May mắn & sinh trưởng ổn định, tăng tiền khi trồng gần nước 💧',
    unlockMethod: 'quest',
    durability: 150,
    sellingValue: 38,
  );

  static const Crop cayLinhHon = Crop(
    name: 'Cây Linh Hồn',
    emoji: '🔮',
    growthEmojis: ['🌱', '🔮', '🔮', '🔮'],
    growthTime: Duration(seconds: 60),
    harvestYield: 15,
    seedCost: 20,
    unlockCost: 400,
    unlockLevel: 18,
    xpReward: 100,
    rarity: CropRarity.legendary,
    specialEffect: 'Hấp thụ năng lượng môi trường, phát sáng theo nhịp tim người chơi',
    unlockMethod: 'secret',
    durability: 180,
    sellingValue: 60,
  );

  static const Crop cayAnhSang = Crop(
    name: 'Cây Ánh Sáng',
    emoji: '🌞',
    growthEmojis: ['🌱', '🌞', '🌞', '🌞'],
    growthTime: Duration(seconds: 65),
    harvestYield: 18,
    seedCost: 25,
    unlockCost: 500,
    unlockLevel: 20,
    xpReward: 120,
    rarity: CropRarity.legendary,
    specialEffect: 'Chỉ nở khi ban ngày, tăng năng suất toàn vườn 10%',
    unlockMethod: 'season',
    durability: 190,
    sellingValue: 70,
  );

  static const Crop cayMatTrang = Crop(
    name: 'Cây Mặt Trăng',
    emoji: '🌕',
    growthEmojis: ['🌱', '🌕', '🌕', '🌕'],
    growthTime: Duration(seconds: 70),
    harvestYield: 20,
    seedCost: 30,
    unlockCost: 600,
    unlockLevel: 22,
    xpReward: 140,
    rarity: CropRarity.legendary,
    specialEffect: 'Nở khi đêm xuống, giảm thời gian phát triển ban đêm',
    unlockMethod: 'season',
    durability: 200,
    sellingValue: 80,
  );

  static const Crop cayPhaLe = Crop(
    name: 'Cây Pha Lê',
    emoji: '💎',
    growthEmojis: ['🌱', '💎', '💎', '💎'],
    growthTime: Duration(seconds: 75),
    harvestYield: 25,
    seedCost: 35,
    unlockCost: 700,
    unlockLevel: 25,
    xpReward: 160,
    rarity: CropRarity.legendary,
    specialEffect: 'Cây trong suốt, cực hiếm, tăng tốc toàn bộ cây xung quanh',
    unlockMethod: 'achievement',
    durability: 220,
    sellingValue: 90,
  );

  static const Crop cayVang = Crop(
    name: 'Cây Vàng',
    emoji: '🌟',
    growthEmojis: ['🌱', '🌟', '🌟', '🌟'],
    growthTime: Duration(seconds: 80),
    harvestYield: 30,
    seedCost: 40,
    unlockCost: 800,
    unlockLevel: 28,
    xpReward: 180,
    rarity: CropRarity.legendary,
    specialEffect: 'Biểu tượng vinh dự, gấp 3 giá bán, có hiệu ứng ánh vàng',
    unlockMethod: 'achievement',
    durability: 250,
    sellingValue: 120,
  );

  static const Crop cayAmNhac = Crop(
    name: 'Cây Âm Nhạc',
    emoji: '🎵',
    growthEmojis: ['🌱', '🎵', '🎵', '🎵'],
    growthTime: Duration(seconds: 85),
    harvestYield: 22,
    seedCost: 28,
    unlockCost: 550,
    unlockLevel: 21,
    xpReward: 130,
    rarity: CropRarity.legendary,
    specialEffect: 'Phát nhạc khi nở, tăng hứng thú & XP khi nghe',
    unlockMethod: 'secret',
    durability: 170,
    sellingValue: 75,
  );

  static const Crop cayThanThoai = Crop(
    name: 'Cây Thần Thoại',
    emoji: '🪹',
    growthEmojis: ['🌱', '🪹', '🪹', '🪹'],
    growthTime: Duration(seconds: 90),
    harvestYield: 35,
    seedCost: 50,
    unlockCost: 1000,
    unlockLevel: 30,
    xpReward: 200,
    rarity: CropRarity.legendary,
    specialEffect: 'Duy nhất, có kỹ năng đặc biệt (ví dụ: hồi sinh cây héo 🌿)',
    unlockMethod: 'achievement',
    durability: 300,
    sellingValue: 150,
  );

  // 🎁 IV. CÂY SỰ KIỆN (Event Plants)
  static const Crop cayBiMa = Crop(
    name: 'Cây Bí Ma',
    emoji: '🎃',
    growthEmojis: ['🌱', '🎃', '🎃', '🎃'],
    growthTime: Duration(seconds: 40),
    harvestYield: 15,
    seedCost: 12,
    unlockCost: 200,
    unlockLevel: 10,
    xpReward: 60,
    rarity: CropRarity.event,
    specialEffect: 'Nở ra bí cười, phát sáng cam',
    unlockMethod: 'event',
    durability: 120,
    sellingValue: 35,
  );

  static const Crop cayThongNoel = Crop(
    name: 'Cây Thông Noel',
    emoji: '🎄',
    growthEmojis: ['🌱', '🎄', '🎄', '🎄'],
    growthTime: Duration(seconds: 50),
    harvestYield: 18,
    seedCost: 15,
    unlockCost: 250,
    unlockLevel: 12,
    xpReward: 75,
    rarity: CropRarity.event,
    specialEffect: 'Có hiệu ứng tuyết rơi, đèn nhấp nháy',
    unlockMethod: 'event',
    durability: 140,
    sellingValue: 40,
  );

  static const Crop cayDaoMai = Crop(
    name: 'Cây Đào / Mai',
    emoji: '🌸',
    growthEmojis: ['🌱', '🌸', '🌸', '🌸'],
    growthTime: Duration(seconds: 35),
    harvestYield: 12,
    seedCost: 10,
    unlockCost: 180,
    unlockLevel: 8,
    xpReward: 50,
    rarity: CropRarity.event,
    specialEffect: 'Nở đúng giao thừa, tặng xu đỏ 💰',
    unlockMethod: 'event',
    durability: 110,
    sellingValue: 30,
  );

  static const Crop cayTinhYeu = Crop(
    name: 'Cây Tình Yêu',
    emoji: '💕',
    growthEmojis: ['🌱', '💕', '💕', '💕'],
    growthTime: Duration(seconds: 30),
    harvestYield: 10,
    seedCost: 8,
    unlockCost: 150,
    unlockLevel: 6,
    xpReward: 40,
    rarity: CropRarity.event,
    specialEffect: 'Tăng XP khi chăm cùng người chơi khác',
    unlockMethod: 'event',
    durability: 100,
    sellingValue: 28,
  );

  static const Crop cayTraiDat = Crop(
    name: 'Cây Trái Đất',
    emoji: '🌎',
    growthEmojis: ['🌱', '🌎', '🌎', '🌎'],
    growthTime: Duration(seconds: 45),
    harvestYield: 14,
    seedCost: 11,
    unlockCost: 220,
    unlockLevel: 9,
    xpReward: 55,
    rarity: CropRarity.event,
    specialEffect: 'Giảm 20% thời gian phát triển cho mọi cây',
    unlockMethod: 'event',
    durability: 130,
    sellingValue: 38,
  );

  static const Crop cayBongDem = Crop(
    name: 'Cây Bóng Đêm',
    emoji: '🕯️',
    growthEmojis: ['🌱', '🕯️', '🕯️', '🕯️'],
    growthTime: Duration(seconds: 55),
    harvestYield: 16,
    seedCost: 13,
    unlockCost: 240,
    unlockLevel: 11,
    xpReward: 65,
    rarity: CropRarity.event,
    specialEffect: 'Nở ra khói tím, phát ra tiếng gió',
    unlockMethod: 'event',
    durability: 150,
    sellingValue: 42,
  );

  static const Crop cayCauVong = Crop(
    name: 'Cây Cầu Vồng',
    emoji: '🌈',
    growthEmojis: ['🌱', '🌈', '🌈', '🌈'],
    growthTime: Duration(seconds: 60),
    harvestYield: 20,
    seedCost: 18,
    unlockCost: 300,
    unlockLevel: 13,
    xpReward: 85,
    rarity: CropRarity.event,
    specialEffect: 'Đổi màu liên tục, hiệu ứng mưa ánh sáng',
    unlockMethod: 'event',
    durability: 160,
    sellingValue: 50,
  );

  static const Crop cayTuyet = Crop(
    name: 'Cây Tuyết',
    emoji: '❄️',
    growthEmojis: ['🌱', '❄️', '❄️', '❄️'],
    growthTime: Duration(seconds: 65),
    harvestYield: 22,
    seedCost: 20,
    unlockCost: 350,
    unlockLevel: 15,
    xpReward: 95,
    rarity: CropRarity.event,
    specialEffect: 'Phủ băng, phát sáng xanh dương',
    unlockMethod: 'event',
    durability: 170,
    sellingValue: 55,
  );

  static const Crop cayHong = Crop(
    name: 'Cây Hồng',
    emoji: '🌹',
    growthEmojis: ['🌱', '🌹', '🌹', '🌹'],
    growthTime: Duration(seconds: 40),
    harvestYield: 8,
    seedCost: 7,
    unlockCost: 120,
    unlockLevel: 7,
    xpReward: 35,
    rarity: CropRarity.event,
    specialEffect: 'Hoa hồng đỏ, tặng quà lãng mạn',
    unlockMethod: 'event',
    durability: 100,
    sellingValue: 28,
  );

  // Static crops for backward compatibility
  static const List<Crop> allCrops = [
    // Common
    coNon, cayDau, hoaHuongDuong, cayNgo, caChua, xuongRong, cayNam, caRot, cayKhoaiTay, luaMach,
    // Rare
    cayDauTay, cayDuaHau, cayCam, cayTao, cayCaPhe, cayBacHa, cayOaiHuong, cayCucVang, cayLoHoi, cayDua,
    // Epic/Legendary
    hoaAnhDao, cayHoaSen, cayTrucXanh, cayLinhHon, cayAnhSang, cayMatTrang, cayPhaLe, cayVang, cayAmNhac, cayThanThoai,
    // Event
    cayBiMa, cayThongNoel, cayDaoMai, cayTinhYeu, cayTraiDat, cayBongDem, cayCauVong, cayTuyet, cayHong,
  ];
}