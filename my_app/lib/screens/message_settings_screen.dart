import 'package:flutter/material.dart';

class MessageSettingsScreen extends StatefulWidget {
  const MessageSettingsScreen({super.key});

  @override
  State<MessageSettingsScreen> createState() => _MessageSettingsScreenState();
}

class _MessageSettingsScreenState extends State<MessageSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _messagePreview = true;
  bool _readReceipts = true;
  String _chatBackup = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(
            title: 'Notifications',
            children: [
              SwitchListTile(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() => _notificationsEnabled = value);
                },
                title: const Text('Message Notifications'),
                subtitle: const Text('Receive notifications for new messages'),
              ),
              SwitchListTile(
                value: _messagePreview,
                onChanged: (value) {
                  setState(() => _messagePreview = value);
                },
                title: const Text('Message Preview'),
                subtitle: const Text('Show message content in notifications'),
              ),
            ],
          ),
          _buildSection(
            title: 'Privacy',
            children: [
              SwitchListTile(
                value: _readReceipts,
                onChanged: (value) {
                  setState(() => _readReceipts = value);
                },
                title: const Text('Read Receipts'),
                subtitle: const Text("Show when you've read messages"),
              ),
              ListTile(
                title: const Text('Blocked Users'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to blocked users screen
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Chat Backup',
            children: [
              ListTile(
                title: const Text('Backup Frequency'),
                subtitle: Text(_chatBackup),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showBackupOptions(),
              ),
              ListTile(
                title: const Text('Backup Now'),
                trailing: const Icon(Icons.backup),
                onTap: () {
                  // Implement backup logic
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Chat History',
            children: [
              ListTile(
                title: const Text('Export Chat History'),
                trailing: const Icon(Icons.download),
                onTap: () {
                  // Implement export logic
                },
              ),
              ListTile(
                title: const Text('Clear All Chats'),
                trailing: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: () => _showClearConfirmation(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showBackupOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Daily'),
            trailing: _chatBackup == 'Daily' ? const Icon(Icons.check) : null,
            onTap: () {
              setState(() => _chatBackup = 'Daily');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Weekly'),
            trailing: _chatBackup == 'Weekly' ? const Icon(Icons.check) : null,
            onTap: () {
              setState(() => _chatBackup = 'Weekly');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Monthly'),
            trailing: _chatBackup == 'Monthly' ? const Icon(Icons.check) : null,
            onTap: () {
              setState(() => _chatBackup = 'Monthly');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Never'),
            trailing: _chatBackup == 'Never' ? const Icon(Icons.check) : null,
            onTap: () {
              setState(() => _chatBackup = 'Never');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Chats'),
        content: const Text(
          'Are you sure you want to clear all chat history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement clear all chats logic
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
} 