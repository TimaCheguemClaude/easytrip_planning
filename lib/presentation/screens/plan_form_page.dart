import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/mock_explore_data.dart';
import '../../utils/trip_storage.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';

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
    Provider.of<UiProvider>(context); // ensure rebuild on theme change
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_location_alt_outlined,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Plan Your Trip',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    size: 48,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Create Your Perfect Trip',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plan your adventure with ease',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Upload Section
                  _buildPhotoSection(theme),
                  const SizedBox(height: 24),
                  
                  // Trip Name
                  _buildFormField(
                    theme: theme,
                    controller: _tripNameController,
                    label: 'Trip Name',
                    hint: 'Enter your trip name',
                    icon: Icons.travel_explore,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),
                  
                  // Destination
                  _buildDropdownField(theme),
                  const SizedBox(height: 20),
                  
                  // Budget and Crew Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          theme: theme,
                          controller: _budgetController,
                          label: 'Budget',
                          hint: '0',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          suffix: 'FCFA',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          theme: theme,
                          controller: _crewController,
                          label: 'Crew Size',
                          hint: '1',
                          icon: Icons.people,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Date Range
                  _buildDateField(theme),
                  const SizedBox(height: 20),
                  
                  // Notes
                  _buildFormField(
                    theme: theme,
                    controller: _notesController,
                    label: 'Additional Notes',
                    hint: 'Any special requirements or notes...',
                    icon: Icons.note_alt,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  _buildSubmitButton(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_camera,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Trip Photo',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_pickedImage != null)
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(_pickedImage!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _pickedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to add photo',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? suffix,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          hintText: hint,
          suffixText: suffix,
          prefixIcon: Icon(icon, color: theme.colorScheme.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCity,
        items: MockExploreData.cityCategoryData.keys
            .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(
                    city,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (val) => setState(() => _selectedCity = val),
        decoration: InputDecoration(
          labelText: 'Destination *',
          prefixIcon: Icon(
            Icons.location_on,
            color: theme.colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        dropdownColor: theme.colorScheme.surface,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDateField(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _dateController,
        readOnly: true,
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            initialDateRange: _selectedDateRange,
            builder: (context, child) {
              return Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    primary: theme.primaryColor,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              _selectedDateRange = picked;
              _dateController.text =
                  '${picked.start.day}/${picked.start.month}/${picked.start.year} - '
                  '${picked.end.day}/${picked.end.month}/${picked.end.year}';
            });
          }
        },
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: 'Trip Dates *',
          hintText: 'Select your travel dates',
          prefixIcon: Icon(
            Icons.calendar_today,
            color: theme.colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          final tripName = _tripNameController.text.trim();
          final city = _selectedCity ?? '';
          final budget = double.tryParse(_budgetController.text.trim()) ?? 0.0;
          final dateRange = _selectedDateRange;
          final crew = int.tryParse(_crewController.text.trim()) ?? 1;
          final notes = _notesController.text.trim();
          
          if (tripName.isNotEmpty && city.isNotEmpty && dateRange != null) {
            final trip = {
              'name': tripName,
              'city': city,
              'budget': budget,
              'dateStart': dateRange.start.toIso8601String(),
              'dateEnd': dateRange.end.toIso8601String(),
              'crew': crew,
              'notes': notes,
              'savedCards': [],
              'image': _pickedImage?.path,
            };
            await TripStorage.saveTrip(trip);
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Trip planned successfully!'),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Please fill all required fields.'),
                  ],
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Create Trip',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
