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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfileImagePicker(),
              const SizedBox(height: 24),
              _buildProfileForm(),
              const SizedBox(height: 24),
              _buildPrivacySettings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _profileImage != null
                ? NetworkImage(_profileImage!)
                : const NetworkImage('https://picsum.photos/200'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Display Name',
            prefixIcon: Icon(Icons.person_outline),
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
          decoration: const InputDecoration(
            labelText: 'Bio',
            prefixIcon: Icon(Icons.info_outline),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Location',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Website',
            prefixIcon: Icon(Icons.link),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
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
          onChanged: (value) {
            setState(() {
              _isPrivateAccount = value;
            });
          },
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _profileImage = image.path;
      });
    }
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
} 