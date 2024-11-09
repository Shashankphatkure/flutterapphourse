import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isFollowing = false;

  final Map<String, dynamic> _profileData = {
    'name': 'Emma Thompson',
    'username': '@emma_equestrian',
    'bio': 'Professional Show Jumper 🏆\nTraining horses with love and dedication\nBased in Wellington, FL',
    'type': 'Professional Rider',
    'achievements': [
      '🏆 National Champion 2023',
      '🥇 Olympic Qualifier',
      '🌟 FEI World Cup Finalist'
    ],
    'horses': [
      {
        'name': 'Thunder Spirit',
        'breed': 'Dutch Warmblood',
        'image': 'https://picsum.photos/200/200?random=1',
      },
      {
        'name': 'Royal Star',
        'breed': 'Hanoverian',
        'image': 'https://picsum.photos/200/200?random=2',
      },
      {
        'name': 'Silver Moon',
        'breed': 'Holsteiner',
        'image': 'https://picsum.photos/200/200?random=3',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://picsum.photos/800/400',
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareProfile,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _showProfileOptions,
              ),
            ],
          ),
        ],
        body: Column(
          children: [
            _buildProfileHeader(),
            _buildBioSection(),
            _buildActionButtons(),
            _buildAchievements(),
            _buildHorsesList(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPostsGrid(),
                  _buildCompetitionsTab(),
                  _buildAchievementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF7ED957),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://picsum.photos/200',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ED957),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _profileData['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: Color(0xFF7ED957),
                    ),
                  ],
                ),
                Text(
                  _profileData['username'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7ED957).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _profileData['type'],
                    style: const TextStyle(
                      color: Color(0xFF7ED957),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _profileData['bio'],
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('24k', 'Followers'),
              _buildStatColumn('152', 'Following'),
              _buildStatColumn('12', 'Horses'),
              _buildStatColumn('86', 'Events'),
            ],
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFollowing = !_isFollowing;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing ? Colors.grey[200] : const Color(0xFF7ED957),
                foregroundColor: _isFollowing ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(_isFollowing ? 'Following' : 'Follow'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Implement message functionality
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF7ED957)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Message'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _profileData['achievements'].length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7ED957).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _profileData['achievements'][index],
                style: const TextStyle(
                  color: Color(0xFF7ED957),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorsesList() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _profileData['horses'].length,
        itemBuilder: (context, index) {
          final horse = _profileData['horses'][index];
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7ED957),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(horse['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  horse['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Posts'),
        Tab(text: 'Competitions'),
        Tab(text: 'Achievements'),
      ],
      labelColor: const Color(0xFF7ED957),
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color(0xFF7ED957),
    );
  }

  Widget _buildPostsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        return Image.network(
          'https://picsum.photos/200/200?random=$index',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildCompetitionsTab() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF7ED957).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Color(0xFF7ED957),
            ),
          ),
          title: Text('Competition ${index + 1}'),
          subtitle: Text('Date: ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
          trailing: const Text('1st Place 🥇'),
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return ListView.builder(
      itemCount: _profileData['achievements'].length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.star,
            color: Color(0xFF7ED957),
          ),
          title: Text(_profileData['achievements'][index]),
        );
      },
    );
  }

  void _shareProfile() {
    // Implement share functionality
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Profile'),
            onTap: () {
              Navigator.pop(context);
              _shareProfile();
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report Profile'),
            onTap: () {
              Navigator.pop(context);
              // Implement report functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block User'),
            onTap: () {
              Navigator.pop(context);
              // Implement block functionality
            },
          ),
        ],
      ),
    );
  }
} 