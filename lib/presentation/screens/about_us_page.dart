import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  static const String repoUrl =
      'https://github.com/TimaCheguemClaude/easytrip_planning.git';

  Future<void> _confirmAndLaunchRepo(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.leaveApp),
        content: Text(
          l10n.aboutToOpenRepository,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.continueAction),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final uri = Uri.parse(repoUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.couldNotOpenRepository)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutUs),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EasyTrip',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.aboutUsDescription,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.viewGitHubRepository),
                onPressed: () => _confirmAndLaunchRepo(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
