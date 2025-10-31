enum QuestType { daily, weekly, story, event, secret }

enum QuestStatus { locked, active, completed, claimed }

class Quest {
  final String id;
  final String name;
  final String description;
  final QuestType type;
  final Map<String, int> conditions; // e.g., {'water': 3, 'harvest': 2}
  final Map<String, int> rewards; // e.g., {'coins': 50, 'xp': 80, 'gems': 1}
  QuestStatus status;
  Map<String, int> progress; // Current progress counters

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.conditions,
    required this.rewards,
    this.status = QuestStatus.locked,
    Map<String, int>? progress,
  }) : progress = progress ?? {};

  bool get isCompleted => conditions.entries.every((entry) => (progress[entry.key] ?? 0) >= entry.value);

  void updateProgress(String key, int amount) {
    progress[key] = (progress[key] ?? 0) + amount;
  }

  void resetProgress() {
    progress.clear();
  }

  void activate() {
    if (status == QuestStatus.locked) {
      status = QuestStatus.active;
    }
  }

  void complete() {
    if (isCompleted && status == QuestStatus.active) {
      status = QuestStatus.completed;
    }
  }

  void claim() {
    if (status == QuestStatus.completed) {
      status = QuestStatus.claimed;
    }
  }

  // Static quest definitions based on the provided spec
  static List<Quest> getAllQuests() {
    return [
      // Daily Quests
      Quest(
        id: 'D001',
        name: 'Tưới nước buổi sáng 💧',
        description: 'Tưới 3 cây bất kỳ.',
        type: QuestType.daily,
        conditions: {'water': 3},
        rewards: {'coins': 50},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'D002',
        name: 'Thu hoạch đầu ngày 🌾',
        description: 'Thu hoạch 2 cây đã trưởng thành.',
        type: QuestType.daily,
        conditions: {'harvest': 2},
        rewards: {'xp': 80},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'D003',
        name: 'Bón phân nhẹ 🧪',
        description: 'Bón phân 1 lần cho cây.',
        type: QuestType.daily,
        conditions: {'fertilize': 1},
        rewards: {'coins': 30},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'D004',
        name: 'Kiểm tra vườn 🪴',
        description: 'Nhấn vào từng cây trong vườn ít nhất 1 lần.',
        type: QuestType.daily,
        conditions: {'check': 3},
        rewards: {'xp': 20},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'D005',
        name: 'Cắt tỉa gọn gàng ✂️',
        description: 'Cắt tỉa lá hư của 1 cây.',
        type: QuestType.daily,
        conditions: {'trim': 1},
        rewards: {'coins': 30},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'D006',
        name: 'Bán nông sản 🧺',
        description: 'Bán 2 cây trưởng thành.',
        type: QuestType.daily,
        conditions: {'sell': 2},
        rewards: {'coins': 100},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'D007',
        name: 'Chăm chỉ mỗi ngày 🌞',
        description: 'Hoàn thành 3 nhiệm vụ ngày.',
        type: QuestType.daily,
        conditions: {'daily_completed': 3},
        rewards: {'gems': 1},
        status: QuestStatus.active,
      ),
      // Weekly Quests
      Quest(
        id: 'W001',
        name: 'Nhà nông siêng năng 🚜',
        description: 'Tưới 20 lần trong tuần.',
        type: QuestType.weekly,
        conditions: {'water': 20},
        rewards: {'coins': 500},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'W002',
        name: 'Mùa bội thu 🌻',
        description: 'Thu hoạch 15 cây.',
        type: QuestType.weekly,
        conditions: {'harvest': 15},
        rewards: {'xp': 800},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'W003',
        name: 'Vườn xanh tươi 🍃',
        description: 'Bón phân 10 lần.',
        type: QuestType.weekly,
        conditions: {'fertilize': 10},
        rewards: {'gems': 5},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'W004',
        name: 'Kinh doanh nông sản 🏪',
        description: 'Bán 10 cây trong tuần.',
        type: QuestType.weekly,
        conditions: {'sell': 10},
        rewards: {'coins': 1000},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'W005',
        name: 'Trồng loại cây mới 🌱',
        description: 'Mở khóa 1 giống cây mới.',
        type: QuestType.weekly,
        conditions: {'unlock': 1},
        rewards: {'gems': 3},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'W006',
        name: 'Sưu tập hạt giống 🌰',
        description: 'Thu thập đủ 5 loại hạt khác nhau.',
        type: QuestType.weekly,
        conditions: {'seed_type': 5},
        rewards: {'item': 1}, // Special item
        status: QuestStatus.active,
      ),
      Quest(
        id: 'W007',
        name: 'Vườn lớn mạnh 🌿',
        description: 'Mở rộng khu đất 1 lần.',
        type: QuestType.weekly,
        conditions: {'expand': 1},
        rewards: {'gems': 2},
        status: QuestStatus.active,
      ),
      // Story Quests
      Quest(
        id: 'S001',
        name: 'Bắt đầu hành trình 🌱',
        description: 'Trồng cây đầu tiên của bạn.',
        type: QuestType.story,
        conditions: {'plant': 1},
        rewards: {'xp': 100},
        status: QuestStatus.active,
      ),
      Quest(
        id: 'S002',
        name: 'Người chăm vườn nhỏ 🪴',
        description: 'Tưới cây lần đầu.',
        type: QuestType.story,
        conditions: {'water': 1},
        rewards: {'coins': 50},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'S003',
        name: 'Lần thu hoạch đầu tiên 🌾',
        description: 'Thu hoạch cây đầu tiên.',
        type: QuestType.story,
        conditions: {'harvest': 1},
        rewards: {'gems': 1},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'S004',
        name: 'Khu vườn đầu tiên 🌳',
        description: 'Mở khóa 3 loại cây.',
        type: QuestType.story,
        conditions: {'unlock': 3},
        rewards: {'coins': 300},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'S005',
        name: 'Học cách bón phân 🧪',
        description: 'Sử dụng phân bón lần đầu.',
        type: QuestType.story,
        conditions: {'fertilize': 1},
        rewards: {'xp': 50},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'S006',
        name: 'Gặp thương nhân 🧍‍♂️💼',
        description: 'Bán nông sản lần đầu.',
        type: QuestType.story,
        conditions: {'sell': 1},
        rewards: {'coins': 200},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'S007',
        name: 'Vườn trù phú 🌺',
        description: 'Trồng tổng cộng 20 cây.',
        type: QuestType.story,
        conditions: {'plant': 20},
        rewards: {'gems': 3},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'S008',
        name: 'Bậc thầy trồng trọt 👑',
        description: 'Hoàn thành toàn bộ nhiệm vụ cốt truyện.',
        type: QuestType.story,
        conditions: {'story_completed': 1},
        rewards: {'item': 1}, // Special item
        status: QuestStatus.locked,
      ),
      // Event Quests (placeholders, can be activated during events)
      Quest(
        id: 'E001',
        name: 'Lễ hội mùa xuân 🌸',
        description: 'Trồng 5 cây hoa xuân.',
        type: QuestType.event,
        conditions: {'plant_flower': 5},
        rewards: {'decoration': 1}, // Flower decoration
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'E002',
        name: 'Mùa hè năng động ☀️',
        description: 'Tưới cây 30 lần.',
        type: QuestType.event,
        conditions: {'water': 30},
        rewards: {'skin': 1}, // Farmer outfit
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'E003',
        name: 'Lễ hội thu hoạch 🎃',
        description: 'Thu hoạch 25 cây bí đỏ.',
        type: QuestType.event,
        conditions: {'harvest_pumpkin': 25},
        rewards: {'item': 1}, // Event item
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'E004',
        name: 'Giáng Sinh an lành 🎄',
        description: 'Trồng 10 cây thông Noel.',
        type: QuestType.event,
        conditions: {'plant_pine': 10},
        rewards: {'decoration': 1}, // Christmas decoration
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'E005',
        name: 'Tết đoàn viên 🧧',
        description: 'Tặng 5 món quà cho bạn bè.',
        type: QuestType.event,
        conditions: {'gift': 5},
        rewards: {'gems': 2, 'envelope': 1}, // Red envelope
        status: QuestStatus.locked,
      ),
      // Secret Quests
      Quest(
        id: 'H001',
        name: 'Cây trong đêm 🌙',
        description: 'Tưới cây sau 12h đêm.',
        type: QuestType.secret,
        conditions: {'water_night': 1},
        rewards: {'xp': 100},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'H002',
        name: 'Bàn tay thần tốc ⚡',
        description: 'Tưới 10 cây trong 30 giây.',
        type: QuestType.secret,
        conditions: {'water_speed': 10},
        rewards: {'gems': 2},
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'H003',
        name: 'Nông dân hoàn hảo 🏆',
        description: 'Không để cây nào héo trong 3 ngày liên tục.',
        type: QuestType.secret,
        conditions: {'no_wilt': 3},
        rewards: {'crown': 1}, // Golden crown
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'H004',
        name: 'Người sưu tập 🌾',
        description: 'Sở hữu toàn bộ loại cây đã ra mắt.',
        type: QuestType.secret,
        conditions: {'all_crops': 1},
        rewards: {'skin': 1}, // Special skin
        status: QuestStatus.locked,
      ),
      Quest(
        id: 'H005',
        name: 'Tâm hồn xanh 💚',
        description: 'Không bán cây nào trong 5 ngày.',
        type: QuestType.secret,
        conditions: {'no_sell': 5},
        rewards: {'coins': 500},
        status: QuestStatus.locked,
      ),
    ];
  }
}
