import 'package:flutter/material.dart';
import 'horse_details_screen.dart';
import 'edit_horse_screen.dart';
import 'calendar_screen.dart';
import 'add_horse_event_screen.dart';

class HorsesScreen extends StatelessWidget {
  const HorsesScreen({super.key});

  static const List<Color> _gradientColors = [
    Color(0xFF1E88E5),
    Color(0xFF1565C0),
  ];

  void _navigateToCalendar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: HorseSearchDelegate(),
    );
  }

  void _showFilterOptions(BuildContext context) {
    // Implement filter options
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Horses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Add filter options here
          ],
        ),
      ),
    );
  }

  void _navigateToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddHorseEventScreen(horseName: 'Thunder'),
      ),
    );
  }

  void _navigateToHealthCheck(BuildContext context) {
    // Implement health check navigation
  }

  void _navigateToTraining(BuildContext context) {
    // Implement training navigation
  }

  void _navigateToDocuments(BuildContext context) {
    // Implement documents navigation
  }

  void _navigateToHorseDetails(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HorseDetailsScreen(
          heroTag: 'horse_card_$index',
        ),
      ),
    );
  }

  Widget _buildHorseImage(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage('https://picsum.photos/200'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHorseInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thunder',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Arabian Stallion',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          _buildNextEventBadge(context),
        ],
      ),
    );
  }

  Widget _buildHorseStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '8 yrs',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNextEventBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_available,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'Vet Visit Tomorrow',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditHorseScreen(),
          ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Add Horse'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            stretch: true,
            title: const Text('My Horses'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _gradientColors,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      bottom: -50,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(
                          Icons.pets,
                          size: 200,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _navigateToCalendar(context),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearch(context),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterOptions(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _buildStatisticsSection(context),
          ),
          SliverToBoxAdapter(
            child: _buildQuickActions(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildEnhancedHorseCard(context, index),
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(context),
    );
  }

  Widget _buildEnhancedHorseCard(BuildContext context, int index) {
    return Hero(
      tag: 'horse_card_$index',
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _navigateToHorseDetails(context, index),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHorseImage(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildHorseInfo(context),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _buildHorseStatus(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                _buildEnhancedStatCard(
                  context,
                  '6',
                  'Total Horses',
                  Icons.pets_rounded,
                  _gradientColors,
                ),
                const SizedBox(width: 16),
                _buildEnhancedStatCard(
                  context,
                  '2',
                  'Upcoming Events',
                  Icons.event_note_rounded,
                  const [Colors.orange, Colors.deepOrange],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    List<Color> gradientColors,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionCard(
                    context,
                    'Add Event',
                    Icons.event_available,
                    Colors.green,
                    () => _navigateToAddEvent(context),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Health Check',
                    Icons.medical_services,
                    Colors.red,
                    () => _navigateToHealthCheck(context),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Training',
                    Icons.sports,
                    Colors.purple,
                    () => _navigateToTraining(context),
                  ),
                  _buildQuickActionCard(
                    context,
                    'Documents',
                    Icons.description,
                    Colors.blue,
                    () => _navigateToDocuments(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorseSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return Container();
  }
} 