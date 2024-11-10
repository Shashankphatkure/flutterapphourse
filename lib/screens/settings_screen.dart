import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'privacy_control_screen.dart';
import 'help_support_screen.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  Color _selectedPrimaryColor = const Color(0xFF1E88E5);

  final List<Color> _availableColors = [
    const Color(0xFF1E88E5), // Blue
    const Color(0xFF43A047), // Green
    const Color(0xFFE53935), // Red
    const Color(0xFF8E24AA), // Purple
    const Color(0xFFFFB300), // Amber
    const Color(0xFF00897B), // Teal
  ];

  final List<String> _availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Arabic',
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            _buildThemeSection(),
            const Divider(),
            _buildNotificationSection(),
            const Divider(),
            _buildPrivacySection(),
            const Divider(),
            _buildSupportSection(),
            const Divider(),
            _buildAccountSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Enable dark theme'),
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
              // TODO: Implement theme switching
            });
          },
        ),
        ListTile(
          title: const Text('App Color'),
          subtitle: const Text('Choose your preferred color theme'),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _selectedPrimaryColor,
              shape: BoxShape.circle,
            ),
          ),
          onTap: _showColorPicker,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            children: _availableColors.map((color) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedPrimaryColor = color;
                    // TODO: Implement color theme change
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedPrimaryColor == color
                          ? Colors.white
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _selectedPrimaryColor == color
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _showLanguagePicker,
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Enable or disable all notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        if (_notificationsEnabled) ...[
          CheckboxListTile(
            title: const Text('Event Reminders'),
            value: true,
            onChanged: (value) {},
          ),
          CheckboxListTile(
            title: const Text('Health Updates'),
            value: true,
            onChanged: (value) {},
          ),
          CheckboxListTile(
            title: const Text('Training Schedules'),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Privacy & Security',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Privacy Controls'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrivacyControlScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Change Password'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement password change
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Help & Support',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help Center'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HelpSupportScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.message_outlined),
          title: const Text('Contact Support'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement contact support
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Edit Profile'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to edit profile
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () {
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Theme Color',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _availableColors.map((color) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPrimaryColor = color;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Language',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...List.generate(
                _availableLanguages.length,
                (index) => ListTile(
                  title: Text(_availableLanguages[index]),
                  trailing: _selectedLanguage == _availableLanguages[index]
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = _availableLanguages[index];
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement logout
                Navigator.pop(context);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
} 