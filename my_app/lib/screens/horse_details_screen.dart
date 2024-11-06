import 'package:flutter/material.dart';
import 'add_horse_event_screen.dart';
import 'edit_horse_screen.dart';

class HorseDetailsScreen extends StatelessWidget {
  const HorseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'horse_image',
                        child: Image.network(
                          'https://picsum.photos/800/600',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 48,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusBadge(context),
                            const SizedBox(height: 8),
                            const Text(
                              'Thunder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Arabian • 8 years old',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildVerifiedBadge(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  tabs: const [
                    Tab(icon: Icon(Icons.info_outline), text: 'Info'),
                    Tab(icon: Icon(Icons.medical_services_outlined), text: 'Health'),
                    Tab(icon: Icon(Icons.event_note_outlined), text: 'Training'),
                    Tab(icon: Icon(Icons.contact_phone_outlined), text: 'Contacts'),
                  ],
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditHorseScreen(isEditing: true),
                        ),
                      );
                    },
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'share',
                        child: Text('Share Profile'),
                      ),
                      const PopupMenuItem(
                        value: 'export',
                        child: Text('Export Data'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Horse'),
                      ),
                    ],
                    onSelected: (value) {
                      // Handle menu selection
                    },
                  ),
                ],
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildInfoTab(context),
              _buildHealthTab(context),
              _buildTrainingTab(context),
              _buildContactsTab(context),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHorseEventScreen(
                  horseName: 'Thunder',
                ),
              ),
            );
          },
          label: const Text('Add Event'),
          icon: const Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.white,
            size: 16,
          ),
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

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.verified,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
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
          context,
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

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: items,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          'Recent Health Records',
          [
            _buildHealthRecord(
              context,
              'Veterinary Check',
              'Dr. Smith',
              '15 March 2024',
              'Regular check-up - all clear',
              Colors.green,
            ),
            _buildHealthRecord(
              context,
              'Vaccination',
              'Dr. Johnson',
              '1 March 2024',
              'Annual flu vaccine',
              Colors.blue,
            ),
            _buildHealthRecord(
              context,
              'Dental Check',
              'Dr. Williams',
              '15 February 2024',
              'Routine floating completed',
              Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          'Medications & Supplements',
          [
            _buildMedicationRow('Joint Supplement', 'Daily - 2 scoops'),
            _buildMedicationRow('Dewormer', 'Every 3 months'),
            _buildMedicationRow('Probiotic', 'Daily - 1 scoop'),
          ],
        ),
      ],
    );
  }

  Widget _buildTrainingTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          'Training Progress',
          [
            _buildProgressBar(context, 'Dressage', 0.8),
            _buildProgressBar(context, 'Jumping', 0.6),
            _buildProgressBar(context, 'Ground Work', 0.9),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          'Recent Sessions',
          [
            _buildTrainingSession(
              context,
              'Dressage Training',
              'Sarah Johnson',
              '14 March 2024',
              'Worked on extended trot and canter transitions',
            ),
            _buildTrainingSession(
              context,
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

  Widget _buildContactsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          context,
          'Emergency Contacts',
          [
            _buildContactCard(
              context,
              'Primary Veterinarian',
              'Dr. Sarah Smith',
              '+1 (555) 123-4567',
              Icons.medical_services,
              Colors.red,
            ),
            _buildContactCard(
              context,
              'Farrier',
              'John Davidson',
              '+1 (555) 234-5678',
              Icons.build,
              Colors.brown,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          'Care Team',
          [
            _buildContactCard(
              context,
              'Trainer',
              'Emily Wilson',
              '+1 (555) 345-6789',
              Icons.sports,
              Colors.blue,
            ),
            _buildContactCard(
              context,
              'Barn Manager',
              'Michael Brown',
              '+1 (555) 456-7890',
              Icons.home,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthRecord(
    BuildContext context,
    String title,
    String provider,
    String date,
    String notes,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.medical_services, color: color),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(provider),
            Text(
              date,
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              notes,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildMedicationRow(String medication, String dosage) {
    return ListTile(
      leading: const Icon(Icons.medication),
      title: Text(medication),
      subtitle: Text(dosage),
      trailing: IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          // TODO: Set medication reminder
        },
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, String skill, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
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
        ],
      ),
    );
  }

  Widget _buildTrainingSession(
    BuildContext context,
    String title,
    String trainer,
    String date,
    String notes,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
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
            Text(
              date,
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              notes,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String role,
    String name,
    String phone,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
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
              onPressed: () {
                // TODO: Implement messaging
              },
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // TODO: Implement calling
              },
            ),
          ],
        ),
      ),
    );
  }
} 