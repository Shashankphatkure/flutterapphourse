import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // Mark all as read
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Mentions'),
                ],
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNotificationsList(context),
                  _buildMentionsList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return _buildNotificationItem(context, index);
      },
    );
  }

  Widget _buildMentionsList(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildMentionItem(context, index);
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, int index) {
    final bool isUnread = index < 3;
    return Container(
      color: isUnread ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1) : null,
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/50/50?random=$index'),
            ),
            if (isUnread)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(
                text: 'User ${index + 1} ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: 'liked your post about Thunder\'s training session',
              ),
            ],
          ),
        ),
        subtitle: Text('${index + 1}h ago'),
        onTap: () {
          // Navigate to the relevant content
        },
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'turn_off',
              child: Text('Turn off notifications'),
            ),
            const PopupMenuItem(
              value: 'remove',
              child: Text('Remove this notification'),
            ),
          ],
          onSelected: (value) {
            // Handle menu selection
          },
        ),
      ),
    );
  }

  Widget _buildMentionItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://picsum.photos/50/50?random=${index + 100}'),
      ),
      title: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: 'User ${index + 1} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(
              text: 'mentioned you in a comment: ',
            ),
            TextSpan(
              text: '@username Great progress with Thunder! 🐎',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
      subtitle: Text('${index + 1}h ago'),
      onTap: () {
        // Navigate to the comment
      },
    );
  }
} 