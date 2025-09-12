import 'package:flutter/material.dart';

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
    return Material(
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('Save', 0),
          _buildTab('Itinerary', 1),
          _buildTab('For You', 2),
          _buildTab('Wallet', 3),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selectedIndex == index
                ? FontWeight.bold
                : FontWeight.normal,
            color: selectedIndex == index ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}
