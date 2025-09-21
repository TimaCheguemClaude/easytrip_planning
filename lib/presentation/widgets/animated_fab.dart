import 'package:flutter/material.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  final VoidCallback onCreateTrip;
  final VoidCallback onBuildWithAI;
  const AnimatedFloatingActionButton({
    super.key,
    required this.onCreateTrip,
    required this.onBuildWithAI,
  });

  @override
  State<AnimatedFloatingActionButton> createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color fabColor = Theme.of(context).colorScheme.primary;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: null,
              ),
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: isOpen ? 120 : 56,
          right: 16,
          child: isOpen
              ? Row(
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'create_trip',
                      icon: const Icon(Icons.add),
                      label: const Text('Create a trip'),
                      onPressed: widget.onCreateTrip,
                      backgroundColor: fabColor,
                      foregroundColor: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    FloatingActionButton.extended(
                      heroTag: 'build_ai',
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Build a trip with AI'),
                      onPressed: widget.onBuildWithAI,
                      backgroundColor: fabColor,
                      foregroundColor: Colors.white,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'main_fab',
            onPressed: _toggle,
            backgroundColor: fabColor,
            foregroundColor: Colors.white,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isOpen
                  ? const Icon(Icons.close, key: ValueKey('close'))
                  : const Icon(Icons.add, key: ValueKey('add')),
            ),
          ),
        ),
      ],
    );
  }
}
