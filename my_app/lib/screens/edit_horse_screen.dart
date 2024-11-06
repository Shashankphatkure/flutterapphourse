import 'package:flutter/material.dart';

class EditHorseScreen extends StatefulWidget {
  final bool isEditing;
  
  const EditHorseScreen({
    super.key,
    this.isEditing = false,
  });

  @override
  State<EditHorseScreen> createState() => _EditHorseScreenState();
}

class _EditHorseScreenState extends State<EditHorseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Horse' : 'Add New Horse'),
        actions: [
          TextButton(
            onPressed: _saveHorse,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildImagePicker(),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horse Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Breed',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'arabian', child: Text('Arabian')),
                      DropdownMenuItem(value: 'thoroughbred', child: Text('Thoroughbred')),
                      DropdownMenuItem(value: 'quarter', child: Text('Quarter Horse')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'stallion', child: Text('Stallion')),
                      DropdownMenuItem(value: 'mare', child: Text('Mare')),
                      DropdownMenuItem(value: 'gelding', child: Text('Gelding')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'bay', child: Text('Bay')),
                      DropdownMenuItem(value: 'chestnut', child: Text('Chestnut')),
                      DropdownMenuItem(value: 'black', child: Text('Black')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picking
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                'Add Horse Photo',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveHorse() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      Navigator.pop(context);
    }
  }
} 