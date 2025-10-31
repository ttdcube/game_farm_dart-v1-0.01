import 'package:flutter/material.dart';
import '../models/crop.dart';

enum ActionType { plant, water, fertilize, harvest, unlockCrop, talk }

class Toolbar extends StatelessWidget {
  final ActionType selectedAction;
  final Crop? selectedCrop;
  final List<Crop> availableCrops;
  final Function(ActionType) onActionSelected;
  final Function(Crop) onCropSelected;

  const Toolbar({
    super.key,
    required this.selectedAction,
    this.selectedCrop,
    required this.availableCrops,
    required this.onActionSelected,
    required this.onCropSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Column(
        children: [
          // Action buttons
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => onActionSelected(ActionType.plant),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAction == ActionType.plant ? Colors.blue : null,
                ),
                child: const Text('🌱 Plant'),
              ),
              ElevatedButton(
                onPressed: () => onActionSelected(ActionType.water),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAction == ActionType.water ? Colors.blue : null,
                ),
                child: const Text('💧 Water'),
              ),
              ElevatedButton(
                onPressed: () => onActionSelected(ActionType.fertilize),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAction == ActionType.fertilize ? Colors.blue : null,
                ),
                child: const Text('🧪 Fertilize'),
              ),
              ElevatedButton(
                onPressed: () => onActionSelected(ActionType.harvest),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAction == ActionType.harvest ? Colors.blue : null,
                ),
                child: const Text('✂️ Harvest'),
              ),
              ElevatedButton(
                onPressed: () => onActionSelected(ActionType.unlockCrop),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAction == ActionType.unlockCrop ? Colors.blue : null,
                ),
                child: const Text('🔓 Unlock Crop'),
              ),
              ElevatedButton(
                onPressed: () => onActionSelected(ActionType.talk),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedAction == ActionType.talk ? Colors.blue : null,
                ),
                child: const Text('💬 Talk'),
              ),
            ],
          ),
          // Crop selection
          if (availableCrops.isNotEmpty)
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: availableCrops.map((crop) {
                return ElevatedButton(
                  onPressed: () => onCropSelected(crop),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCrop == crop ? Colors.green : null,
                  ),
                  child: Text('${crop.emoji} ${crop.name}'),
                );
              }).toList(),
            ),

        ],
      ),
    );
  }
}
