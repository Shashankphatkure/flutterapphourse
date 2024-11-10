import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:just_audio/just_audio.dart';

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

  // Media handling
  List<StoryMedia> _mediaItems = [];
  int _currentMediaIndex = 0;
  VideoPlayerController? _videoController;
  
  // Drawing
  List<DrawingPoint> _drawingPoints = [];
  Color _drawingColor = Colors.white;
  double _brushSize = 5.0;
  
  // Stickers and GIFs
  List<StoryElement> _storyElements = [];
  
  // Music
  AudioPlayer? _audioPlayer;
  String? _selectedMusicUrl;
  
  // Interactive elements
  PollData? _pollData;
  String? _question;
  
  // Layout and effects
  String _selectedLayout = 'full';
  String _backgroundEffect = 'none';
  List<String> _mentions = [];
  String? _location;
  
  // Text styling
  TextAlign _textAlign = TextAlign.center;
  FontWeight _fontWeight = FontWeight.normal;
  double _letterSpacing = 0;
  List<Shadow> _textShadows = [];

  bool _isDrawing = false;

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
            icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
            onPressed: _pickMedia,
          ),
          IconButton(
            icon: const Icon(Icons.text_fields, color: Colors.white),
            onPressed: _toggleTextEditor,
          ),
          IconButton(
            icon: const Icon(Icons.brush, color: Colors.white),
            onPressed: _toggleDrawingMode,
          ),
          IconButton(
            icon: const Icon(Icons.music_note, color: Colors.white),
            onPressed: _showMusicPicker,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Media display
          _buildMediaDisplay(),
          
          // Drawing overlay
          if (_isDrawing) _buildDrawingCanvas(),
          
          // Story elements (stickers, text, etc.)
          ..._storyElements.map((element) => _buildDraggableElement(element)),
          
          // Bottom toolbar
          _buildBottomToolbar(),
          
          // Side toolbar
          _buildSideToolbar(),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.style, color: Colors.white),
                onPressed: _showLayoutOptions,
              ),
              IconButton(
                icon: const Icon(Icons.emoji_emotions, color: Colors.white),
                onPressed: _showStickersAndGifs,
              ),
              IconButton(
                icon: const Icon(Icons.poll, color: Colors.white),
                onPressed: _showPollCreator,
              ),
              IconButton(
                icon: const Icon(Icons.person_add, color: Colors.white),
                onPressed: _showMentionsPicker,
              ),
              IconButton(
                icon: const Icon(Icons.location_on, color: Colors.white),
                onPressed: _showLocationPicker,
              ),
            ],
          ),
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

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take Photo'),
            onTap: () => _captureMedia(ImageSource.camera, MediaType.photo),
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Record Video'),
            onTap: () => _captureMedia(ImageSource.camera, MediaType.video),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => _pickFromGallery(),
          ),
        ],
      ),
    );
  }

  void _showStickersAndGifs() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        builder: (context, scrollController) => DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Stickers'),
                  Tab(text: 'GIFs'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildStickerPicker(scrollController),
                    _buildGiphyPicker(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPollCreator() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Poll'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Question',
              ),
              onChanged: (value) => _question = value,
            ),
            const SizedBox(height: 8),
            // Add option fields
            ...List.generate(
              2,
              (index) => TextField(
                decoration: InputDecoration(
                  hintText: 'Option ${index + 1}',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Create and add poll
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildSideToolbar() {
    return Positioned(
      right: 16,
      top: 100,
      child: Column(
        children: [
          _buildToolbarButton(
            icon: Icons.format_paint,
            label: 'Effects',
            onTap: _showBackgroundEffects,
          ),
          _buildToolbarButton(
            icon: Icons.auto_fix_high,
            label: 'Magic',
            onTap: _showMagicEffects,
          ),
          _buildToolbarButton(
            icon: Icons.layers,
            label: 'Layers',
            onTap: _showLayersPanel,
          ),
          _buildToolbarButton(
            icon: Icons.timer,
            label: 'Duration',
            onTap: _showDurationPicker,
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(icon, color: Colors.white),
              onPressed: onTap,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvancedTextEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (context, scrollController) => Column(
          children: [
            AppBar(
              title: const Text('Text Style'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Font family selector
                  _buildFontFamilySelector(),
                  const Divider(),
                  
                  // Text alignment
                  _buildTextAlignmentSelector(),
                  const Divider(),
                  
                  // Text effects
                  _buildTextEffectsSection(),
                  const Divider(),
                  
                  // Letter spacing
                  _buildLetterSpacingSlider(),
                  const Divider(),
                  
                  // Text background
                  _buildTextBackgroundSelector(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextEffectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Text Effects', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            _buildEffectChip('Shadow'),
            _buildEffectChip('Neon'),
            _buildEffectChip('Outline'),
            _buildEffectChip('Gradient'),
            _buildEffectChip('Glitter'),
          ],
        ),
      ],
    );
  }

  Widget _buildDrawingCanvas() {
    return Stack(
      children: [
        // Drawing area
        GestureDetector(
          onPanStart: _onDrawingPanStart,
          onPanUpdate: _onDrawingPanUpdate,
          onPanEnd: _onDrawingPanEnd,
          child: CustomPaint(
            painter: DrawingPainter(points: _drawingPoints),
            size: Size.infinite,
          ),
        ),
        
        // Drawing tools
        Positioned(
          left: 16,
          top: 100,
          child: Column(
            children: [
              _buildDrawingTool(Icons.brush, 'Brush'),
              _buildDrawingTool(Icons.gesture, 'Marker'),
              _buildDrawingTool(Icons.lens_outlined, 'Neon'),
              _buildDrawingTool(Icons.auto_awesome, 'Glitter'),
              _buildDrawingTool(Icons.format_paint, 'Fill'),
            ],
          ),
        ),
        
        // Color picker
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildColorPicker(),
                _buildBrushSizePicker(),
                _buildOpacityPicker(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMusicPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (context, scrollController) => DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Music'),
                  Tab(text: 'Sound Effects'),
                  Tab(text: 'Voice'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildMusicLibrary(scrollController),
                    _buildSoundEffects(scrollController),
                    _buildVoiceRecorder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _toggleTextEditor() {
    setState(() {
      _isEditing = !_isEditing;
      _isDrawing = false;
    });
    return _isEditing;
  }

  bool _toggleDrawingMode() {
    setState(() {
      _isDrawing = !_isDrawing;
      _isEditing = false;
    });
    return _isDrawing;
  }

  Widget _buildMediaDisplay() {
    if (_mediaItems.isEmpty) {
      return ColorFiltered(
        colorFilter: _getColorFilter(),
        child: Image.network(
          'https://picsum.photos/800/1600',
          fit: BoxFit.cover,
        ),
      );
    }
    
    final currentMedia = _mediaItems[_currentMediaIndex];
    if (currentMedia.type == MediaType.photo) {
      return ColorFiltered(
        colorFilter: _getColorFilter(),
        child: Image.network(
          currentMedia.url,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Center(child: Text('Video player here'));
    }
  }

  Widget _buildDraggableElement(StoryElement element) {
    return Positioned(
      left: element.position.dx,
      top: element.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            element.position += details.delta;
          });
        },
        child: Transform.scale(
          scale: element.scale,
          child: Transform.rotate(
            angle: element.rotation,
            child: _buildElementContent(element),
          ),
        ),
      ),
    );
  }

  Widget _buildElementContent(StoryElement element) {
    switch (element.type) {
      case ElementType.text:
        return Text(
          element.content as String,
          style: TextStyle(
            color: _textColor,
            fontSize: _textSize,
          ),
        );
      case ElementType.sticker:
        return Image.network(
          element.content as String,
          width: 100,
          height: 100,
        );
      default:
        return const SizedBox();
    }
  }

  Future<void> _captureMedia(ImageSource source, MediaType type) async {
    final picker = ImagePicker();
    Navigator.pop(context);
    
    try {
      if (type == MediaType.photo) {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _mediaItems.add(StoryMedia(
              url: image.path,
              type: MediaType.photo,
            ));
          });
        }
      } else {
        final XFile? video = await picker.pickVideo(source: source);
        if (video != null) {
          setState(() {
            _mediaItems.add(StoryMedia(
              url: video.path,
              type: MediaType.video,
              duration: const Duration(seconds: 15), // Default duration
            ));
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing media: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    final picker = ImagePicker();
    try {
      final List<XFile> files = await picker.pickMultiImage();
      if (files.isNotEmpty) {
        setState(() {
          _mediaItems.addAll(
            files.map((file) => StoryMedia(
              url: file.path,
              type: MediaType.photo,
            )),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking from gallery: $e')),
      );
    }
  }

  void _showLayoutOptions() {
    // TODO: Implement layout options
  }

  void _showMentionsPicker() {
    // TODO: Implement mentions picker
  }

  void _showLocationPicker() {
    // TODO: Implement location picker
  }

  void _showBackgroundEffects() {
    // TODO: Implement background effects
  }

  void _showMagicEffects() {
    // TODO: Implement magic effects
  }

  void _showLayersPanel() {
    // TODO: Implement layers panel
  }

  void _showDurationPicker() {
    // TODO: Implement duration picker
  }

  // Drawing related methods
  void _onDrawingPanStart(DragStartDetails details) {
    final paint = Paint()
      ..color = _drawingColor
      ..strokeWidth = _brushSize
      ..strokeCap = StrokeCap.round;

    setState(() {
      _drawingPoints.add(DrawingPoint(
        offset: details.localPosition,
        paint: paint,
      ));
    });
  }

  void _onDrawingPanUpdate(DragUpdateDetails details) {
    final paint = Paint()
      ..color = _drawingColor
      ..strokeWidth = _brushSize
      ..strokeCap = StrokeCap.round;

    setState(() {
      _drawingPoints.add(DrawingPoint(
        offset: details.localPosition,
        paint: paint,
      ));
    });
  }

  void _onDrawingPanEnd(DragEndDetails details) {
    setState(() {
      // Add a null point to indicate the end of a line
      _drawingPoints.add(DrawingPoint(
        offset: Offset.zero,
        paint: Paint(),
      ));
    });
  }

  Widget _buildFontFamilySelector() {
    final fonts = [
      'Default',
      'Roboto',
      'Playfair',
      'Montserrat',
      'Dancing Script',
      'Pacifico',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Font Family', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fonts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  label: Text(fonts[index]),
                  selected: false, // TODO: Implement font selection
                  onSelected: (selected) {
                    // TODO: Apply font
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextAlignmentSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alignment', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.format_align_left),
              onPressed: () => setState(() => _textAlign = TextAlign.left),
              color: _textAlign == TextAlign.left ? Colors.blue : null,
            ),
            IconButton(
              icon: const Icon(Icons.format_align_center),
              onPressed: () => setState(() => _textAlign = TextAlign.center),
              color: _textAlign == TextAlign.center ? Colors.blue : null,
            ),
            IconButton(
              icon: const Icon(Icons.format_align_right),
              onPressed: () => setState(() => _textAlign = TextAlign.right),
              color: _textAlign == TextAlign.right ? Colors.blue : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLetterSpacingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Letter Spacing', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _letterSpacing,
          min: -2,
          max: 10,
          divisions: 24,
          label: _letterSpacing.toStringAsFixed(1),
          onChanged: (value) => setState(() => _letterSpacing = value),
        ),
      ],
    );
  }

  Widget _buildTextBackgroundSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Background Style', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            _buildBackgroundOption('None', Colors.transparent),
            _buildBackgroundOption('Solid', Colors.black54),
            _buildBackgroundOption('Gradient', Colors.blue),
            _buildBackgroundOption('Highlight', Colors.yellow.withOpacity(0.5)),
          ],
        ),
      ],
    );
  }

  Widget _buildBackgroundOption(String label, Color color) {
    return GestureDetector(
      onTap: () {
        // TODO: Apply background style
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEffectChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: false, // TODO: Implement effect selection
      onSelected: (selected) {
        // TODO: Apply text effect
      },
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => _drawingColor = _colors[index]),
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _colors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: _drawingColor == _colors[index] ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrushSizePicker() {
    return Container(
      width: 100,
      child: Slider(
        value: _brushSize,
        min: 1,
        max: 20,
        onChanged: (value) => setState(() => _brushSize = value),
      ),
    );
  }

  Widget _buildOpacityPicker() {
    return Container(
      width: 100,
      child: Slider(
        value: _drawingColor.opacity,
        min: 0,
        max: 1,
        onChanged: (value) => setState(() {
          _drawingColor = _drawingColor.withOpacity(value);
        }),
      ),
    );
  }

  Widget _buildDrawingTool(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              icon: Icon(icon, color: Colors.white),
              onPressed: () {
                // TODO: Implement drawing tool selection
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerPicker(ScrollController scrollController) {
    // TODO: Implement sticker grid
    return GridView.builder(
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return const Center(child: Text('Sticker'));
      },
    );
  }

  Widget _buildGiphyPicker() {
    // TODO: Implement GIPHY integration
    return const Center(child: Text('GIPHY Picker'));
  }

  Widget _buildMusicLibrary(ScrollController scrollController) {
    // TODO: Implement music library
    return const Center(child: Text('Music Library'));
  }

  Widget _buildSoundEffects(ScrollController scrollController) {
    // TODO: Implement sound effects
    return const Center(child: Text('Sound Effects'));
  }

  Widget _buildVoiceRecorder() {
    // TODO: Implement voice recorder
    return const Center(child: Text('Voice Recorder'));
  }
}

class StoryMedia {
  final String url;
  final MediaType type;
  final Duration? duration;

  StoryMedia({
    required this.url,
    required this.type,
    this.duration,
  });
}

class StoryElement {
  final ElementType type;
  final dynamic content;
  Offset position;
  double scale;
  double rotation;

  StoryElement({
    required this.type,
    required this.content,
    this.position = const Offset(0, 0),
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}

enum MediaType { photo, video }
enum ElementType { text, sticker, gif, poll, mention, location }

class DrawingPoint {
  final Offset offset;
  final Paint paint;
  
  DrawingPoint({required this.offset, required this.paint});
}

class PollData {
  final String question;
  final List<String> options;
  final Duration duration;
  
  PollData({
    required this.question,
    required this.options,
    this.duration = const Duration(hours: 24),
  });
}

class BackgroundEffect {
  final String name;
  final List<Color> colors;
  final BlendMode blendMode;
  
  BackgroundEffect({
    required this.name,
    required this.colors,
    this.blendMode = BlendMode.srcOver,
  });
}

final List<String> _advancedFilters = [
  'none',
  'grayscale',
  'sepia',
  'vintage',
  'blur',
  'sharpen',
  'vignette',
  'brightness',
  'contrast',
  'saturation',
  'hue',
  'temperature',
];

final List<BackgroundEffect> _backgroundEffects = [
  BackgroundEffect(
    name: 'Gradient',
    colors: [Colors.purple, Colors.blue],
  ),
  BackgroundEffect(
    name: 'Sparkle',
    colors: [Colors.white, Colors.yellow],
    blendMode: BlendMode.screen,
  ),
  // Add more effects...
];

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i + 1].offset == Offset.zero) continue;
      canvas.drawLine(
        points[i].offset,
        points[i + 1].offset,
        points[i].paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}