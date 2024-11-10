import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Add these imports
import 'groups_screen.dart';
import 'archived_chats_screen.dart';
import 'message_settings_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            if (_isSearching) _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Implement refresh logic
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildChatList(),
                    _buildGroupsList(),
                    _buildRequestsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _isSearching ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.extended(
          onPressed: () => _showNewMessageDialog(context),
          label: const Text('New Message'),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: _isSearching
          ? null
          : const Row(
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Badge(
                  label: Text('3'),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            });
          },
        ),
        if (!_isSearching) ...[
          IconButton(
            icon: const Icon(Icons.filter_list, size: 28),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              switch (value) {
                case 'mark_all_read':
                  _markAllAsRead();
                  break;
                case 'archived':
                  _showArchivedChats();
                  break;
                case 'settings':
                  _openMessageSettings();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read, size: 20),
                    SizedBox(width: 8),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archived',
                child: Row(
                  children: [
                    Icon(Icons.archive, size: 20),
                    SizedBox(width: 8),
                    Text('Archived chats'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Message settings'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, size: 28),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search messages...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterOptions(context),
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onChanged: (value) {
          setState(() {
            // Implement search filtering
          });
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Chats'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Groups'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Requests'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildOnlinePeopleList();
        }
        return _buildChatItem(context, index - 1);
      },
    );
  }

  Widget _buildOnlinePeopleList() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/200/200?random=$index',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'User $index',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, int index) {
    final bool hasUnread = index < 5;
    final bool isTyping = index == 1;
    
    return Dismissible(
      key: Key('chat_$index'),
      background: _buildDismissBackground(Colors.blue, Icons.archive, false),
      secondaryBackground: _buildDismissBackground(Colors.red, Icons.delete, true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmationDialog(context);
        }
        // Archive chat
        return true;
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(userName: 'User ${index + 1}'),
            ),
          );
        },
        onLongPress: () {
          _showChatOptions(context, index);
        },
        child: ListTile(
          leading: Stack(
            children: [
              Hero(
                tag: 'avatar_$index',
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/200/200?random=$index',
                  ),
                ),
              ),
              if (index % 3 == 0)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'User ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '2h ago',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              if (isTyping)
                const Text(
                  'typing...',
                  style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                Expanded(
                  child: Text(
                    'Hey! How\'s Thunder doing? 🐎',
                    style: TextStyle(
                      color: hasUnread ? Colors.black : Colors.grey[600],
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (hasUnread)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(Color color, IconData icon, bool isEndToStart) {
    return Container(
      color: color,
      alignment: isEndToStart ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _buildGroupsList() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GroupsScreen(),
          ),
        );
      },
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) => _buildGroupItem(context, index),
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[200],
        child: Text(
          'G${index + 1}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        'Group ${index + 1}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('${3 + index} members'),
      trailing: index < 3
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )
          : null,
      onTap: () {
        // Navigate to group chat
      },
    );
  }

  Widget _buildRequestsList() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => _buildRequestItem(context, index),
    );
  }

  Widget _buildRequestItem(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(
          'https://picsum.photos/200/200?random=${index + 100}',
        ),
      ),
      title: Text(
        'New Request ${index + 1}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('${index + 1}m ago'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              // Accept request
            },
            child: const Text('Accept'),
          ),
          TextButton(
            onPressed: () {
              // Decline request
            },
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  Future<void> _showNewMessageDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NewMessageSheet(),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showChatOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_off),
            title: const Text('Mute notifications'),
            onTap: () {
              Navigator.pop(context);
              // Implement mute functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Archive chat'),
            onTap: () {
              Navigator.pop(context);
              // Implement archive functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block user'),
            onTap: () {
              Navigator.pop(context);
              // Implement block functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Delete chat',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    // Implement mark all as read functionality
  }

  void _showArchivedChats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ArchivedChatsScreen(),
      ),
    );
  }

  void _openMessageSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessageSettingsScreen(),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Filter Messages',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.mark_unread_chat_alt),
              title: const Text('Unread messages'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  Navigator.pop(context);
                  // Implement filter
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('With media'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  Navigator.pop(context);
                  // Implement filter
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('With links'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  Navigator.pop(context);
                  // Implement filter
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date range'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                // Show date range picker
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewMessageSheet extends StatelessWidget {
  const NewMessageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'New Message',
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
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Suggested',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Show all contacts
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/200/200?random=$index',
                        ),
                      ),
                      if (index % 2 == 0)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text('User $index'),
                  subtitle: Text(
                    index % 2 == 0 ? 'Online' : 'Last seen recently',
                    style: TextStyle(
                      color: index % 2 == 0 ? Colors.green : Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.message),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to chat with selected user
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String id;
  final String content;
  final bool isMine;
  final DateTime timestamp;
  final MessageStatus status;
  final String? mediaUrl;
  final MessageType type;

  Message({
    required this.id,
    required this.content,
    required this.isMine,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.mediaUrl,
    this.type = MessageType.text,
  });
}

enum MessageStatus { sending, sent, delivered, read }
enum MessageType { text, image, video, audio, file, location }

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isTyping = false;
  Timer? _typingTimer;
  bool _isRecording = false;
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    // Simulate loading messages from a backend
    setState(() {
      _messages.addAll(List.generate(
        20,
        (index) => Message(
          id: 'msg_$index',
          content: 'This is message #$index 💬',
          isMine: index % 2 == 0,
          timestamp: DateTime.now().subtract(Duration(minutes: index * 5)),
          status: index < 3 ? MessageStatus.sent : MessageStatus.read,
        ),
      ));
    });
  }

  void _handleTyping(String text) {
    if (text.isNotEmpty) {
      _typingTimer?.cancel();
      setState(() => _isTyping = true);
      _typingTimer = Timer(const Duration(seconds: 2), () {
        setState(() => _isTyping = false);
      });
    }
  }

  Future<void> _sendMessage(String content, {MessageType type = MessageType.text, String? mediaUrl}) async {
    if (content.isEmpty && mediaUrl == null) return;

    final message = Message(
      id: DateTime.now().toString(),
      content: content,
      isMine: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      mediaUrl: mediaUrl,
      type: type,
    );

    setState(() {
      _messages.insert(0, message);
      _messageController.clear();
    });

    // Simulate sending message
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      final index = _messages.indexOf(message);
      _messages[index] = Message(
        id: message.id,
        content: message.content,
        isMine: true,
        timestamp: message.timestamp,
        status: MessageStatus.delivered,
        mediaUrl: message.mediaUrl,
        type: message.type,
      );
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // Simulate uploading image
      await Future.delayed(const Duration(seconds: 2));
      _sendMessage(
        'Photo',
        type: MessageType.image,
        mediaUrl: image.path,
      );
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = 0;
    });
    
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
    });
    
    // Simulate sending audio message
    _sendMessage(
      'Audio message (${_recordingDuration}s)',
      type: MessageType.audio,
    );
  }

  Future<void> _shareContact() async {
    // Simulate contact picker
    await Future.delayed(const Duration(seconds: 1));
    _sendMessage(
      'Contact: John Doe\nPhone: +1 234 567 890',
      type: MessageType.text,
    );
  }

  Future<void> _shareLocation() async {
    // Simulate location picker
    await Future.delayed(const Duration(seconds: 1));
    const String googleMapsUrl = 'https://maps.google.com/?q=40.7128,-74.0060';
    _sendMessage(
      'Location: New York City\n$googleMapsUrl',
      type: MessageType.location,
    );
  }

  Future<void> _openMap(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Image.network(imageUrl),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context, Message message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment:
            message.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            _formatTimestamp(message.timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment:
                message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!message.isMine) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/200/200?random=${message.id.hashCode}',
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (message.type == MessageType.image) {
                      _showImagePreview(message.mediaUrl!);
                    } else if (message.type == MessageType.location) {
                      final url = message.content.split('\n').last;
                      _openMap(url);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMine
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: message.isMine ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              if (message.isMine) ...[
                const SizedBox(width: 4),
                Icon(
                  _getStatusIcon(message.status),
                  size: 16,
                  color: message.status == MessageStatus.read ? Colors.blue : Colors.grey,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _showAttachmentOptions(context),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: _isRecording 
                      ? 'Recording... ${_recordingDuration}s' 
                      : 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {
                      // Implement emoji picker
                    },
                  ),
                ),
                onChanged: _handleTyping,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onLongPress: _startRecording,
              onLongPressEnd: (_) => _stopRecording(),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  _messageController.text.isEmpty ? Icons.mic : Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.image,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    // Implement camera
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _shareLocation();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    // Implement document picker
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.music_note,
                  label: 'Audio',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _startRecording();
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.person,
                  label: 'Contact',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pop(context);
                    _shareContact();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Hero(
              tag: 'avatar_${widget.userName.hashCode}',
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/100/100'),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Implement voice call
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mute':
                  // Implement mute
                  break;
                case 'search':
                  // Implement search in chat
                  break;
                case 'media':
                  // Show shared media
                  break;
                case 'block':
                  // Block user
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mute',
                child: Row(
                  children: [
                    Icon(Icons.notifications_off, size: 20),
                    SizedBox(width: 8),
                    Text('Mute notifications'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20),
                    SizedBox(width: 8),
                    Text('Search in chat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'media',
                child: Row(
                  children: [
                    Icon(Icons.photo_library, size: 20),
                    SizedBox(width: 8),
                    Text('Shared media'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Block user', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(context, _messages[index]),
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }
} 