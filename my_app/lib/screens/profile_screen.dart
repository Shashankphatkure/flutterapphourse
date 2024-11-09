import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _tabs = ['Posts', 'Media', 'Tagged'];
  int _selectedTabIndex = 0;

  // Mock user data
  final UserProfile _userProfile = UserProfile(
    displayName: 'Sarah Anderson',
    username: '@equestrianlife',
    profileHeading: 'Professional Equestrian | Dressage Trainer',
    bio: '🐎 Living my dream with horses\n'
         '🏆 National Dressage Champion 2023\n'
         '📍 Wellington Equestrian Center\n'
         '🔗 equestrian.life/sarah',
    profileImage: 'https://picsum.photos/500/500',
    isVerified: true,
    followers: 24563,
    following: 152,
    hasActiveStory: true,
    stories: [
      StoryItem(
        imageUrl: 'https://picsum.photos/800/1200?random=1',
        username: '@equestrianlife',
        timestamp: '2h ago',
        location: 'Wellington Stables',
        caption: 'Morning training session with Luna 🐎✨',
      ),
      StoryItem(
        imageUrl: 'https://picsum.photos/800/1200?random=2',
        username: '@equestrianlife',
        timestamp: '5h ago',
        caption: 'Perfect weather for dressage practice!',
      ),
    ],
  );

  // Mock data
  final List<Post> _posts = List.generate(
    10,
    (index) => Post(
      imageUrl: 'https://picsum.photos/500/500?random=$index',
      caption: 'Beautiful day at the stables! #HorseLife #Equestrian',
      likes: 234 + index,
      commentCount: 45 + index,
      timeAgo: '${index + 1}h ago',
      comments: [
        Comment(
          username: '@user1',
          text: 'Great post!',
          timeAgo: '1h ago',
          userAvatar: 'https://picsum.photos/200/200?random=1',
          likes: 10,
        ),
        Comment(
          username: '@user2',
          text: 'Thanks for sharing!',
          timeAgo: '2h ago',
          userAvatar: 'https://picsum.photos/200/200?random=2',
          likes: 5,
        ),
      ],
    ),
  );

  final List<MediaItem> _mediaItems = List.generate(
    15,
    (index) => MediaItem(
      url: 'https://picsum.photos/400/400?random=$index',
      type: index % 3 == 0 ? MediaType.video : MediaType.image,
      duration: index % 3 == 0 ? const Duration(minutes: 1, seconds: 30) : null,
    ),
  );

  final List<TaggedPost> _taggedPosts = List.generate(
    8,
    (index) => TaggedPost(
      imageUrl: 'https://picsum.photos/400/400?random=${index + 20}',
      taggedBy: 'user_${index + 1}',
      location: 'Horse Event $index',
      timeAgo: '${index + 2}d ago',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(_userProfile.username),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareProfile,
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () => _showProfileOptions(),
              ),
            ],
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () async {
            // Implement refresh logic
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    _buildActionButtons(),
                    _buildHighlights(),
                    _buildTabBar(),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    _formatNumber(_userProfile.followers),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _userProfile.hasActiveStory ? _viewStories : null,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _userProfile.hasActiveStory
                        ? const LinearGradient(
                            colors: [Color(0xFF7ED957), Color(0xFF7ED957)],
                          )
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_userProfile.profileImage),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _formatNumber(_userProfile.following),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                _userProfile.displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_userProfile.isVerified) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified,
                  color: Color(0xFF7ED957),
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _userProfile.profileHeading,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _userProfile.bio,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlights() {
    final highlights = [
      {'title': 'Training', 'icon': Icons.sports_handball},
      {'title': 'Events', 'icon': Icons.event},
      {'title': 'Competitions', 'icon': Icons.emoji_events},
      {'title': 'Stable Life', 'icon': Icons.home},
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: highlights.length,
        itemBuilder: (context, index) {
          final highlight = highlights[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    highlight['icon'] as IconData,
                    size: 30,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  highlight['title'] as String,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _viewStories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewScreen(
          initialIndex: 0,
          stories: _userProfile.stories,
        ),
      ),
    );
  }

  Widget _buildStats(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('FOLLOW'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('MESSAGE'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final isSelected = entry.key == _selectedTabIndex;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTabIndex = entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? Colors.green : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildPostsGrid();
      case 1:
        return _buildMediaGrid();
      case 2:
        return _buildTaggedGrid();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPostsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return GestureDetector(
          onTap: () => _showPostDetails(post),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                post.imageUrl,
                fit: BoxFit.cover,
              ),
              if (index % 5 == 0) // Show stats for some posts
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    color: Colors.black54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _mediaItems.length,
      itemBuilder: (context, index) {
        final media = _mediaItems[index];
        return GestureDetector(
          onTap: () => _showMediaDetails(media),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                media.url,
                fit: BoxFit.cover,
              ),
              if (media.type == MediaType.video)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          _formatDuration(media.duration!),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaggedGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _taggedPosts.length,
      itemBuilder: (context, index) {
        final tagged = _taggedPosts[index];
        return GestureDetector(
          onTap: () => _showTaggedDetails(tagged),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                tagged.imageUrl,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        tagged.taggedBy,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPostDetails(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (context, scrollController) => PostDetailSheet(post: post),
      ),
    );
  }

  void _showMediaDetails(MediaItem media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (context, scrollController) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              AppBar(
                title: Text(media.type == MediaType.video ? 'Video' : 'Photo'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: media.type == MediaType.video
                    ? VideoPlayerWidget(url: media.url)
                    : Image.network(media.url, fit: BoxFit.contain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaggedDetails(TaggedPost tagged) {
    // Implement tagged post viewer
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Profile'),
            onTap: () {
              Navigator.pop(context);
              _shareProfile();
            },
          ),
        ],
      ),
    );
  }

  void _shareProfile() {
    // TODO: Implement actual sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing profile...')),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

class Post {
  final String imageUrl;
  final String caption;
  final int likes;
  final int commentCount;
  final String timeAgo;
  final List<Comment> comments;

  Post({
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.commentCount,
    required this.timeAgo,
    this.comments = const [],
  });
}

class MediaItem {
  final String url;
  final MediaType type;
  final Duration? duration;

  MediaItem({
    required this.url,
    required this.type,
    this.duration,
  });
}

enum MediaType { image, video }

class TaggedPost {
  final String imageUrl;
  final String taggedBy;
  final String location;
  final String timeAgo;

  TaggedPost({
    required this.imageUrl,
    required this.taggedBy,
    required this.location,
    required this.timeAgo,
  });
}

class PostDetailSheet extends StatefulWidget {
  final Post post;

  const PostDetailSheet({super.key, required this.post});

  @override
  State<PostDetailSheet> createState() => _PostDetailSheetState();
}

class _PostDetailSheetState extends State<PostDetailSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Post'),
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        widget.post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      _buildPostActions(),
                      _buildPostDetails(),
                      const Divider(),
                      _buildCommentsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostActions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.red[400]),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.comment_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPostDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.post.likes} likes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.post.caption),
          const SizedBox(height: 8),
          Text(
            widget.post.timeAgo,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.post.comments.length,
      itemBuilder: (context, index) {
        final comment = widget.post.comments[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.userAvatar),
          ),
          title: Text(comment.username),
          subtitle: Text(comment.text),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, size: 16),
                onPressed: () {},
              ),
              Text('${comment.likes}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement comment posting
              _commentController.clear();
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_isInitialized)
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Comment {
  final String username;
  final String text;
  final String timeAgo;
  final String userAvatar;
  final int likes;

  Comment({
    required this.username,
    required this.text,
    required this.timeAgo,
    required this.userAvatar,
    this.likes = 0,
  });
}

class UserProfile {
  final String displayName;
  final String username;
  final String profileHeading;
  final String bio;
  final String profileImage;
  final bool isVerified;
  final List<StoryItem> stories;
  final int followers;
  final int following;
  final bool hasActiveStory;

  UserProfile({
    required this.displayName,
    required this.username,
    required this.profileHeading,
    required this.bio,
    required this.profileImage,
    this.isVerified = false,
    this.stories = const [],
    required this.followers,
    required this.following,
    this.hasActiveStory = false,
  });
}

class StoryItem {
  final String imageUrl;
  final String username;
  final String timestamp;
  final String location;
  final String caption;

  StoryItem({
    required this.imageUrl,
    required this.username,
    required this.timestamp,
    this.location = '',
    this.caption = '',
  });
}

class StoryViewScreen extends StatefulWidget {
  final int initialIndex;
  final List<StoryItem> stories;

  const StoryViewScreen({super.key, required this.initialIndex, required this.stories});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stories[_currentIndex].username),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: PageController(initialPage: _currentIndex),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.stories.length,
        itemBuilder: (context, index) {
          final story = widget.stories[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                story.imageUrl,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, color: Colors.white, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        story.username,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 