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
  String _selectedGender = 'Stallion';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horse Details'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildImageUpload(),
            const SizedBox(height: 16),
            _buildTextField('Name'),
            const SizedBox(height: 12),
            _buildTextField('Registered Name'),
            const SizedBox(height: 12),
            _buildTextField('Age'),
            const SizedBox(height: 12),
            _buildTextField('Breed'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField('Colour')),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Height')),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Gender',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            _buildGenderSelector(),
            const SizedBox(height: 24),
            Text(
              'Identification Details (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Describe unique features, markings, et...', maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField('Passport Issuer'),
            const SizedBox(height: 12),
            _buildTextField('Passport Number'),
            const SizedBox(height: 12),
            _buildTextField('UELN (Life Number)'),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveHorse,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7ED957),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Add [horse]'),
        ),
      ),
    );
  }

  Widget _buildImageUpload() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF7ED957),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Wrap(
      spacing: 8,
      children: [
        _buildGenderChip('Stallion'),
        _buildGenderChip('Mare'),
        _buildGenderChip('Gelding'),
        _buildGenderChip('Filly'),
        _buildGenderChip('Colt'),
      ],
    );
  }

  Widget _buildGenderChip(String gender) {
    final isSelected = _selectedGender == gender;
    return FilterChip(
      label: Text(gender),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedGender = gender;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFE8F7E5),
      checkmarkColor: const Color(0xFF7ED957),
      side: BorderSide(
        color: isSelected ? const Color(0xFF7ED957) : Colors.grey[300]!,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
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