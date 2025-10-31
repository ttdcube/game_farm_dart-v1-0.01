class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int goal; // The target value to unlock the achievement
  int currentProgress;
  bool isUnlocked;
  bool isClaimed;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.goal,
    this.currentProgress = 0,
    this.isUnlocked = false,
    this.isClaimed = false,
  });

  // Calculate progress as a percentage (0.0 to 1.0)
  double get progressPercentage => (currentProgress / goal).clamp(0.0, 1.0);
}