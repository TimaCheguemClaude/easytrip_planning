import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class TripDetailNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  const TripDetailNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab(AppLocalizations.of(context)!.saveTab, 0),
          _buildTab(AppLocalizations.of(context)!.itinerary, 1),
          _buildTab(AppLocalizations.of(context)!.forYou, 2),
          _buildTab(AppLocalizations.of(context)!.wallet, 3),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = selectedIndex == index;
    
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        
        return InkWell(
          onTap: () => onTabSelected(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected 
                  ? theme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected 
                    ? theme.primaryColor 
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
