import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/main.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get current locale
      final currentLocale = Localizations.localeOf(context).languageCode;
      setState(() {
        _selectedLanguage = currentLocale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(tc.changeLanguage),
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildLanguageOption(
                  title: 'English',
                  subtitle: 'English',
                  flagAsset: 'assets/flag/en.jpg',
                  value: 'en',
                ),
                _buildLanguageOption(
                  title: 'French',
                  subtitle: 'Français',
                  flagAsset: 'assets/flag/fr.jpg',
                  value: 'fr',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedLanguage.isNotEmpty) {
                    // Set new locale
                    MyApp.setLocale(context, Locale(_selectedLanguage));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  tc.save,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String subtitle,
    required String flagAsset,
    required String value,
  }) {
    final isSelected = _selectedLanguage == value;

    return ListTile(
      leading: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(flagAsset),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue, size: 24)
          : const Icon(Icons.circle_outlined, color: Colors.grey, size: 24),
      onTap: () {
        setState(() {
          _selectedLanguage = value;
        });
      },
    );
  }
}
