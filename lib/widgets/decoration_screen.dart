import 'package:flutter/material.dart';

class DecorationScreen extends StatefulWidget {
  const DecorationScreen({super.key});

  @override
  State<DecorationScreen> createState() => _DecorationScreenState();
}

class _DecorationScreenState extends State<DecorationScreen> {
  // All owned decorations
  List<Map<String, dynamic>> ownedDecorations = [
    {'name': 'Garden Gnome', 'emoji': '🧙', 'owned': true},
    {'name': 'Bird Bath', 'emoji': '🛁', 'owned': true},
    {'name': 'Flower Pot', 'emoji': '🏺', 'owned': true},
    {'name': 'Fountain', 'emoji': '⛲', 'owned': true},
    {'name': 'Lantern', 'emoji': '🏮', 'owned': true},
    {'name': 'Tree', 'emoji': '🌳', 'owned': true},
    {'name': 'Mushroom', 'emoji': '🍄', 'owned': true},
    {'name': 'Bench', 'emoji': '🪑', 'owned': true},
  ];

  // Decorations placed in garden
  List<Map<String, dynamic>> placedDecorations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garden Customization'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // TODO: Implement save layout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Layout saved!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Garden area
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Stack(
                children: [
                  // Placed decorations
                  ...placedDecorations.map((decoration) {
                    return Positioned(
                      left: decoration['x'] ?? 50,
                      top: decoration['y'] ?? 50,
                      child: GestureDetector(
                        onLongPress: () => _showDecorationOptions(decoration),
                        child: Draggable(
                          feedback: Transform.rotate(
                            angle: decoration['rotation'] ?? 0,
                            child: Text(
                              decoration['emoji'],
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                          childWhenDragging: const SizedBox(),
                          onDragEnd: (details) {
                            setState(() {
                              decoration['x'] = details.offset.dx;
                              decoration['y'] = details.offset.dy;
                            });
                          },
                          child: Transform.rotate(
                            angle: decoration['rotation'] ?? 0,
                            child: Text(
                              decoration['emoji'],
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Decorations selection
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Your Decorations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ownedDecorations.length,
                      itemBuilder: (context, index) {
                        final decoration = ownedDecorations[index];
                        final owned = decoration['owned'] as bool;
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: owned ? Colors.white : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                decoration['emoji'],
                                style: TextStyle(
                                  fontSize: 30,
                                  color: owned ? Colors.black : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                decoration['name'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: owned ? Colors.black : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (owned)
                                ElevatedButton(
                                  onPressed: () => _placeDecoration(decoration),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    textStyle: const TextStyle(fontSize: 10),
                                  ),
                                  child: const Text('Place'),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _placeDecoration(Map<String, dynamic> decoration) {
    setState(() {
      placedDecorations.add({
        ...decoration,
        'x': 100.0,
        'y': 100.0,
        'rotation': 0.0,
      });
    });
  }

  void _showDecorationOptions(Map<String, dynamic> decoration) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.rotate_right),
              title: const Text('Rotate 45°'),
              onTap: () {
                setState(() {
                  decoration['rotation'] = (decoration['rotation'] ?? 0) + 0.7854; // 45 degrees in radians
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove'),
              onTap: () {
                setState(() => placedDecorations.remove(decoration));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
