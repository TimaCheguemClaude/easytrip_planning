import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class ComplainPage extends StatefulWidget {
  const ComplainPage({super.key});

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _submitting = false;

  Future<void> _submitComplain() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final message = Uri.encodeComponent(_controller.text.trim());
    final url = 'https://wa.me/237656195558?text=$message';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp.')));
    }
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.complain),
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.submitComplain,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: l10n.yourComplain,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterComplain;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_submitting ? l10n.submitting : l10n.submit),
                  onPressed: _submitting ? null : _submitComplain,
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
      ),
    );
  }
}
