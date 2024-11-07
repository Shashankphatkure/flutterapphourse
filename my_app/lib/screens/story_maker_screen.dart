import 'package:flutter/material.dart';

class StoryMakerScreen extends StatefulWidget {
  const StoryMakerScreen({super.key});

  @override
  State<StoryMakerScreen> createState() => _StoryMakerScreenState();
}

class _StoryMakerScreenState extends State<StoryMakerScreen> {
  String _selectedFilter = 'none';
  double _textSize = 20;
  Color _textColor = Colors.white;
  String _text = '';
  bool _isEditing = false;

  final List<String> _filters = ['none', 'grayscale', 'sepia', 'vintage'];
  final List<Color> _colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields, color: Colors.white),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter, color: Colors.white),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _shareStory,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isEditing = false;
          });
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image with filter
            ColorFiltered(
              colorFilter: _getColorFilter(),
              child: Image.network(
                'https://picsum.photos/800/1600',
                fit: BoxFit.cover,
              ),
            ),
            // Text overlay
            if (_text.isNotEmpty || _isEditing)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: _isEditing
                      ? TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textColor,
                            fontSize: _textSize,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type something...',
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _text = value;
                            });
                          },
                        )
                      : Text(
                          _text,
                          style: TextStyle(
                            color: _textColor,
                            fontSize: _textSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            // Bottom controls
            if (_isEditing)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text size slider
                      Row(
                        children: [
                          const Icon(Icons.text_fields, color: Colors.white),
                          Expanded(
                            child: Slider(
                              value: _textSize,
                              min: 14,
                              max: 48,
                              onChanged: (value) {
                                setState(() {
                                  _textSize = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      // Color picker
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _colors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _textColor = _colors[index];
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: _colors[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _textColor == _colors[index]
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
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
      ),
    );
  }

  ColorFilter _getColorFilter() {
    switch (_selectedFilter) {
      case 'grayscale':
        return const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      case 'sepia':
        return const ColorFilter.matrix([
          0.393, 0.769, 0.189, 0, 0,
          0.349, 0.686, 0.168, 0, 0,
          0.272, 0.534, 0.131, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      case 'vintage':
        return const ColorFilter.matrix([
          0.9, 0.5, 0.1, 0, 0,
          0.3, 0.8, 0.1, 0, 0,
          0.2, 0.3, 0.5, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      default:
        return const ColorFilter.mode(
          Colors.transparent,
          BlendMode.srcOver,
        );
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedFilter == filter
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                            child: ColorFiltered(
                              colorFilter: _getColorFilter(),
                              child: Image.network(
                                'https://picsum.photos/100/100',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            filter.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareStory() {
    // Implement story sharing
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Story shared!')),
    );
  }
} 