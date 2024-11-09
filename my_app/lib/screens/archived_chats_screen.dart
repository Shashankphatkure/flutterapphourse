import 'package:flutter/material.dart';

class ArchivedChatsScreen extends StatelessWidget {
  const ArchivedChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search in archived chats
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://picsum.photos/200/200?random=$index',
            ),
          ),
          title: Text('Archived Chat ${index + 1}'),
          subtitle: Text(
            'Last message from archived chat ${index + 1}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'unarchive',
                child: Row(
                  children: [
                    Icon(Icons.unarchive),
                    SizedBox(width: 8),
                    Text('Unarchive'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'unarchive':
                  // Implement unarchive logic
                  break;
                case 'delete':
                  // Implement delete logic
                  break;
              }
            },
          ),
          onTap: () {
            // Navigate to archived chat
          },
        ),
      ),
    );
  }
} 