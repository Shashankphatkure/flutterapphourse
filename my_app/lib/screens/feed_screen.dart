import 'package:flutter/material.dart';
import 'dart:math';
import 'messages_screen.dart';
import 'notifications_screen.dart';
import 'story_maker_screen.dart';
import 'story_view_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final Map<int, bool> _likedPosts = {};
  final Map<int, bool> _savedPosts = {};

  final List<Map<String, String>> _users = [
    {
      'name': 'Sarah Johnson',
      'username': 'dressage_pro',
      'avatar': 'https://picsum.photos/200?random=1',
      'isVerified': 'true',
      'location': 'Wellington Equestrian Center, FL',
      'type': 'Professional Rider'
    },
    {
      'name': 'Mike Thompson',
      'username': 'horse_whisperer',
      'avatar': 'https://picsum.photos/200?random=2',
      'isVerified': 'true',
      'location': 'Kentucky Horse Park',
      'type': 'Horse Trainer'
    },
    {
      'name': 'Emma Davis',
      'username': 'show_jumper',
      'avatar': 'https://picsum.photos/200?random=3',
      'isVerified': 'true',
      'location': 'Royal Stables',
      'type': 'Show Jumper'
    },
    {
      'name': 'Equine Vet Care',
      'username': 'equine_health',
      'avatar': 'https://picsum.photos/200?random=4',
      'isVerified': 'true',
      'location': 'Mobile Veterinary Service',
      'type': 'Veterinary Practice'
    },
  ];

  void _toggleLike(int index) {
    setState(() {
      _likedPosts[index] = !(_likedPosts[index] ?? false);
    });
  }

  void _toggleSave(int index) {
    setState(() {
      _savedPosts[index] = !(_savedPosts[index] ?? false);
    });
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => _buildCommentsSheet(controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'equico',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.messenger_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagesScreen(),
                ),
              );
            },
            color: Colors.black,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            color: Colors.black,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildStorySection(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPostCard(index),
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorySection() {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildYourStory(),
          ...List.generate(4, (index) => _buildStoryItem(index)),
        ],
      ),
    );
  }

  Widget _buildYourStory() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StoryMakerScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage('https://picsum.photos/200'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7ED957),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Your Story',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(int index) {
    final bool hasUnseenStory = index % 2 == 0;
    return GestureDetector(
      onTap: () {
        _viewStory(index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnseenStory
                    ? const LinearGradient(
                        colors: [Color(0xFF7ED957), Color(0xFF5BC236)],
                      )
                    : null,
                border: !hasUnseenStory
                    ? Border.all(color: Colors.grey[300]!, width: 1)
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/200?random=$index'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'User $index',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(int index) {
    final user = _users[index % _users.length];
    final bool isLiked = _likedPosts[index] ?? false;
    final bool isSaved = _savedPosts[index] ?? false;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: GestureDetector(
              onTap: () {
                // Navigate to profile
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(user['avatar']!),
              ),
            ),
            title: Row(
              children: [
                Text(
                  user['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (user['isVerified'] == 'true') ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    size: 14,
                    color: Color(0xFF7ED957),
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['location']!),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ED957).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user['type']!,
                    style: TextStyle(
                      color: const Color(0xFF7ED957),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () => _showPostOptions(context, index),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: GestureDetector(
                onDoubleTap: () => _toggleLike(index),
                child: Stack(
                  children: [
                    Image.network(
                      'https://picsum.photos/600/400?random=$index',
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                    if (_likedPosts[index] ?? false)
                      Center(
                        child: AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                      onPressed: () => _toggleLike(index),
                    ),
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline,
                      onPressed: () => _showComments(context),
                    ),
                    _buildActionButton(
                      icon: Icons.share_outlined,
                      onPressed: () => _showShareOptions(context),
                    ),
                    const Spacer(),
                    _buildActionButton(
                      icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                      onPressed: () => _toggleSave(index),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${Random().nextInt(1000)} likes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '${user['username']} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: _getRandomCaption()),
                      TextSpan(
                        text: '\n\n${_getRandomHashtags()}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Random().nextInt(24)} hours ago',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRandomCaption() {
    final List<String> captions = [
      'Just finished an amazing dressage session! The progress we\'re making is incredible 🐎 #DressageLife #HorseTraining',
      'Early morning practice at the jumping arena. This horse has so much potential! 🏆 #ShowJumping #EquestrianLife',
      'Beautiful day for cross-country training. Nature + Horses = Perfect Day 🌿 #Eventing #CrossCountry',
      'Working on new techniques with this talented mare. Her lateral work is improving daily ✨ #HorseTraining #Dressage',
      'Competition prep in full swing! Can\'t wait for next week\'s show 🎯 #ShowPrep #Competition',
      'Just completed our veterinary check-up. Health always comes first! 🏥 #HorseHealth #EquestrianCare',
      'New personal best in today\'s training session! So proud of our progress 🌟 #Achievements #HorseLife',
    ];
    return captions[Random().nextInt(captions.length)];
  }

  String _getRandomHashtags() {
    final List<String> hashtags = [
      '#Equestrian #HorseLife #RiderLife',
      '#EquestrianLife #HorseLover #RidingLife',
      '#HorseTraining #EquestrianSport',
      '#DressageLife #HorseShow #Competition',
      '#ShowJumping #HorsemanShip #Training'
    ];
    return hashtags[Random().nextInt(hashtags.length)];
  }

  Widget _buildActionButton({
    required IconData icon,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon),
      color: color,
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(),
    );
  }

  void _showPostOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildPostOptionItem(
              icon: Icons.bookmark_border,
              label: 'Save Post',
              onTap: () {
                _toggleSave(index);
                Navigator.pop(context);
              },
            ),
            _buildPostOptionItem(
              icon: Icons.share_outlined,
              label: 'Share Post',
              onTap: () {
                _showShareOptions(context);
                Navigator.pop(context);
              },
            ),
            _buildPostOptionItem(
              icon: Icons.person_remove_outlined,
              label: 'Unfollow',
              onTap: () {
                // Implement unfollow
                Navigator.pop(context);
              },
            ),
            _buildPostOptionItem(
              icon: Icons.report_outlined,
              label: 'Report Post',
              isDestructive: true,
              onTap: () {
                // Implement report
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share to Story'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Copy Link'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSheet(ScrollController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: controller,
            itemCount: 20,
            itemBuilder: (context, index) => _buildCommentItem(index),
          ),
        ),
        _buildCommentInput(),
      ],
    );
  }

  Widget _buildCommentItem(int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://picsum.photos/200?random=$index'),
      ),
      title: Row(
        children: [
          Text(
            'User $index',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            '${index + 1}m',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      subtitle: const Text('Great post! 🔥'),
      trailing: const Icon(Icons.favorite_border),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://picsum.photos/200'),
            radius: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Implement post comment
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTag(String location) {
    return GestureDetector(
      onTap: () {
        // Navigate to location view
      },
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            size: 16,
            color: Color(0xFF7ED957),
          ),
          const SizedBox(width: 4),
          Text(
            location,
            style: const TextStyle(
              color: Color(0xFF7ED957),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGalleryIndicator() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              '1/4',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDoubleTap(int index) {
    setState(() {
      if (!(_likedPosts[index] ?? false)) {
        _likedPosts[index] = true;
        _showLikeAnimation(index);
      }
    });
  }

  void _showLikeAnimation(int index) {
    // Implement heart animation
  }

  void _viewStory(int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => StoryViewScreen(
          initialIndex: index,
          stories: List.generate(
            4,
            (i) => StoryItem(
              imageUrl: 'https://picsum.photos/800/1200?random=${index + i}',
              username: _users[index % _users.length]['name']!,
              timestamp: '${Random().nextInt(24)}h ago',
              location: _users[index % _users.length]['location']!,
              isVerified: _users[index % _users.length]['isVerified'] == 'true',
              caption: _getRandomCaption(),
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
} 