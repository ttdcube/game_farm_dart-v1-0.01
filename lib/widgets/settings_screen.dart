import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double musicVolume = 0.7;
  double sfxVolume = 0.8;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌿 Nền gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA5D6A7), // xanh lá nhạt
              Color(0xFF388E3C), // xanh đậm
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // 🎵 Tiêu đề
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '⚙️ Settings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🎶 Âm nhạc
              _buildSettingCard(
                icon: Icons.music_note,
                title: 'Music Volume',
                child: Slider(
                  value: musicVolume,
                  onChanged: (value) {
                    setState(() => musicVolume = value);
                  },
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(musicVolume * 100).round()}%',
                  activeColor: Colors.green,
                  inactiveColor: Colors.green.shade200,
                ),
              ),

              const SizedBox(height: 16),

              // 🔊 Âm thanh hiệu ứng
              _buildSettingCard(
                icon: Icons.volume_up,
                title: 'SFX Volume',
                child: Slider(
                  value: sfxVolume,
                  onChanged: (value) {
                    setState(() => sfxVolume = value);
                  },
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(sfxVolume * 100).round()}%',
                  activeColor: Colors.green,
                  inactiveColor: Colors.green.shade200,
                ),
              ),

              const SizedBox(height: 16),

              // 🌙 Chế độ tối
              _buildSettingCard(
                icon: Icons.dark_mode,
                title: 'Theme Mode',
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark theme'),
                  value: darkMode,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              // 💾 Nút lưu cài đặt
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Settings saved!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🧩 Widget dựng card cài đặt
  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green.shade700, size: 26),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
