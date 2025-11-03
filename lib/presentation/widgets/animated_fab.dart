import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  final VoidCallback onCreateTrip;
  final VoidCallback? onChatBot;
  const AnimatedFloatingActionButton({
    super.key,
    required this.onCreateTrip,
    this.onChatBot,
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
    final l10n = AppLocalizations.of(context)!;
    final Color fabColor = Theme.of(context).colorScheme.primary;
    final bool hasChatBot = widget.onChatBot != null;
    
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
        // Chat Bot Button (if provided) - Shows at top when open
        if (hasChatBot)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: isOpen ? 200 : 56,
            right: 16,
            child: isOpen
                ? FloatingActionButton.extended(
                    heroTag: 'chat_bot',
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(l10n.aiAssistant),
                    onPressed: () {
                      _toggle();
                      widget.onChatBot?.call();
                    },
                    backgroundColor: fabColor,
                    foregroundColor: Colors.white,
                  )
                : const SizedBox.shrink(),
          ),
        // Create Trip Button - Shows below chat bot when both are present
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: isOpen ? 120 : 56,
          right: 16,
          child: isOpen
              ? FloatingActionButton.extended(
                  heroTag: 'create_trip',
                  icon: const Icon(Icons.add),
                  label: Text(l10n.createNewTrip),
                  onPressed: () {
                    _toggle();
                    widget.onCreateTrip();
                  },
                  backgroundColor: fabColor,
                  foregroundColor: Colors.white,
                )
              : const SizedBox.shrink(),
        ),
        // Main FAB
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
