import 'package:flutter/material.dart';

class StoryItem {
  final String imageUrl;
  final String username;
  final String timestamp;
  final String location;
  final bool isVerified;
  final int likeCount;
  final List<String> mentions;
  final String caption;

  StoryItem({
    required this.imageUrl,
    required this.username,
    required this.timestamp,
    this.location = '',
    this.isVerified = false,
    this.likeCount = 0,
    this.mentions = const [],
    this.caption = '',
  });
}

class StoryViewScreen extends StatefulWidget {
  final int initialIndex;
  final List<StoryItem> stories;

  const StoryViewScreen({
    super.key,
    required this.initialIndex,
    required this.stories,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isLiked = false;
  bool _isPaused = false;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextStory();
        }
      });
    _progressController.forward();
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _handleStoryTap(TapUpDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth * 0.3) {
      // Tap on left side - go to previous story
      if (_currentIndex > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (tapPosition > screenWidth * 0.7) {
      // Tap on right side - go to next story
      _nextStory();
    } else {
      // Tap in middle - pause/resume
      setState(() {
        _isPaused = !_isPaused;
        if (_isPaused) {
          _progressController.stop();
        } else {
          _progressController.forward();
        }
      });
    }
  }

  void _handleLongPressStart(_) {
    setState(() {
      _isPaused = true;
      _progressController.stop();
    });
  }

  void _handleLongPressEnd(_) {
    setState(() {
      _isPaused = false;
      _progressController.forward();
    });
  }

  void _animateLike() {
    setState(() {
      _isLiked = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLiked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: _handleStoryTap,
        onLongPressStart: _handleLongPressStart,
        onLongPressEnd: _handleLongPressEnd,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _progressController.reset();
                  _progressController.forward();
                });
              },
              itemBuilder: (context, index) => _buildStoryItem(index),
            ),
            _buildStoryOverlay(),
            if (_isLiked)
              Center(
                child: AnimatedOpacity(
                  opacity: _isLiked ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
            _buildReplyInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(int index) {
    final story = widget.stories[index];
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          story.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        if (story.caption.isNotEmpty)
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Text(
              story.caption,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStoryOverlay() {
    final story = widget.stories[_currentIndex];
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: widget.stories.asMap().entries.map((entry) {
                return Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: LinearProgressIndicator(
                      value: entry.key == _currentIndex
                          ? _progressController.value
                          : entry.key < _currentIndex
                              ? 1.0
                              : 0.0,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(story.imageUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            story.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (story.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF7ED957),
                              size: 14,
                            ),
                          ],
                        ],
                      ),
                      if (story.location.isNotEmpty)
                        Text(
                          story.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  story.timestamp,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: _showStoryOptions,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black87,
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _replyController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Reply to story...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white24,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                ),
                onPressed: _animateLike,
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (_replyController.text.isNotEmpty) {
                    // Implement reply sending
                    _replyController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStoryOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.report, color: Colors.white),
            title: const Text(
              'Report Story',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              // Implement report
            },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.white),
            title: const Text(
              'Share Story',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              // Implement share
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    _replyController.dispose();
    super.dispose();
  }
} 