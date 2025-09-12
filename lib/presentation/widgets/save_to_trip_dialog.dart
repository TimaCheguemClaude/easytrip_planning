import 'package:flutter/material.dart';

class SaveToTripDialog extends StatefulWidget {
  final List<String> trips;
  final ValueChanged<String> onTripSelected;
  const SaveToTripDialog({
    super.key,
    required this.trips,
    required this.onTripSelected,
  });

  @override
  State<SaveToTripDialog> createState() => _SaveToTripDialogState();
}

class _SaveToTripDialogState extends State<SaveToTripDialog> {
  String? selectedTrip;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save to Trip'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.trips.map(
            (trip) => RadioListTile<String>(
              title: Text(trip),
              value: trip,
              groupValue: selectedTrip,
              onChanged: (value) => setState(() => selectedTrip = value),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedTrip == null
              ? null
              : () {
                  widget.onTripSelected(selectedTrip!);
                  Navigator.pop(context);
                },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
