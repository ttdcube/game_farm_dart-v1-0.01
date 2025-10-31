import 'package:flutter/material.dart';
import '../models/crop.dart';

enum PlotState {
  empty,
  seeded,
  growing,
  harvestable,
  wilting, // New state for when crop needs care
}

class Plot {
  PlotState state;
  Crop? crop;
  DateTime? plantedTime;
  DateTime? lastWatered;
  DateTime? lastFertilized;
  DateTime? lastTalked;
  bool needsWater = false;
  bool needsFertilizer = false;
  int careScore = 0;
  int moisture = 100; // New: Moisture level (0-100)
  int light = 100; // New: Light level (0-100)
  int nutrients = 100; // New: Nutrients level (0-100)

  Plot({this.state = PlotState.empty, this.crop, this.plantedTime});

  bool get isHarvestable {
    if (state == PlotState.growing && crop != null && plantedTime != null) {
      return DateTime.now().difference(plantedTime!) >= crop!.growthTime;
    }
    return false;
  }

  bool get isWilting {
    if (crop != null && plantedTime != null) {
      final timeSincePlanted = DateTime.now().difference(plantedTime!);
      final timeSinceWatered = lastWatered != null ? DateTime.now().difference(lastWatered!) : Duration.zero;
      final timeSinceFertilized = lastFertilized != null ? DateTime.now().difference(lastFertilized!) : Duration.zero;

      // Crop wilts if not watered for 1/3 of growth time or not fertilized for 2/3
      needsWater = timeSinceWatered > crop!.growthTime * 0.33;
      needsFertilizer = timeSinceFertilized > crop!.growthTime * 0.66;

      return needsWater || needsFertilizer;
    }
    return false;
  }

  GrowthStage get currentGrowthStage {
    if (plantedTime == null || crop == null) return GrowthStage.seed;

    final elapsed = DateTime.now().difference(plantedTime!);
    final progress = elapsed.inMilliseconds / crop!.growthTime.inMilliseconds;

    if (progress < 0.25) return GrowthStage.seed;
    if (progress < 0.5) return GrowthStage.sprout;
    if (progress < 0.75) return GrowthStage.young;
    if (progress < 1.0) return GrowthStage.mature;
    return GrowthStage.flowering;
  }

  void water() {
    lastWatered = DateTime.now();
    needsWater = false;
    if (state == PlotState.wilting && !needsFertilizer) {
      state = PlotState.growing;
    }
  }

  void fertilize() {
    lastFertilized = DateTime.now();
    needsFertilizer = false;
    if (state == PlotState.wilting && !needsWater) {
      state = PlotState.growing;
    }
  }

  Duration getRemainingTime() {
    if (crop != null && plantedTime != null) {
      final elapsed = DateTime.now().difference(plantedTime!);
      final remaining = crop!.growthTime - elapsed;
      return remaining > Duration.zero ? remaining : Duration.zero;
    }
    return Duration.zero;
  }
}

class PlotWidget extends StatelessWidget {
  final Plot plot;
  final VoidCallback onTap;
  final VoidCallback? onWater;
  final VoidCallback? onFertilize;

  const PlotWidget({super.key, required this.plot, required this.onTap, this.onWater, this.onFertilize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getColorForState(plot.state),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getEmojiForPlot(plot),
                    style: const TextStyle(fontSize: 20),
                  ),
                  if (plot.crop != null && plot.state != PlotState.empty)
                    Text(
                      _getEmotionEmoji(plot),
                      style: const TextStyle(fontSize: 12),
                    ),
                  if (plot.state == PlotState.growing || plot.state == PlotState.harvestable)
                    Text(
                      _getTextForPlot(plot),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            if (plot.needsWater)
              const Positioned(
                top: 2,
                right: 2,
                child: Text('💧', style: TextStyle(fontSize: 12)),
              ),
            if (plot.needsFertilizer)
              const Positioned(
                top: 2,
                left: 2,
                child: Text('🧪', style: TextStyle(fontSize: 12)),
              ),
            if (plot.state == PlotState.harvestable)
              const Positioned(
                bottom: 2,
                right: 2,
                child: Text('✂️', style: TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  Color _getColorForState(PlotState state) {
    switch (state) {
      case PlotState.empty:
        return Colors.brown[300]!;
      case PlotState.seeded:
        return Colors.grey[600]!;
      case PlotState.growing:
        return Colors.lightGreen;
      case PlotState.harvestable:
        return Colors.yellow[600]!;
      case PlotState.wilting:
        return Colors.red[300]!;
    }
  }

  String _getEmojiForPlot(Plot plot) {
    switch (plot.state) {
      case PlotState.empty:
        return '🌱';
      case PlotState.seeded:
        return '🌰';
      case PlotState.growing:
        return plot.crop?.getEmojiForStage(plot.currentGrowthStage) ?? '🌿';
      case PlotState.harvestable:
        return plot.crop?.emoji ?? '🌾';
      case PlotState.wilting:
        return '🥀';
    }
  }

  String _getEmotionEmoji(Plot plot) {
    if (plot.crop != null) {
      final emotion = plot.crop!.calculateEmotion(plot.lastWatered, plot.lastFertilized, plot.lastTalked, plot.careScore);
      return plot.crop!.getEmotionEmoji(emotion);
    }
    return '';
  }

  String _getTextForPlot(Plot plot) {
    switch (plot.state) {
      case PlotState.empty:
        return '';
      case PlotState.seeded:
        return 'Seeded';
      case PlotState.growing:
        final remaining = plot.getRemainingTime();
        return '${remaining.inSeconds}s';
      case PlotState.harvestable:
        return 'Harvest!';
      case PlotState.wilting:
        return 'Wilting!';
    }
  }
}
