import 'package:flutter/material.dart';
import 'add_horse_event_screen.dart';

class HorseDetailsScreen extends StatelessWidget {
  const HorseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://placeholder.com/800x600',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thunder',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Navigate to edit screen
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Arabian • 8 years old',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    'Basic Information',
                    [
                      _buildInfoRow('Gender', 'Stallion'),
                      _buildInfoRow('Color', 'Bay'),
                      _buildInfoRow('Height', '15.2 hands'),
                      _buildInfoRow('Weight', '1000 lbs'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    context,
                    'Health Records',
                    [
                      _buildInfoRow('Last Vet Visit', '15 March 2024'),
                      _buildInfoRow('Last Deworming', '1 March 2024'),
                      _buildInfoRow('Last Vaccination', '10 February 2024'),
                      _buildInfoRow('Last Dental', '5 January 2024'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildUpcomingEvents(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHorseEventScreen(
                horseName: 'Thunder', // TODO: Pass actual horse name
              ),
            ),
          );
        },
        label: const Text('Add Event'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> items) {
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

  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final date = 15 + index;
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.event),
                ),
                title: Text('Event ${index + 1}'),
                subtitle: Text('April $date, 2024'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to event details
                },
              ),
            );
          },
        ),
      ],
    );
  }
} 