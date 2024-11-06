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
  String? _selectedBreed;
  String? _selectedGender;
  String? _selectedColor;
  DateTime? _birthDate;
  bool _isShowHorse = false;
  final List<String> _disciplines = [];

  final List<String> _breeds = [
    'Arabian',
    'Thoroughbred',
    'Quarter Horse',
    'Warmblood',
    'Friesian',
    'Andalusian',
    'Morgan',
    'Paint Horse',
    'Appaloosa',
  ];

  final List<String> _colors = [
    'Bay',
    'Chestnut',
    'Black',
    'Grey',
    'Palomino',
    'Buckskin',
    'Roan',
    'Pinto',
  ];

  final List<String> _availableDisciplines = [
    'Dressage',
    'Show Jumping',
    'Eventing',
    'Western Pleasure',
    'Trail Riding',
    'Reining',
    'Endurance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Horse' : 'Add New Horse'),
        actions: [
          TextButton.icon(
            onPressed: _saveHorse,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildImageSection(),
            const SizedBox(height: 24),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildPhysicalDetailsSection(),
            const SizedBox(height: 24),
            _buildShowDetailsSection(),
            const SizedBox(height: 24),
            _buildHealthSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage('https://picsum.photos/400/200'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () {
                // TODO: Implement image picker
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horse Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pets),
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
                    value: _selectedBreed,
                    decoration: const InputDecoration(
                      labelText: 'Breed',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _breeds.map((breed) {
                      return DropdownMenuItem(
                        value: breed,
                        child: Text(breed),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBreed = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickBirthDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _birthDate != null
                      ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                      : 'Select Date',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Stallion', child: Text('Stallion')),
                      DropdownMenuItem(value: 'Mare', child: Text('Mare')),
                      DropdownMenuItem(value: 'Gelding', child: Text('Gelding')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedColor,
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    items: _colors.map((color) {
                      return DropdownMenuItem(
                        value: color,
                        child: Text(color),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedColor = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Height (hands)',
                      border: OutlineInputBorder(),
                      suffixText: 'hh',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Weight (lbs)',
                      border: OutlineInputBorder(),
                      suffixText: 'lbs',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Show Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch(
                  value: _isShowHorse,
                  onChanged: (value) {
                    setState(() {
                      _isShowHorse = value;
                    });
                  },
                ),
              ],
            ),
            if (_isShowHorse) ...[
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Registration Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: _availableDisciplines.map((discipline) {
                  final isSelected = _disciplines.contains(discipline);
                  return FilterChip(
                    label: Text(discipline),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _disciplines.add(discipline);
                        } else {
                          _disciplines.remove(discipline);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medical Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Diet Requirements',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _saveHorse() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      Navigator.pop(context);
    }
  }
} 