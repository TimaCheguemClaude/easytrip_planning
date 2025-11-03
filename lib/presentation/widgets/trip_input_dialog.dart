import 'package:easytrip/presentation/widgets/custom_text_field.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/l10n/app_localizations.dart';

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
  final List<String> _activities = [
    'City Tours',
    'Nature & Wildlife',
    'Cultural Sites',
    'Adventure Sports',
    'Shopping',
    'Dining',
    'Nightlife',
    'Accommodation',
    'Beach & Water Activities',
    'Historical Sites',
    'Art & Museums',
    'Religious Sites',
    'Photography',
    'Wellness & Spa',
    'Music & Entertainment',
    'Educational Tours',
    'Local Experiences',
  ];

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    Provider.of<UiProvider>(context); // ensure rebuild on theme change

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Minimalist Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.travel_explore,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.aiTripRecommendations,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Minimalist Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Budget field
                      CustomTextField(
                        controller: _budgetController,
                        labelText: '${l10n.budget} (CFA)',
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
                        decoration: InputDecoration(
                          labelText: l10n.selectCity,
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: theme.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                        items: _cities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(
                              city,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${l10n.numberOfPeople}:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _numberOfPeople > 1
                                    ? () => setState(() => _numberOfPeople--)
                                    : null,
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: _numberOfPeople > 1
                                      ? theme.primaryColor
                                      : theme.colorScheme.onSurface.withOpacity(0.4),
                                ),
                              ),
                              Text(
                                '$_numberOfPeople',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _numberOfPeople++),
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Activity dropdown - Fixed overflow with constraints
                      Container(
                        constraints: const BoxConstraints(maxWidth: double.infinity),
                        child: DropdownButtonFormField<String>(
                          value: _selectedActivity,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: l10n.selectActivity,
                            prefixIcon: Icon(
                              Icons.local_activity,
                              color: theme.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: _activities.map((activity) {
                            return DropdownMenuItem(
                              value: activity,
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  activity,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
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
                      ),
                      const SizedBox(height: 24),

                      // Minimalist Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.auto_awesome, size: 20),
                          label: Text(l10n.generateRecommendations),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
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
