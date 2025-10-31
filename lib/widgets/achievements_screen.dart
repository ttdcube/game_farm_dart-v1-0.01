import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';
import '../models/achievement.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final achievements = gameState.achievements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Achievements'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final bool isCompleted = achievement.currentProgress >= achievement.goal;

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isCompleted ? Colors.amber[100] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Achievement Icon
                  Text(
                    achievement.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: 12),
                  // Achievement Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isCompleted ? Colors.green[800] : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          achievement.description,
                          style: const TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        if (!isCompleted)
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: 0.0, end: achievement.progressPercentage),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              );
                            },
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${achievement.currentProgress} / ${achievement.goal}',
                          style: const TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                  // Completed Checkmark
                  if (isCompleted)
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
