import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _showFollowersList() {
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
        builder: (_, controller) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Followers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: 20,
                itemBuilder: (context, index) => _buildFollowerListItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowerListItem(int index) {
    return ListTile(
      leading: Hero(
        tag: 'follower_$index',
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://picsum.photos/200/200?random=$index',
          ),
        ),
      ),
      title: Text('Follower ${index + 1}'),
      subtitle: const Text('Los Angeles, CA'),
      trailing: TextButton(
        onPressed: () {},
        child: const Text('Follow'),
      ),
    );
  }

  void _showPostDetail(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(
          imageUrl: 'https://picsum.photos/500/500?random=$index',
          index: index,
        ),
      ),
    );
  }

  void _showFollowingList() {
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
        builder: (_, controller) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Following',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: 20,
                itemBuilder: (context, index) => _buildFollowingListItem(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowingListItem(int index) {
    return ListTile(
      leading: Hero(
        tag: 'following_$index',
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            'https://picsum.photos/200/200?random=${index + 100}',
          ),
        ),
      ),
      title: Text('Following ${index + 1}'),
      subtitle: const Text('Los Angeles, CA'),
      trailing: TextButton(
        onPressed: () {
          // Handle unfollow
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[600],
        ),
        child: const Text('Following'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Ophelia Coleman',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                // Show account switcher
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement refresh functionality
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildBio(),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 24),
                  _buildStats(),
                  const SizedBox(height: 24),
                  _buildFollowersSection(),
                  const SizedBox(height: 16),
                  _buildTabBar(context),
                ],
              ),
            ),
            _buildPostsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: const NetworkImage('https://picsum.photos/200'),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Los Angeles, CA',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('870', 'Following'),
                    _buildStatColumn('120k', 'Followers'),
                    _buildStatColumn('354k', 'Likes'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildBio() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "I'm a positive person. I love to travel and eat.\nAlways available for chat",
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildIconButton(Icons.message_outlined),
          const SizedBox(width: 8),
          _buildIconButton(Icons.share_outlined),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {},
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildFollowersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Followers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full followers list
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: 10,
            itemBuilder: (context, index) => _buildFollowerItem(index),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowerItem(int index) {
    final List<Map<String, String>> followers = [
      {'name': 'Isaiah', 'image': 'https://picsum.photos/200/200?random=1'},
      {'name': 'Jayden', 'image': 'https://picsum.photos/200/200?random=2'},
      {'name': 'Hunter', 'image': 'https://picsum.photos/200/200?random=3'},
      {'name': 'Ethel', 'image': 'https://picsum.photos/200/200?random=4'},
      {'name': 'Kelly', 'image': 'https://picsum.photos/200/200?random=5'},
    ];
    
    final follower = followers[index % followers.length];
    
    return GestureDetector(
      onTap: () {
        // Navigate to follower profile
      },
      child: Container(
        width: 75,
        margin: const EdgeInsets.symmetric(horizontal: 4),
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
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(follower['image']!),
                    ),
                  ),
                ),
                if (index < 2)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              follower['name']!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Hero(
            tag: 'post_$index',
            child: Material(
              child: InkWell(
                onTap: () => _showPostDetail(index),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/500/500?random=$index',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${(index + 1) * 123}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: 30,
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabItem(context, Icons.grid_on_outlined, true),
            _buildTabItem(context, Icons.play_circle_outline, false),
            _buildTabItem(context, Icons.bookmark_border, false),
          ],
        ),
      ],
    );
  }

  Widget _buildTabItem(BuildContext context, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.black : Colors.grey,
        size: 28,
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => _showFollowingList(),
            child: _buildStatItem('870', 'Following'),
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.grey[300],
          ),
          InkWell(
            onTap: () => _showFollowersList(),
            child: _buildStatItem('120k', 'Followers'),
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildStatItem('354k', 'Likes'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
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
}

class PostDetailScreen extends StatelessWidget {
  final String imageUrl;
  final int index;

  const PostDetailScreen({
    super.key,
    required this.imageUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: 'post_$index',
                child: Image.network(imageUrl),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
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
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage('https://picsum.photos/50/50'),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Ophelia Coleman',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment_outlined, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
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
} 