import 'package:flutter/material.dart';
import '../models/crop.dart';

class PlantInfoScreen extends StatelessWidget {
  final Crop crop;

  const PlantInfoScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${crop.name} Info'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                crop.emoji,
                style: const TextStyle(fontSize: 80),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                crop.name,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: const Text(
                    'UNLOCKED',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    crop.rarity.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getRarityColor(crop.rarity),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoCard('Description', crop.specialEffect ?? 'No special effect'),
            _buildInfoCard('Growth Time', '${crop.growthTime.inSeconds} seconds'),
            _buildInfoCard('Harvest Yield', '${crop.harvestYield} units'),
            _buildInfoCard('Seed Cost', '💰 ${crop.seedCost}'),
            _buildInfoCard('Unlock Cost', '💰 ${crop.unlockCost}'),
            _buildInfoCard('Unlock Level', 'Lv. ${crop.unlockLevel}'),
            _buildInfoCard('XP Reward', '⭐ ${crop.xpReward}'),
            _buildInfoCard('Water Needed', '${crop.waterNeeded} units'),
            _buildInfoCard('Fertilizer Needed', '${crop.fertilizerNeeded} units'),
            _buildInfoCard('Current Level', '${crop.currentLevel}'),
            _buildInfoCard('Affinity', '${crop.affinity}'),
            _buildInfoCard('Current Emotion', crop.getEmotionEmoji(crop.currentEmotion)),
            if (crop.unlockMethod != null)
              _buildInfoCard('Unlock Method', crop.unlockMethod!),
            const SizedBox(height: 20),
            const Text(
              'Growth Stages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: crop.growthEmojis
                  .map((emoji) => Chip(label: Text(emoji, style: const TextStyle(fontSize: 18))))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Level Emojis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (crop.levelEmojis.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: crop.levelEmojis.entries
                    .map((e) => Chip(label: Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 16))))
                    .toList(),
              )
            else
              const Text('No level-specific emojis'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Evolution feature coming soon!')),
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Evolve Plant'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Environmental Effects',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (crop.environmentalEffects.isNotEmpty)
              Column(
                children: crop.environmentalEffects
                    .map((effect) => ListTile(
                          leading: const Icon(Icons.eco),
                          title: Text(effect),
                        ))
                    .toList(),
              )
            else
              const Text('No environmental effects'),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(
                '$title:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(value, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  static Color _getRarityColor(CropRarity rarity) {
    switch (rarity) {
      case CropRarity.common:
        return Colors.grey;
      case CropRarity.rare:
        return Colors.blue;
      case CropRarity.epic:
        return Colors.purple;
      case CropRarity.legendary:
        return Colors.orange;
      case CropRarity.event:
        return Colors.pink;
    }
  }
}
