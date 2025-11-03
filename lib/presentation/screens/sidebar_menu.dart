import 'dart:io';

import 'package:easytrip/presentation/screens/about_us_page.dart';
import 'package:easytrip/presentation/screens/complain_page.dart';
import 'package:easytrip/presentation/screens/loginscreen.dart';
import 'package:easytrip/presentation/screens/referral_page.dart';
import 'package:easytrip/presentation/screens/settings/settingscreen.dart';
import 'package:easytrip/presentation/screens/site_owner_login_screen.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});
  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  String name = '';
  String email = '';
  String avatarUrl = '';
  File? avatarImageFile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAvatar = prefs.getString('profile_avatar') ?? '';
    File? avatarFile;
    if (savedAvatar.isNotEmpty) {
      final file = File(savedAvatar);
      if (await file.exists()) {
        avatarFile = file;
      }
    }
    setState(() {
      name = prefs.getString('profile_name') ?? 'John Doe';
      email = prefs.getString('profile_email') ?? 'john.doe@email.com';
      avatarUrl = savedAvatar;
      avatarImageFile = avatarFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;
    final l10n = AppLocalizations.of(context)!;

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
                    backgroundColor: Colors.blue.withOpacity(0.9),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          avatarImageFile != null &&
                              avatarImageFile!.existsSync()
                          ? FileImage(avatarImageFile!)
                          : (avatarUrl.isNotEmpty &&
                                        File(avatarUrl).existsSync()
                                    ? FileImage(File(avatarUrl))
                                    : const AssetImage('assets/default.jpg'))
                                as ImageProvider,
                      child:
                          (avatarImageFile == null ||
                                  !avatarImageFile!.existsSync()) &&
                              (avatarUrl.isEmpty ||
                                  !File(avatarUrl).existsSync())
                          ? Icon(Icons.person, size: 40, color: Colors.blue)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          email,
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
              title: l10n.history,
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              icon: Icons.report_problem_outlined,
              title: l10n.complain,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ComplainPage()),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.people_alt_outlined,
              title: l10n.referral,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReferralPage()),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: l10n.aboutUs,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              title: l10n.settingsTab,
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
              title: l10n.helpAndSupport,
              onTap: () => Navigator.pop(context),
            ),

            _buildMenuItem(
              context,
              icon: Icons.business,
              title: l10n.siteOwnerLogin,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SiteOwnerLoginScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: l10n.signOut,
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
