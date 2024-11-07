import 'package:flutter/material.dart';
import 'add_horse_event_screen.dart';
import 'edit_horse_screen.dart';

class HorseDetailsScreen extends StatefulWidget {
  final String heroTag;

  const HorseDetailsScreen({
    super.key,
    required this.heroTag,
  });

  @override
  State<HorseDetailsScreen> createState() => _HorseDetailsScreenState();
}

class _HorseDetailsScreenState extends State<HorseDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  final List<String> _horseImages = [
    'https://picsum.photos/800/600?random=1',
    'https://picsum.photos/800/600?random=2',
    'https://picsum.photos/800/600?random=3',
  ];

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() => _showTitle = false);
    }
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
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: true,
              title: AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text('Thunder'),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: _buildImageCarousel(),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(context),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareHorseProfile(),
                ),
                _buildMoreMenu(),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.info_outline), text: 'Info'),
                    Tab(icon: Icon(Icons.medical_services_outlined), text: 'Health'),
                    Tab(icon: Icon(Icons.event_note_outlined), text: 'Training'),
                    Tab(icon: Icon(Icons.contact_phone_outlined), text: 'Contacts'),
                  ],
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(),
            _buildHealthTab(),
            _buildTrainingTab(),
            _buildContactsTab(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: _horseImages.length,
          onPageChanged: (index) {
            setState(() => _currentImageIndex = index);
          },
          itemBuilder: (context, index) {
            return Hero(
              tag: index == 0 ? widget.heroTag : 'horse_image_$index',
              child: Image.network(
                _horseImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _horseImages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildHorseInfo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorseInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBadge(),
          const SizedBox(height: 8),
          const Text(
            'Thunder',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.pets, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text(
                'Arabian Stallion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.cake, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text(
                '8 years old',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            'HEALTHY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'export',
          child: Text('Export Data'),
        ),
        const PopupMenuItem(
          value: 'archive',
          child: Text('Archive Horse'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(
            'Delete Horse',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
      onSelected: (value) {
        // Handle menu selection
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddEventBottomSheet(),
      icon: const Icon(Icons.add),
      label: const Text('Add Event'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditHorseScreen(isEditing: true),
      ),
    );
  }

  void _shareHorseProfile() {
    // Implement share functionality
  }

  void _showAddEventBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddHorseEventScreen(horseName: 'Thunder'),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          'Basic Information',
          [
            _buildInfoRow('Gender', 'Stallion'),
            _buildInfoRow('Color', 'Bay'),
            _buildInfoRow('Height', '15.2 hands'),
            _buildInfoRow('Weight', '1000 lbs'),
            _buildInfoRow('Registration', '#12345678'),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'Competition Details',
          [
            _buildInfoRow('Discipline', 'Dressage'),
            _buildInfoRow('Level', 'Advanced'),
            _buildInfoRow('Show Record', '15 wins'),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHealthCard(
          'Recent Health Records',
          [
            _buildHealthRecord(
              'Veterinary Check',
              'Dr. Smith',
              '15 March 2024',
              'Regular check-up - all clear',
              Colors.green,
            ),
            _buildHealthRecord(
              'Vaccination',
              'Dr. Johnson',
              '1 March 2024',
              'Annual flu vaccine',
              Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildHealthCard(
          'Upcoming Appointments',
          [
            _buildAppointment(
              'Dental Check',
              'Tomorrow, 10:00 AM',
              'Dr. Williams',
            ),
            _buildAppointment(
              'Farrier Visit',
              'Next Week, Tuesday',
              'John Smith',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrainingTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTrainingCard(
          'Progress',
          [
            _buildProgressBar('Dressage', 0.8),
            _buildProgressBar('Jumping', 0.6),
            _buildProgressBar('Ground Work', 0.9),
          ],
        ),
        const SizedBox(height: 16),
        _buildTrainingCard(
          'Recent Sessions',
          [
            _buildTrainingSession(
              'Dressage Training',
              'Sarah Johnson',
              '14 March 2024',
              'Worked on extended trot and canter transitions',
            ),
            _buildTrainingSession(
              'Jump Training',
              'Mike Thompson',
              '12 March 2024',
              'Grid work and course practice',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContactCard(
          'Primary Veterinarian',
          'Dr. Sarah Smith',
          '+1 (555) 123-4567',
          Icons.medical_services,
          Colors.red,
        ),
        _buildContactCard(
          'Farrier',
          'John Davidson',
          '+1 (555) 234-5678',
          Icons.build,
          Colors.brown,
        ),
        _buildContactCard(
          'Trainer',
          'Emily Wilson',
          '+1 (555) 345-6789',
          Icons.sports,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRecord(
    String title,
    String provider,
    String date,
    String notes,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(Icons.medical_services, color: color),
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(provider),
          Text(date, style: TextStyle(color: Colors.grey[600])),
          Text(notes, style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildAppointment(String title, String time, String provider) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.event),
      ),
      title: Text(title),
      subtitle: Text(provider),
      trailing: Text(
        time,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildProgressBar(String skill, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTrainingCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingSession(
    String title,
    String trainer,
    String date,
    String notes,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        child: Icon(
          Icons.sports,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trainer),
          Text(date, style: TextStyle(color: Colors.grey[600])),
          Text(notes, style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildContactCard(
    String role,
    String name,
    String phone,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role),
            Text(phone),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
} 