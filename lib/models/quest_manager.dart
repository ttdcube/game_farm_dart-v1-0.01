import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'quest.dart';

class QuestManager {
  List<Quest> quests = [];
  DateTime? lastDailyReset;
  DateTime? lastWeeklyReset;
  Timer? _resetTimer;

  QuestManager() {
    _initializeQuests();
    _startResetTimer();
  }

  void _initializeQuests() {
    quests = Quest.getAllQuests();
    _loadProgress();
  }

  void _startResetTimer() {
    _resetTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      _checkResets();
    });
  }

  void _checkResets() {
    final now = DateTime.now();
    if (lastDailyReset == null || now.difference(lastDailyReset!).inHours >= 24) {
      _resetDailyQuests();
    }
    if (lastWeeklyReset == null || now.difference(lastWeeklyReset!).inDays >= 7) {
      _resetWeeklyQuests();
    }
  }

  void _resetDailyQuests() {
    for (var quest in quests.where((q) => q.type == QuestType.daily)) {
      quest.resetProgress();
      quest.status = QuestStatus.active;
    }
    lastDailyReset = DateTime.now();
    _saveProgress();
  }

  void _resetWeeklyQuests() {
    for (var quest in quests.where((q) => q.type == QuestType.weekly)) {
      quest.resetProgress();
      quest.status = QuestStatus.active;
    }
    lastWeeklyReset = DateTime.now();
    _saveProgress();
  }

  void updateProgress(String key, int amount) {
    for (var quest in quests.where((q) => q.status == QuestStatus.active)) {
      quest.updateProgress(key, amount);
      if (quest.isCompleted) {
        quest.complete();
      }
    }
    _checkStoryUnlocks();
    _saveProgress();
  }

  void _checkStoryUnlocks() {
    // Unlock next story quests based on previous completions
    final storyQuests = quests.where((q) => q.type == QuestType.story).toList();
    for (int i = 0; i < storyQuests.length - 1; i++) {
      if (storyQuests[i].status == QuestStatus.completed || storyQuests[i].status == QuestStatus.claimed) {
        storyQuests[i + 1].activate();
      }
    }
    // Special case for S008: Complete all story quests
    final allStoryCompleted = storyQuests.where((q) => q.id != 'S008').every((q) => q.status == QuestStatus.claimed);
    if (allStoryCompleted) {
      quests.firstWhere((q) => q.id == 'S008').activate();
    }
  }

  void claimReward(String questId) {
    final quest = quests.firstWhere((q) => q.id == questId);
    if (quest.status == QuestStatus.completed) {
      quest.claim();
      _saveProgress();
    }
  }

  List<Quest> getActiveQuests() {
    return quests.where((q) => q.status == QuestStatus.active).toList();
  }

  List<Quest> getCompletedQuests() {
    return quests.where((q) => q.status == QuestStatus.completed).toList();
  }

  List<Quest> getClaimedQuests() {
    return quests.where((q) => q.status == QuestStatus.claimed).toList();
  }

  // Secret quest triggers
  void triggerSecretQuest(String trigger) {
    switch (trigger) {
      case 'water_night':
        final quest = quests.firstWhere((q) => q.id == 'H001');
        if (quest.status == QuestStatus.locked) {
          quest.activate();
          quest.updateProgress('water_night', 1);
          quest.complete();
        }
        break;
      case 'water_speed':
        final quest = quests.firstWhere((q) => q.id == 'H002');
        if (quest.status == QuestStatus.locked) {
          quest.activate();
          quest.updateProgress('water_speed', 10);
          quest.complete();
        }
        break;
      case 'no_wilt':
        final quest = quests.firstWhere((q) => q.id == 'H003');
        quest.updateProgress('no_wilt', 1);
        if (quest.progress['no_wilt']! >= 3) {
          quest.activate();
          quest.complete();
        }
        break;
      case 'all_crops':
        final quest = quests.firstWhere((q) => q.id == 'H004');
        if (quest.status == QuestStatus.locked) {
          quest.activate();
          quest.updateProgress('all_crops', 1);
          quest.complete();
        }
        break;
      case 'no_sell':
        final quest = quests.firstWhere((q) => q.id == 'H005');
        quest.updateProgress('no_sell', 1);
        if (quest.progress['no_sell']! >= 5) {
          quest.activate();
          quest.complete();
        }
        break;
    }
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final questData = quests.map((q) => {
      'id': q.id,
      'status': q.status.index,
      'progress': q.progress,
    }).toList();
    await prefs.setString('quests', questData.toString()); // Simplified, use jsonEncode in real app
    await prefs.setString('lastDailyReset', lastDailyReset?.toIso8601String() ?? '');
    await prefs.setString('lastWeeklyReset', lastWeeklyReset?.toIso8601String() ?? '');
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final questString = prefs.getString('quests');
    if (questString != null) {
      // Parse and load quests (simplified)
      // In real app, use jsonDecode and map back
    }
    final dailyResetString = prefs.getString('lastDailyReset');
    if (dailyResetString != null && dailyResetString.isNotEmpty) {
      lastDailyReset = DateTime.parse(dailyResetString);
    }
    final weeklyResetString = prefs.getString('lastWeeklyReset');
    if (weeklyResetString != null && weeklyResetString.isNotEmpty) {
      lastWeeklyReset = DateTime.parse(weeklyResetString);
    }
  }

  void dispose() {
    _resetTimer?.cancel();
  }
}
