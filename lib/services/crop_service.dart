import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/crop.dart';

class CropService {
  static Future<List<Crop>> loadCropsFromJson() async {
    final String jsonString = await rootBundle.loadString('assets/crops.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString) as Map<String, dynamic>;

    final List<Crop> allCrops = [];

    final rarityMap = {
      'common': CropRarity.common,
      'rare': CropRarity.rare,
      'epic': CropRarity.epic,
      'legendary': CropRarity.legendary,
      'event': CropRarity.event,
    };

    for (final entry in jsonData.entries) {
      final rarity = rarityMap[entry.key];
      if (rarity != null && entry.value is List) {
        final List<dynamic> cropsList = entry.value as List<dynamic>;
        allCrops.addAll(cropsList.map((cropJson) {
          return _cropFromJson(cropJson as Map<String, dynamic>, rarity);
        }));
      }
    }
    return allCrops;
  }

  static Crop _cropFromJson(Map<String, dynamic> json, CropRarity rarity) {
    // Helper to safely get an int value, defaulting to 0 if null or wrong type.
    int getInt(String key, {int defaultValue = 0}) {
      final value = json[key];
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return Crop(
      name: json['name'] as String? ?? 'Unknown',
      emoji: json['emoji'] as String? ?? '❓',
      growthEmojis: List<String>.from(json['growthEmojis'] as List? ?? ['❓']),
      growthTime: Duration(seconds: getInt('growthTime', defaultValue: 10)),
      harvestYield: getInt('harvestYield', defaultValue: 1),
      seedCost: getInt('seedCost', defaultValue: 1),
      unlockCost: getInt('unlockCost', defaultValue: 0),
      unlockLevel: getInt('unlockLevel', defaultValue: 1),
      xpReward: getInt('xpReward', defaultValue: 1),
      waterNeeded: json['waterNeeded'] ?? 3,
      fertilizerNeeded: json['fertilizerNeeded'] ?? 2,
      rarity: rarity,
      specialEffect: json['specialEffect'] as String?,
      unlockMethod: json['unlockMethod'] as String?,
    );
  }

  static List<Crop> getCropsByRarity(List<Crop> allCrops, CropRarity rarity) {
    return allCrops.where((crop) => crop.rarity == rarity).toList();
  }

  static List<Crop> getUnlockedCrops(List<Crop> allCrops, int playerLevel, Set<String> unlockedMethods) {
    return allCrops.where((crop) {
      if (crop.unlockLevel > playerLevel) return false;
      if (crop.unlockMethod != null && !unlockedMethods.contains(crop.unlockMethod)) return false;
      return true;
    }).toList();
  }
}
