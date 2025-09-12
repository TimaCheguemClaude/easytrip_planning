import 'package:easytrip/presentation/screens/settings/languagescreen.dart';
import 'package:easytrip/presentation/screens/settings/privacy_policy%20screen.dart';
import 'package:flutter/material.dart';
import 'package:easytrip/presentation/screens/settings/change_password_screen.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final isDark = themeProvider.isDark;
    final tc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(tc.settings),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsItem(
            context,
            title: tc.changePassword,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          _buildSettingsItem(
            context,
            title: tc.changeLanguage,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSelectionScreen(),
                ),
              );
            },
          ),

          _buildSettingsItem(
            context,
            title: tc.privacyPolicy,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),

          _buildSettingsItem(context, title: tc.contactUs, onTap: () {}),

          _buildSettingsItem(
            context,
            title: tc.deleteAccount,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(tc.deleteAccount),
                  content: Text(tc.deleteAccountConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(tc.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement account deletion
                        Navigator.pop(context);
                      },
                      child: Text(
                        tc.delete,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Dark mode toggle
          SwitchListTile(
            title: Text(
              tc.darkTheme,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            value: isDark,
            activeColor: Colors.blue,
            onChanged: (value) => themeProvider.changeTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Provider.of<UiProvider>(context).isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
