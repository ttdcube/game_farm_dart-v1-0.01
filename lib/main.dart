import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_game_v2/providers/game_state.dart';
import 'package:farm_game_v2/widgets/credits_screen.dart';
import 'package:farm_game_v2/widgets/decoration_screen.dart';
import 'package:farm_game_v2/widgets/achievements_screen.dart';
import 'package:farm_game_v2/widgets/settings_screen.dart';
import 'package:farm_game_v2/widgets/loading_screen.dart';
import 'package:farm_game_v2/widgets/shop_screen.dart';
import 'package:farm_game_v2/widgets/plant_info_screen.dart';
import 'package:farm_game_v2/widgets/title_screen.dart';

void main() {
  // Ensure that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
      ),
      // Use a builder to switch between LoadingScreen and TitleScreen
      home: Consumer<GameState>(
        builder: (context, gameState, child) {
          // Show loading screen until GameState is initialized
          return gameState.isInitialized ? const TitleScreen() : const LoadingScreen();
        },
      ),
      routes: {
        '/game': (context) => const ClickerScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/achievements': (context) => const AchievementsScreen(),
        '/shop': (context) => const ShopScreen(),
        '/decorations': (context) => const DecorationScreen(),
        '/credits': (context) => const CreditsScreen(),
        // The home property is used for the initial route, so '/title' is covered.
      },
      // This handles the case where you push a route that isn't registered,
      // preventing a crash.
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const TitleScreen()),
    );
  }
}

class ClickerScreen extends StatefulWidget {
  const ClickerScreen({super.key});

  @override
  State<ClickerScreen> createState() => _ClickerScreenState();
}

class _ClickerScreenState extends State<ClickerScreen> with TickerProviderStateMixin {
  final List<Widget> _clickEffects = [];

  void _addClickEffect(Offset position) {
    final key = UniqueKey();
    setState(() {
      _clickEffects.add(
        _FloatingEffect(
          key: key,
          text: '✨',
          position: position,
          onCompleted: () => _removeClickEffect(key),
        ),
      );
    });
  }

  void _removeClickEffect(Key key) {
    setState(() {
      _clickEffects.removeWhere((widget) => widget.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Farm Clicker'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () => Navigator.pushNamed(context, '/achievements'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Access GameState to get the current crop
              final gameState = context.read<GameState>();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlantInfoScreen(crop: gameState.currentCrop),
              ));
            },
          ),
        ],
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Stack(
            children: [
              Column(
                children: [
                  _buildPlayerHeader(gameState),
                  const Divider(height: 1, thickness: 1),
                  Expanded(child: _buildCropArea(gameState)),
                  _buildActionButtons(gameState),
                  const SizedBox(height: 8),
                  _buildExtraStats(gameState),
                ],
              ),
              if (gameState.showHarvestEffect) _buildHarvestEffect(),
              if (gameState.showPrestigeEffect) _buildPrestigeEffect(gameState),
              if (gameState.showUpgradeEffect) _buildUpgradeEffect(),
              if (gameState.showEvolveEffect) _buildEvolveEffect(),
              ..._clickEffects,
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildPlayerHeader(GameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.brown,
            child: Text('🧑‍🌾', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Player Name', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Level ${gameState.player.level}', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: gameState.player.experience / gameState.player.experienceToNextLevel,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 4),
              Text('${gameState.coins}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              const Icon(Icons.diamond, color: Colors.cyan),
              const SizedBox(width: 4),
              const Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCropArea(GameState gameState) {
    return Center(
      child: GestureDetector(
        onTapDown: (details) => _addClickEffect(details.globalPosition),
        onTap: () {
          if (gameState.canHarvest) {
            gameState.harvest();
          } else {
            gameState.click();
          }
        },
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: gameState.canHarvest
                  ? [Colors.green.shade700, Colors.green.shade400]
                  : [Colors.lightGreen.shade400, Colors.lightGreen.shade200],
            ),
            boxShadow: [
              BoxShadow(
                color: gameState.canHarvest
                    ? Colors.green.shade400.withOpacity(0.7)
                    : Colors.black26,
                blurRadius: 15,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  gameState.currentCrop.getEmojiForStage(gameState.currentGrowthStage),
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 8),
                Text(
                  gameState.canHarvest ? 'TAP TO HARVEST!' : 'TAP TO GROW!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2))],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: LinearProgressIndicator(
                    value: gameState.growthProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white38,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      gameState.canHarvest ? Colors.yellow : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(GameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildActionButton(
              '✂️\nHarvest',
              Colors.green,
              gameState.canHarvest ? gameState.harvest : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              '🔄\nEvolve\n(${gameState.canEvolve ? gameState.cropEvolutionPath[gameState.currentCropIndex + 1].unlockCost : '...'})',
              Colors.orange,
              gameState.canEvolve ? gameState.evolveCrop : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              '⬆️\nUpgrade\n(${gameState.canUpgrade ? gameState.getUpgradeCost() : '...'})',
              Colors.blue,
              gameState.canUpgrade ? gameState.upgradeCrop : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildExtraStats(GameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  'Growth/Click: ${(gameState.growthPerClick * 100).toStringAsFixed(1)}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: Text(
                  'Idle Rate: ${(gameState.idleRate * 100).toStringAsFixed(2)}%/s',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: Text(
                  'Auto Farmers: ${gameState.autoFarmerCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Seeds of Power: ${gameState.seedsOfPower}'),
              if (gameState.canPrestige) ...[
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: gameState.prestige,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: Text('Prestige (${gameState.prestigeThreshold} coins)'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestEffect() {
    final random = Random();
    final coins = List.generate(30, (index) {
      return _FallingCoin(
        key: UniqueKey(),
        duration: Duration(milliseconds: 800 + random.nextInt(700)),
        delay: Duration(milliseconds: random.nextInt(500)),
        startX: 0.3 + random.nextDouble() * 0.4,
      );
    });
    return Stack(children: coins);
  }

  Widget _buildPrestigeEffect(GameState gameState) {
    return GestureDetector(
      onTap: () => setState(() => gameState.showPrestigeEffect = false),
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '✨ PRESTIGE! ✨',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  shadows: [Shadow(color: Colors.orange, blurRadius: 10)],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You earned ${gameState.seedsOfPower} Seeds of Power!',
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                'All progress is boosted by ${(gameState.prestigeMultiplier * 100).toStringAsFixed(0)}%!',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              const Text(
                '(Tap to continue)',
                style: TextStyle(fontSize: 16, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeEffect() {
    return const Center(
      child: _AnimatedFeedback(
        key: ValueKey('upgrade_effect'),
        text: 'UPGRADE!',
        emoji: '🚀',
      ),
    );
  }

  Widget _buildEvolveEffect() {
    return const Center(
      child: _AnimatedFeedback(
        key: ValueKey('evolve_effect'),
        text: 'EVOLVED!',
        emoji: '🌟',
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 0, // Or manage current index state if needed
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Inventory'),
        BottomNavigationBarItem(
          label: 'Achievements',
          icon: Consumer<GameState>(
            builder: (context, gameState, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.star_border),
                  if (gameState.hasNewAchievements)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: 'Shop'),
      ],
      onTap: (index) {
        final gameState = context.read<GameState>();
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/decorations');
            break;
          case 1:
            gameState.clearNewAchievementsFlag(); // Clear notification dot
            Navigator.pushNamed(context, '/achievements');
            break;
          case 2:
            Navigator.pushNamed(context, '/shop');
            break;
        }
      },
    );
  }
}

/// -------------------- Helper Widgets --------------------

class _FloatingEffect extends StatefulWidget {
  final String text;
  final Offset position;
  final Offset endOffset;
  final VoidCallback onCompleted;

  const _FloatingEffect({
    super.key,
    required this.text,
    required this.position,
    this.endOffset = const Offset(0, -80),
    required this.onCompleted,
  });

  @override
  State<_FloatingEffect> createState() => _FloatingEffectState();
}

class _FloatingEffectState extends State<_FloatingEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _moveAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)));
    _moveAnim = Tween<Offset>(begin: Offset.zero, end: widget.endOffset).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 10,
      top: widget.position.dy - 50,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: _moveAnim.value,
          child: Opacity(opacity: _fadeAnim.value, child: child),
        ),
        child: Text(widget.text, style: const TextStyle(fontSize: 24, color: Colors.amber)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AnimatedFeedback extends StatefulWidget {
  final String text;
  final String emoji;

  const _AnimatedFeedback({super.key, required this.text, required this.emoji});

  @override
  State<_AnimatedFeedback> createState() => _AnimatedFeedbackState();
}

class _AnimatedFeedbackState extends State<_AnimatedFeedback> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack)),
    );

    _fadeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _fadeAnim.value,
        child: Transform.scale(scale: _scaleAnim.value, child: child),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${widget.emoji} ', style: const TextStyle(fontSize: 40)),
            TextSpan(text: widget.text),
          ],
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(2, 2))],
        ),
      ),
    );
  }
}

class _FallingCoin extends StatefulWidget {
  final Duration duration;
  final Duration delay;
  final double startX;

  const _FallingCoin({super.key, required this.duration, required this.delay, required this.startX});

  @override
  State<_FallingCoin> createState() => _FallingCoinState();
}

class _FallingCoinState extends State<_FallingCoin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fallAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fallAnim = Tween<double>(begin: -0.1, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _fallAnim,
      builder: (context, child) => Positioned(
        left: size.width * widget.startX,
        top: size.height * _fallAnim.value,
        child: const Text('💰', style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
