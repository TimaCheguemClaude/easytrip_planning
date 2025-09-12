import 'package:flutter/material.dart';
//import 'package:ai_health_assistant/theme/app_colors.dart';

class SlidingMenu extends StatefulWidget {
  final List<MenuOption> menuOptions;
  final String title;
  final String? version;

  const SlidingMenu({
    super.key,
    required this.menuOptions,
    this.title = 'Menu',
    this.version,
  });

  static void show(
    BuildContext context, {
    required List<MenuOption> menuOptions,
    String title = 'Menu',
    String? version,
  }) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) =>
          SlidingMenu(menuOptions: menuOptions, title: title, version: version),
    );

    overlayState.insert(overlayEntry);
  }

  @override
  State<SlidingMenu> createState() => _SlidingMenuState();
}

class _SlidingMenuState extends State<SlidingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeMenu() {
    _animationController.reverse().then((_) {
      // Remove the overlay entry when animation completes
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = screenWidth * 0.65;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final menuBgColor = theme.cardColor;
    final headerColor = theme.primaryColor;
    final iconColor = theme.primaryColor;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _closeMenu,
            child: Container(color: Colors.transparent),
          ),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 80,
                right: -menuWidth * _slideAnimation.value,
                width: menuWidth,
                child: child!,
              );
            },
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: menuBgColor,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(-3, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: headerColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _closeMenu,
                          ),
                        ],
                      ),
                    ),

                    // Menu options
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.menuOptions.length,
                        itemBuilder: (context, index) {
                          final option = widget.menuOptions[index];
                          return Column(
                            children: [
                              _buildOptionTile(
                                icon: option.icon,
                                title: option.title,
                                onTap: () {
                                  _closeMenu();
                                  option.onTap();
                                },
                              ),
                              if (index < widget.menuOptions.length - 1)
                                Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Version info at bottom
                    if (widget.version != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          widget.version!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
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
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final iconColor = theme.primaryColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}

class MenuOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuOption({required this.icon, required this.title, required this.onTap});
}
