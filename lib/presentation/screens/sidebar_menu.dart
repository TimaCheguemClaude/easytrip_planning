import 'package:easytrip/presentation/screens/settings/settingscreen.dart';
import 'package:flutter/material.dart';
import 'package:easytrip/presentation/screens/loginscreen.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/utils/theme.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;

    return Drawer(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Back button and close drawer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // User profile section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/avatars/default.png'),
                      // If you don't have this asset, use a default icon:
                      // child: Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tima Claude',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'claudetima@email.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Menu items
            _buildMenuItem(
              context,
              icon: Icons.history,
              title: 'History',
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              icon: Icons.report_problem_outlined,
              title: 'Complain',
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              icon: Icons.people_alt_outlined,
              title: 'Referral',
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: 'Help and Support',
              onTap: () => Navigator.pop(context),
            ),

            const Divider(),

            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    final isDark = Provider.of<UiProvider>(context).isDark;
    final defaultColor = isDark ? Colors.white : Colors.black87;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? defaultColor),
      title: Text(title, style: TextStyle(color: textColor ?? defaultColor)),
      onTap: onTap,
    );
  }
}
