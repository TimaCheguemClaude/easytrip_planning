import 'package:flutter/material.dart';
import 'package:easytrip/presentation/widgets/custom_button.dart';
import 'package:easytrip/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:easytrip/utils/theme.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.passwordUpdatedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<UiProvider>(context).isDark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changePassword), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _oldPasswordController,
                labelText: l10n.oldPassword,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureOldPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureOldPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureOldPassword = !_obscureOldPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterOldPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _newPasswordController,
                labelText: l10n.newPassword,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterNewPassword;
                  }
                  if (value.length < 8) {
                    return l10n.passwordMustBeAtLeast8Characters;
                  }
                  if (value == _oldPasswordController.text) {
                    return l10n.newPasswordCannotBeSameAsOld;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: l10n.confirmPassword,
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseConfirmNewPassword;
                  }
                  if (value != _newPasswordController.text) {
                    return l10n.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                onPressed: _isLoading ? null : _savePassword,
                backgroundColor: Theme.of(context).primaryColor,
                height: 50,
                borderRadius: 8,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.save,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
