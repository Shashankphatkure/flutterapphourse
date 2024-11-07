import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        children: [
          _buildFAQSection(context),
          const Divider(),
          _buildContactSection(context),
          const Divider(),
          _buildResourcesSection(context),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I add a new horse?',
        'answer':
            'Go to the Horses tab and tap the + button at the bottom of the screen. Fill in your horse\'s details and tap Save.',
      },
      {
        'question': 'How do I schedule events?',
        'answer':
            'From your horse\'s profile, tap the + Event button. Choose the event type, set the date and time, and add any relevant details.',
      },
      {
        'question': 'How do I manage notifications?',
        'answer':
            'Go to Settings > Notifications to customize which notifications you receive and how you receive them.',
      },
      {
        'question': 'How do I edit my profile?',
        'answer':
            'Go to Settings > Edit Profile to update your personal information, photo, and preferences.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ExpansionPanelList.radio(
          children: faqs.map((faq) {
            return ExpansionPanelRadio(
              value: faq['question']!,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              },
              body: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(faq['answer']!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Contact Us',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('Email Support'),
          subtitle: const Text('support@equico.com'),
          onTap: () {
            // Launch email client
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat_outlined),
          title: const Text('Live Chat'),
          subtitle: const Text('Available 24/7'),
          onTap: () {
            // Open chat support
          },
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('Phone Support'),
          subtitle: const Text('+1 (555) 123-4567'),
          onTap: () {
            // Launch phone dialer
          },
        ),
      ],
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Resources',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.video_library_outlined),
          title: const Text('Video Tutorials'),
          onTap: () {
            // Open video tutorials
          },
        ),
        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: const Text('User Guide'),
          onTap: () {
            // Open user guide
          },
        ),
        ListTile(
          leading: const Icon(Icons.forum_outlined),
          title: const Text('Community Forum'),
          onTap: () {
            // Open community forum
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback_outlined),
          title: const Text('Submit Feedback'),
          onTap: () {
            // Open feedback form
          },
        ),
      ],
    );
  }
} 