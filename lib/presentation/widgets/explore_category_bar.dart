import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import '../../utils/theme.dart';

class ExploreCategoryBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  const ExploreCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lightBlue = theme.brightness == Brightness.dark
        ? const Color(0xFF64B5F6)
        : const Color(0xFF64B5F6); // fallback if not using UiProvider
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: MockExploreData.categories.map((cat) {
            final isSelected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(cat.replaceAll('_', ' ').toUpperCase()),
                selected: isSelected,
                selectedColor: lightBlue,
                onSelected: (_) => onCategorySelected(cat),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
