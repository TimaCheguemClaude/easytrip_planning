import 'package:easytrip/presentation/widgets/custom_button.dart';
import 'package:easytrip/presentation/widgets/custom_text_field.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/model/touristic_site.dart';
import '../../data/touristic_sites_dataset.dart';

class TripInputDialog extends StatefulWidget {
  final Function(UserPreferences) onSubmit;

  const TripInputDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<TripInputDialog> createState() => _TripInputDialogState();
}

class _TripInputDialogState extends State<TripInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();

  String? _selectedCity;
  int _numberOfPeople = 1;
  String? _selectedActivity;

  final List<String> _cities = TouristicSitesDataset.getAllCitiesIncludingExisting();
  final List<String> _activities = TouristicSitesDataset.getAllActivitiesIncludingExisting();

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeProvider.primaryBlue,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Get AI Recommendations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Form content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Budget field
                      CustomTextField(
                        controller: _budgetController,
                        labelText: 'Budget (CFA) *',
                        prefixIcon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your budget';
                          }
                          final budget = double.tryParse(value);
                          if (budget == null || budget <= 0) {
                            return 'Please enter a valid budget';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // City dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Preferred City *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: _cities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a city';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Number of people
                      const Text(
                        'Number of People *',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.people),
                                SizedBox(width: 8),
                                Text('People'),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _numberOfPeople > 1
                                      ? () => setState(() => _numberOfPeople--)
                                      : null,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(
                                  '$_numberOfPeople',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _numberOfPeople++),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Activity dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedActivity,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Activity *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.local_activity),
                        ),
                        items: _activities.map((activity) {
                          return DropdownMenuItem(
                            value: activity,
                            child: Text(activity),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedActivity = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an activity';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      CustomButton(
                        onPressed: _submitForm,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Get Recommendations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final preferences = UserPreferences(
        budget: double.parse(_budgetController.text),
        city: _selectedCity!,
        numberOfPeople: _numberOfPeople,
        preferredActivity: _selectedActivity!,
      );

      Navigator.of(context).pop();
      widget.onSubmit(preferences);

      // Haptic feedback
      HapticFeedback.lightImpact();
    }
  }
}
