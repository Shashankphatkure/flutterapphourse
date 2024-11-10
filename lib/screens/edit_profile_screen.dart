import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _profileImage;
  bool _isPrivateAccount = false;
  bool _showActivityStatus = true;
  bool _allowTagging = true;
  bool _allowMentions = true;

  final TextEditingController _displayNameController = TextEditingController(text: 'Sarah Anderson');
  final TextEditingController _usernameController = TextEditingController(text: '@equestrianlife');
  final TextEditingController _bioController = TextEditingController(
    text: '🐎 Living my dream with horses\n'
         '🏆 National Dressage Champion 2023\n'
         '📍 Wellington Equestrian Center\n'
         '🔗 equestrian.life/sarah',
  );
  final TextEditingController _locationController = TextEditingController(text: 'Wellington, FL');
  final TextEditingController _websiteController = TextEditingController(text: 'equestrian.life/sarah');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileImageSection(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    const SizedBox(height: 24),
                    _buildBioSection(),
                    const SizedBox(height: 24),
                    _buildPrivacySection(),
                    const SizedBox(height: 24),
                    _buildNotificationsSection(),
                    const SizedBox(height: 24),
                    _buildDangerZone(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                image: DecorationImage(
                  image: _profileImage != null
                      ? NetworkImage(_profileImage!)
                      : const NetworkImage('https://picsum.photos/200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  onPressed: _showImagePickerOptions,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _displayNameController,
          decoration: const InputDecoration(
            labelText: 'Display Name',
            prefixIcon: Icon(Icons.person_outline),
            helperText: 'This is how your name will appear to others',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your display name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.alternate_email),
            helperText: 'Your unique username on the platform',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            labelText: 'Location',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _websiteController,
          decoration: const InputDecoration(
            labelText: 'Website',
            prefixIcon: Icon(Icons.link),
          ),
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _showEmojiPicker,
              icon: const Icon(Icons.emoji_emotions_outlined),
              label: const Text('Add Emoji'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 150,
          decoration: const InputDecoration(
            hintText: 'Tell us about yourself...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SwitchListTile(
          title: const Text('Private Account'),
          subtitle: const Text('Only approved followers can see your posts'),
          value: _isPrivateAccount,
          onChanged: (value) => setState(() => _isPrivateAccount = value),
        ),
        SwitchListTile(
          title: const Text('Activity Status'),
          subtitle: const Text('Show when you were last active'),
          value: _showActivityStatus,
          onChanged: (value) => setState(() => _showActivityStatus = value),
        ),
        SwitchListTile(
          title: const Text('Allow Tagging'),
          subtitle: const Text('Let others tag you in their posts'),
          value: _allowTagging,
          onChanged: (value) => setState(() => _allowTagging = value),
        ),
        SwitchListTile(
          title: const Text('Allow Mentions'),
          subtitle: const Text('Let others mention you in comments'),
          value: _allowMentions,
          onChanged: (value) => setState(() => _allowMentions = value),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Manage email notification preferences'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to email notifications settings
          },
        ),
        ListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Manage push notification preferences'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Navigate to push notifications settings
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danger Zone',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        ListTile(
          title: const Text('Deactivate Account'),
          subtitle: const Text('Temporarily disable your account'),
          leading: const Icon(Icons.pause_circle_outline, color: Colors.orange),
          onTap: _showDeactivateDialog,
        ),
        ListTile(
          title: const Text('Delete Account'),
          subtitle: const Text('Permanently delete your account and all data'),
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          onTap: _showDeleteDialog,
        ),
      ],
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          if (_profileImage != null)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo'),
              onTap: () {
                setState(() => _profileImage = null);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      setState(() {
        _profileImage = image.path;
      });
    }
  }

  void _showEmojiPicker() {
    // Implement emoji picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emoji picker coming soon!')),
    );
  }

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text(
          'Are you sure you want to deactivate your account? '
          'You can reactivate it anytime by logging in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement deactivate logic
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete logic
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement profile saving logic
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
} 