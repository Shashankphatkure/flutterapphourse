import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement group search
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _buildGroupItem(index),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(),
        label: const Text('Create Group'),
        icon: const Icon(Icons.group_add),
      ),
    );
  }

  Widget _buildGroupItem(int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.primaries[index % Colors.primaries.length],
        child: Text(
          'G${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text('Group ${index + 1}'),
      subtitle: Text('${3 + index} members'),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 8),
                Text('Edit Group'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'members',
            child: Row(
              children: [
                Icon(Icons.group),
                SizedBox(width: 8),
                Text('Members'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'leave',
            child: Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.red),
                SizedBox(width: 8),
                Text('Leave Group', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'edit':
              _showEditGroupDialog(index);
              break;
            case 'members':
              _showGroupMembers(index);
              break;
            case 'leave':
              _showLeaveGroupDialog(index);
              break;
          }
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatScreen(groupName: 'Group ${index + 1}'),
          ),
        );
      },
    );
  }

  void _showCreateGroupDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateGroupSheet(),
    );
  }

  void _showEditGroupDialog(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditGroupSheet(groupName: 'Group ${index + 1}'),
    );
  }

  void _showGroupMembers(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => GroupMembersSheet(groupName: 'Group ${index + 1}'),
    );
  }

  void _showLeaveGroupDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: Text('Are you sure you want to leave Group ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement leave group logic
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({super.key});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Create New Group',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Group Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Add Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 20,
                itemBuilder: (context, index) => CheckboxListTile(
                  value: _selectedMembers.contains('User $index'),
                  onChanged: (value) {
                    setState(() {
                      if (value ?? false) {
                        _selectedMembers.add('User $index');
                      } else {
                        _selectedMembers.remove('User $index');
                      }
                    });
                  },
                  title: Text('User $index'),
                  secondary: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/200/200?random=$index',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _selectedMembers.isEmpty ? null : () {
                // Implement create group logic
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(
                'Create Group (${_selectedMembers.length} members)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditGroupSheet extends StatefulWidget {
  final String groupName;

  const EditGroupSheet({
    super.key,
    required this.groupName,
  });

  @override
  State<EditGroupSheet> createState() => _EditGroupSheetState();
}

class _EditGroupSheetState extends State<EditGroupSheet> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.groupName);
    _descriptionController = TextEditingController(text: 'Group description...');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Edit Group',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Group Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // Implement update group logic
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}

class GroupMembersSheet extends StatelessWidget {
  final String groupName;

  const GroupMembersSheet({
    super.key,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$groupName Members',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/200/200?random=$index',
                  ),
                ),
                title: Text('User $index'),
                subtitle: Text(
                  index == 0 ? 'Admin' : 'Member',
                  style: TextStyle(
                    color: index == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
                trailing: index == 0
                    ? null
                    : PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'admin',
                            child: Text('Make Admin'),
                          ),
                          const PopupMenuItem(
                            value: 'remove',
                            child: Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          // Implement member management logic
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupChatScreen extends StatelessWidget {
  final String groupName;

  const GroupChatScreen({
    super.key,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(groupName),
            const Text(
              '10 members',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Implement group video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Implement group voice call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show group options
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Group Chat Implementation'),
      ),
    );
  }
} 