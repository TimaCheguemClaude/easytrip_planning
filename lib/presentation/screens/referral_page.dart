import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.referral),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.inviteFriends,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.referralDescription,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: Text(l10n.shareReferralLink),
                onPressed: () {
                  // You can implement sharing logic here
                  final link = 'https://easytrip.app/invite?ref=YOURCODE';
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.referralLink),
                      content: Text(
                        '${l10n.shareWithFriends}:\n$link',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                      ],
                    ),
                  );
                },
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
