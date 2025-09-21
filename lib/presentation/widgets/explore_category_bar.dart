import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';

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
    
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MockExploreData.categories.length,
        itemBuilder: (context, index) {
          final cat = MockExploreData.categories[index];
          final isSelected = selectedCategory == cat;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(
                cat.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              selectedColor: theme.primaryColor,
              onSelected: (_) => onCategorySelected(cat),
              backgroundColor: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}