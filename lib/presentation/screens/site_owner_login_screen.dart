import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'site_owner_dashboard_screen.dart';

class SiteOwnerLoginScreen extends StatefulWidget {
  const SiteOwnerLoginScreen({super.key});

  @override
  State<SiteOwnerLoginScreen> createState() => _SiteOwnerLoginScreenState();
}

class _SiteOwnerLoginScreenState extends State<SiteOwnerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Mock credentials for demonstration
  static const String _mockEmail = 'owner@easytrip.com';
  static String _mockPassword = 'admin123';

  @override
  void initState() {
    super.initState();
    // Auto-fill with demo credentials
    _emailController.text = _mockEmail;
    _passwordController.text = _mockPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<UiProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.siteOwnerLogin),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo/Icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: themeProvider.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business,
                  size: 60,
                  color: themeProvider.primaryBlue,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                l10n.welcomeBack,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                l10n.manageBookings,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      labelText: l10n.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterEmail;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return l10n.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _passwordController,
                      labelText: l10n.password,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Login Button
                    CustomButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  l10n.loading,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              l10n.signIn,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Mock authentication
    if (email == _mockEmail && password == _mockPassword) {
      if (!mounted) return;

      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SiteOwnerDashboardScreen(),
        ),
      );
    } else {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showErrorSnackBar(AppLocalizations.of(context)!.invalidCredentials);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
