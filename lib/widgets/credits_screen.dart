import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF81C784), // xanh lá nhạt
              Color(0xFF388E3C), // xanh đậm
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🌾 FARM GAME 🌾',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black45,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // 🏫 Thông tin nhóm
                _buildCreditCard(
                  title: '🏫 Trưởng Nhóm',
                  name: 'Trần Tiến Đạt',
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),

                _buildCreditCard(
                  title: '💡 Người Ý Tưởng',
                  name: 'Đào Duy Quỳnh',
                  color: Colors.lightBlueAccent,
                ),
                const SizedBox(height: 20),

                _buildCreditCard(
                  title: '💻 Lập Trình Viên (Coder)',
                  name: 'Nguyễn Trung Hiếu',
                  color: Colors.amberAccent,
                ),

                const SizedBox(height: 50),

                // 🌟 Special Thanks
                const Text(
                  'Special Thanks:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Flutter Community',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const Text(
                  'Open Source Contributors',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),

                const SizedBox(height: 60),

                // 🔙 Nút quay lại
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade800,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.black45,
                    elevation: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌿 Widget tạo thẻ credit
  Widget _buildCreditCard({
    required String title,
    required String name,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
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
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
