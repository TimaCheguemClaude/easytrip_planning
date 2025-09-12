import 'package:flutter/material.dart';

class ItineraryTimeline extends StatefulWidget {
  final List<Map<String, dynamic>> activities;
  const ItineraryTimeline({super.key, required this.activities});

  @override
  State<ItineraryTimeline> createState() => _ItineraryTimelineState();
}

class _ItineraryTimelineState extends State<ItineraryTimeline> {
  late List<Map<String, dynamic>> _sortedActivities;

  @override
  void initState() {
    super.initState();
    _sortedActivities = List<Map<String, dynamic>>.from(widget.activities);
    _sortedActivities.sort(
      (a, b) =>
          (a['time'] as TimeOfDay?)?.hour.compareTo(
            (b['time'] as TimeOfDay?)?.hour ?? 0,
          ) ??
          0,
    );
  }

  void _markDone(int index) {
    setState(() {
      _sortedActivities[index]['done'] =
          !(_sortedActivities[index]['done'] ?? false);
    });
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _sortedActivities[index]['time'] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _sortedActivities[index]['time'] = picked;
        _sortedActivities.sort(
          (a, b) =>
              (a['time'] as TimeOfDay?)?.hour.compareTo(
                (b['time'] as TimeOfDay?)?.hour ?? 0,
              ) ??
              0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sortedActivities.length,
      itemBuilder: (context, i) {
        final act = _sortedActivities[i];
        final isDone = act['done'] ?? false;
        final time = act['time'] as TimeOfDay?;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (i < _sortedActivities.length - 1)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 4,
                      height: 40,
                      color: _sortedActivities[i + 1]['done'] ?? false
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Card(
                color: isDone ? Colors.green[50] : null,
                child: ListTile(
                  leading: act['image'] != null
                      ? Image.asset(
                          act['image'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.place),
                  title: Text(act['name'] ?? ''),
                  subtitle: Row(
                    children: [
                      Text(time != null ? time.format(context) : 'Set time'),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _pickTime(i),
                        tooltip: 'Select time',
                      ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: isDone,
                    onChanged: (_) => _markDone(i),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
