import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upgrades Shop'),
          backgroundColor: Colors.green,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.yellow,
            tabs: [
              Tab(text: 'Click'),
              Tab(text: 'Idle'),
              Tab(text: 'Global'),
              Tab(text: 'Plant'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpgradeList(context, gameState.clickUpgrades, gameState),
            _buildUpgradeList(context, gameState.idleUpgrades, gameState),
            _buildUpgradeList(context, gameState.globalUpgrades, gameState),
            _buildUpgradeList(context, gameState.availableUpgrades, gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeList(BuildContext context, List<Upgrade> upgrades, GameState gameState) {
    return ListView.builder(
      padding: const EdgeInsets.all(6),
      itemCount: upgrades.length,
      itemBuilder: (context, index) {
        final upgrade = upgrades[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: ListTile(
            leading: const Icon(Icons.grass, color: Colors.green),
            title: Text(upgrade.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(upgrade.description),
            trailing: ElevatedButton(
              onPressed: gameState.coins >= upgrade.cost
                  ? () => Provider.of<GameState>(context, listen: false).buyUpgrade(upgrade)
                  : null,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              child: Text('Buy\n(${upgrade.cost})', textAlign: TextAlign.center),
            ),
          ),
        );
      },
    );
  }
}