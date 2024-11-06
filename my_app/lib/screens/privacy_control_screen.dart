import 'package:flutter/material.dart';

class PrivacyControlScreen extends StatefulWidget {
  const PrivacyControlScreen({super.key});

  @override
  State<PrivacyControlScreen> createState() => _PrivacyControlScreenState();
}

class _PrivacyControlScreenState extends State<PrivacyControlScreen> {
  bool _isProfilePublic = true;
  bool _showLocation = true;
  bool _allowMessages = true;
  String _selectedAgeRestriction = '13+';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Controls'),
      ),
      body: ListView(
        children: [
          _buildProfileSection(),
          const Divider(),
          _buildContentSection(),
          const Divider(),
          _buildSafetySection(),
          const Divider(),
          _buildBlockedUsersSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Profile Privacy',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SwitchListTile(
          title: const Text('Public Profile'),
          subtitle: Text(
            _isProfilePublic
                ? 'Anyone can see your profile'
                : 'Only approved followers can see your profile',
          ),
          value: _isProfilePublic,
          onChanged: (value) {
            setState(() {
              _isProfilePublic = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Show Location'),
          subtitle: const Text('Allow others to see your general location'),
          value: _showLocation,
          onChanged: (value) {
            setState(() {
              _showLocation = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Content Sharing',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          title: const Text('Who Can See My Posts'),
          subtitle: const Text('Everyone'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement post visibility settings
          },
        ),
        ListTile(
          title: const Text('Comment Settings'),
          subtitle: const Text('Allow comments from everyone'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement comment settings
          },
        ),
      ],
    );
  }

  Widget _buildSafetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Safety',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          title: const Text('Age Restriction'),
          subtitle: Text('Content visible to $_selectedAgeRestriction'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showAgeRestrictionPicker,
        ),
        SwitchListTile(
          title: const Text('Allow Messages'),
          subtitle: const Text('Receive messages from other users'),
          value: _allowMessages,
          onChanged: (value) {
            setState(() {
              _allowMessages = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBlockedUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Blocked Users',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          title: const Text('Manage Blocked Users'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement blocked users management
          },
        ),
      ],
    );
  }

  void _showAgeRestrictionPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Age Restriction',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...['All Ages', '13+', '16+', '18+'].map(
                (age) => ListTile(
                  title: Text(age),
                  trailing: _selectedAgeRestriction == age
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedAgeRestriction = age;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 