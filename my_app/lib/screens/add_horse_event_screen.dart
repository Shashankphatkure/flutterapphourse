import 'package:flutter/material.dart';

class AddHorseEventScreen extends StatefulWidget {
  final String horseName;
  
  const AddHorseEventScreen({
    super.key,
    required this.horseName,
  });

  @override
  State<AddHorseEventScreen> createState() => _AddHorseEventScreenState();
}

class _AddHorseEventScreenState extends State<AddHorseEventScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedType = 'Vet Visit';

  final List<String> _eventTypes = [
    'Vet Visit',
    'Farrier',
    'Dental Check',
    'Vaccination',
    'Deworming',
    'Training Session',
    'Competition',
    'Other'
  ];

  // Add these improvements to the AddHorseEventScreen

  // Add reminder functionality
  bool _setReminder = false;
  int _reminderMinutes = 30;

  // Add recurring event functionality
  bool _isRecurring = false;
  String _recurrencePattern = 'weekly';

  final List<String> _eventCategories = [
    'Medical',
    'Training',
    'Competition',
    'Maintenance',
    'Other',
  ];

  String _selectedCategory = 'Medical';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Event for ${widget.horseName}'),
          actions: [
            TextButton.icon(
              onPressed: _saveEvent,
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildEventTypeSelector(),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventDetails(),
                      const SizedBox(height: 24),
                      _buildDateTimeSection(),
                      const SizedBox(height: 24),
                      _buildReminderSection(),
                      const SizedBox(height: 24),
                      _buildRecurrenceSection(),
                      const SizedBox(height: 24),
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTypeSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _eventCategories.length,
        itemBuilder: (context, index) {
          final category = _eventCategories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                InkWell(
                  onTap: () => _selectCategory(category),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      Navigator.pop(context);
    }
  }

  Widget _buildReminderSection() {
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
                  'Set Reminder',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: _setReminder,
                  onChanged: (value) {
                    setState(() {
                      _setReminder = value;
                    });
                  },
                ),
              ],
            ),
            if (_setReminder) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _reminderMinutes,
                decoration: const InputDecoration(
                  labelText: 'Remind me before',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 15, child: Text('15 minutes')),
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                  DropdownMenuItem(value: 60, child: Text('1 hour')),
                  DropdownMenuItem(value: 120, child: Text('2 hours')),
                  DropdownMenuItem(value: 1440, child: Text('1 day')),
                ],
                onChanged: (value) {
                  setState(() {
                    _reminderMinutes = value!;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecurrenceSection() {
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
                  'Recurring Event',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                ),
              ],
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _recurrencePattern,
                decoration: const InputDecoration(
                  labelText: 'Repeat',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                ],
                onChanged: (value) {
                  setState(() {
                    _recurrencePattern = value!;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Event Title',
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an event title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedType,
          decoration: const InputDecoration(
            labelText: 'Event Type',
            prefixIcon: Icon(Icons.category),
          ),
          items: _eventTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date'),
          subtitle: Text(
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          ),
          onTap: _pickDate,
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Time'),
          subtitle: Text(
            '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
          ),
          onTap: _pickTime,
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Notes',
        prefixIcon: Icon(Icons.note),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Medical':
        return Icons.medical_services;
      case 'Training':
        return Icons.sports;
      case 'Competition':
        return Icons.emoji_events;
      case 'Maintenance':
        return Icons.build;
      default:
        return Icons.event;
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }
} 