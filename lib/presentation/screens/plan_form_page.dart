import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/mock_explore_data.dart';
import '../../utils/trip_storage.dart';

class PlanFormPage extends StatefulWidget {
  const PlanFormPage({super.key});

  @override
  State<PlanFormPage> createState() => _PlanFormPageState();
}

class _PlanFormPageState extends State<PlanFormPage> {
  final TextEditingController _tripNameController = TextEditingController();
  String? _selectedCity;
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _crewController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  File? _pickedImage;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      // Copy the image to the app's documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'trip_${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final savedImage = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName');
      setState(() {
        _pickedImage = savedImage;
      });
      // Save the new image path to the trip data if trip name is already set
      if (_tripNameController.text.isNotEmpty) {
        final trip = await TripStorage.getTrip(_tripNameController.text);
        if (trip != null) {
          trip['image'] = savedImage.path;
          await TripStorage.saveTrip(trip);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactiveBorderColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Your Trip'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trip Planner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Upload Photo'),
                  ),
                  const SizedBox(width: 12),
                  if (_pickedImage != null)
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.file(_pickedImage!, fit: BoxFit.cover),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tripNameController,
                decoration: InputDecoration(
                  labelText: 'Trip name',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: MockExploreData.cityCategoryData.keys
                    .map(
                      (city) =>
                          DropdownMenuItem(value: city, child: Text(city)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCity = val),
                decoration: InputDecoration(
                  labelText: 'Where to',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Estimated budget',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDateRange: _selectedDateRange,
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDateRange = picked;
                      _dateController.text =
                          '${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')} to '
                          '${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}';
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Trip dates',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _crewController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Crew size',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inactiveBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final tripName = _tripNameController.text.trim();
                    final city = _selectedCity ?? '';
                    final budget =
                        double.tryParse(_budgetController.text.trim()) ?? 0.0;
                    final dateRange = _selectedDateRange;
                    final crew = int.tryParse(_crewController.text.trim()) ?? 1;
                    final notes = _notesController.text.trim();
                    if (tripName.isNotEmpty &&
                        city.isNotEmpty &&
                        dateRange != null) {
                      final trip = {
                        'name': tripName,
                        'city': city,
                        'budget': budget,
                        'dateStart': dateRange.start.toIso8601String(),
                        'dateEnd': dateRange.end.toIso8601String(),
                        'crew': crew,
                        'notes': notes,
                        'savedCards': [],
                        'image':
                            _pickedImage?.path, // Save image path if picked
                      };
                      await TripStorage.saveTrip(trip);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Trip planned!')),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all required fields.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
              // Add a controller for the city field
            ],
          ),
        ),
      ),
    );
  }
}
